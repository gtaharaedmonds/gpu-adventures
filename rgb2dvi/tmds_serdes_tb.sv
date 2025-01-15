module tmds_serdes_tb;
  logic rst, serial_clk, pixel_clk;
  logic [9:0] din;
  logic dout;
  wire dout_p, dout_n;

  tmds_serdes uut (
      .rst(rst),
      .serial_clk(serial_clk),
      .pixel_clk(pixel_clk),
      .din(din),
      .dout(dout),
      .dout_p(dout_p),
      .dout_n(dout_n)
  );

  // Generate serial clock.
  initial serial_clk = 0;
  always #5 serial_clk = ~serial_clk;  // 10ns period (100MHz)

  // Generate pixel clock.
  initial pixel_clk = 0;
  always #25 pixel_clk = ~pixel_clk;  // 50ns period (20MHz)

  initial begin
    // Reset UUT.
    rst = 1;

    #100;
    rst = 0;
    din = 10'b1010101011;

    // Simulate and see what happens!
    #500;

    // Stop sim.
    $stop;
  end

endmodule
