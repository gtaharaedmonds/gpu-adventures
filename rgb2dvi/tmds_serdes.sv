// TMDS transmits 10-bit words serially over the wire, so we need a 10:1
// parallel-to-serial converter. Use the OSERDESE2 resource for high performance
// and minimal area usage. Note that each IO block has an OSERDES2 resource (I
// think they're built into the OLOGIC resources?).

module tmds_serdes (
    input logic rst,

    // Serial clock. Must be >=5x the pixel clk.
    // NOTE: 5x, not 10x, since the SERDES resources are configured in DDR
    // (double data rate)
    input logic serial_clk,
    // Divided clock, for incoming parallel data.
    input logic pixel_clk,

    input logic [PARALLEL_WIDTH-1:0] din,
    output logic dout,
    output wire dout_p,
    dout_n
);

  localparam int PARALLEL_WIDTH = 10;

  logic [1:0] cascade;

  // A single OSERDESE2 is only 8:1. use OSERDESE2 Width Expansion as per UG471,
  // which uses 2x OSERDESE2 resources (1x in master and 1x in slave).

  OSERDESE2 #(
      .DATA_RATE_OQ("DDR"),
      .DATA_RATE_TQ("SDR"),
      .DATA_WIDTH(PARALLEL_WIDTH),
      .SERDES_MODE("MASTER"),
      .TRISTATE_WIDTH(1),
      .TBYTE_CTL("FALSE"),
      .TBYTE_SRC("FALSE")
  ) oserdes2_master (
      .OQ(dout),
      .OFB(),
      .TQ(),
      .TFB(),
      .SHIFTOUT1(),
      .SHIFTOUT2(),
      .CLK(serial_clk),
      .CLKDIV(pixel_clk),
      .D1(din[0]),  // D1 shifted out first
      .D2(din[1]),
      .D3(din[2]),
      .D4(din[3]),
      .D5(din[4]),
      .D6(din[5]),
      .D7(din[6]),
      .D8(din[7]),
      .TCE(0),
      .OCE(1),
      .TBYTEIN(0),
      .TBYTEOUT(),
      .RST(rst),
      .SHIFTIN1(cascade[0]),
      .SHIFTIN2(cascade[1]),
      .T1(0),
      .T2(0),
      .T3(0),
      .T4(0)
  );

  OSERDESE2 #(
      .DATA_RATE_OQ("DDR"),
      .DATA_RATE_TQ("SDR"),
      .DATA_WIDTH(PARALLEL_WIDTH),
      .SERDES_MODE("SLAVE"),
      .TRISTATE_WIDTH(1),
      .TBYTE_CTL("FALSE"),
      .TBYTE_SRC("FALSE")
  ) oserdes2_slave (
      .OQ(),
      .OFB(),
      .TQ(),
      .TFB(),
      .SHIFTOUT1(cascade[0]),
      .SHIFTOUT2(cascade[1]),
      .CLK(serial_clk),
      .CLKDIV(pixel_clk),
      .D1(0),  // First 2 are 0 according to UG471
      .D2(0),
      .D3(din[8]),
      .D4(din[9]),
      .D5(0),
      .D6(0),
      .D7(0),
      .D8(0),
      .TCE(0),
      .OCE(1),
      .TBYTEIN(0),
      .TBYTEOUT(),
      .RST(rst),
      .SHIFTIN1(0),
      .SHIFTIN2(0),
      .T1(0),
      .T2(0),
      .T3(0),
      .T4(0)
  );

  OBUFDS #(
      .IOSTANDARD("TMDS_33")
  ) tmds_obufdss (
      .O (dout_p),
      .OB(dout_n),
      .I (dout)
  );

endmodule

