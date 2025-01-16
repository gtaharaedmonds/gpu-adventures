# rgb2dvi

RTL to convert from parallel RGB to DVI.

## Parallel RGB

Parallel RGB is very simple. Colors are represented as unsigned ints of red,
green, and blue components. In a parallel interface, there are N parallel lines
for each of RGB, which encode the corresponding color's component at a specific
pixel. For example, 24-bit color has 8 bits each for RGB.

Parallel RGB also has a few control signals:
1. HSYNC: Indicates the start of a new row of pixels
2. VSYNC: Indicates the start of a new frame
3. DE: Data enable, which indicates whether to output pixel data or control
   signals

## HDMI

HDMI is essentially a few technologies working together:

1. DVI for video. DVI (digital visual interface) is a protocol for transmitting
   uncompressed video data via a cable. It uses TMDS (transition-minimized
   differential signalling) to send data over the wire.
2. Audio integration via various formats.
3. CEC (consumer electronics control). Extra metadata for controlling multiple
   devices.
4. Probably some other special sauce

HDMI is backwards-compatible with DVI so I'm just implementing DVI. HDMI special
sauce makes things a lot more complicated...

## DVI

For video, DVI uses 4x TMDS channels:

- 3x for red, green, and blue
- 1x for clock

For each clocked input of parallel RGB, a DVI transmitter will output either a data
token or a control token over each of its TMDS lines. Data tokens consist of
encoded 8-bit colors, and control tokens consist of HSYNC, VSYNC, etc. A DVI
receiver can then decode these tokens to parallel RGB to drive a display. 

Note that this means we need 2 clocks:
1. Pixel clock: For clocking pixel data (in parallel) into the DVI transmitter
2. Serial clock: For clocking tokens out (serially) of the DVI transmitter


## TMDS Protocol

Over the wire, each DVI uses 4x TMDS (transition minimized differential
signalling) pairs. TMDS uses a fancy encoding process whereby pixel data
(8b) or control data (2b) are encoded as 10b tokens.

### XOR/XNOR Encoding

The 8b data bytes have their bits XORed or XNORed together. XNOR is used if
there are >4 1s in the input, or if there are exactly 4 and the LSB is 0. A 9th
bit is added to encode if XOR or XNOR were used (1 for XOR, 0 for XNOR).

Apparently this reduces the number of transitions, which is important because:
1. Lots of high-speed transitions is bad for signal integrity
2. Reduces power draw from constantly charging/discharging the bus

### DC Balancing

The next step is to "DC balance" the data, with the goal of reducing the
difference between the number of 1s and 0s (also called the disparity).
Apparently this is important, not really sure why... The encoder keeps track of
a counter of the previous disparities, so while individual tokens may not be DC
balanced, the DC bias will even out over time.

At a high level:
1. If the signal is becoming positively DC biased (more 1s), invert the encoded
   data byte (ignore the XOR/XNOR bit).
2. If the signal is becoming negatively DC biased (more 0s), don't invert the
   byte.
3. Add an extra bit to determine if the data was inverted or not (1 if inverted,
   0 if not).

### Control Signals

For control signals, each of the 4x input combinations (there are 2 bits of
control data) has a dedicated 10b control word. If data enable is low, there are
simply looked up based on the control signals.

### Parallel to Serial Conversion

TMDS transmits the 10-bit words serially over the wire, so we need a 10:1 
parallel-to-serial converter. I'm using the OSERDESE2 resource for high
performance and minimal area usage. Note that each IO block has an OSERDES2
resource (I think they're built into the OLOGIC resources?).
