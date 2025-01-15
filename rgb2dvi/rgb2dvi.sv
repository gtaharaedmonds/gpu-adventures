/*
Parallel RGB is very simple. Colors are represented as unsigned ints of red,
green, and blue components. In a parallel interface, there are N parallel lines
for each of RGB, which encode the corresponding color's component at a specific
pixel. For example, 24-bit color has 8 bits each for RGB. Thus the lines encode
a certain pixel's color in parallel.

Parallel RGB also has a few control signals:
1. HSYNC: Indicates the start of a new row of pixels
2. VSYNC: Indicates the start of a new frame
3. Clock: Pixel data clock
4. DE: Data enable?

HDMI is essentially a few technologies working together:

1. DVI for video. DVI (digital visual interface) is a protocol for transmitting
   uncompressed video data via a cable. It uses TMDS (transition-minimized
   differential signalling) to send data over the wire.
2. Audio integration via various formats.
3. CEC (consumer electronics control). Extra metadata for controlling multiple
   devices.
4. Probably some other special sauce...

Note: HDMI is backwards-compatible with DVI-D.

For video, DVI uses 4x TMDS channels:

- 3x for red, green, and blue
- 1x for the clock

TMDS encoding looks very complicated!
*/

module rgb2dvi (
    output logic tsms
);


endmodule
