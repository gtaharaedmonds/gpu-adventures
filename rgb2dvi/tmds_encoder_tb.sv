`timescale 1ns / 1ps

module tmds_encoder_tb;
  logic clk;
  logic [7:0] din;
  logic [9:0] dout;
  logic c0, c1, de;
  logic rst;

  tmds_encoder uut (
      .rst (rst),
      .clk (clk),
      .din (din),
      .c0  (c0),
      .c1  (c1),
      .de  (de),
      .dout(dout)
  );

  // Generate pixel clock.
  initial clk = 0;
  always #5 clk = ~clk;  // 10ns period (100MHz)

  initial begin
    // Reset UUT.
    rst = 1;

    #10;
    rst = 0;
    din = 8'b10101010;
    c0  = 0;
    c1  = 0;
    de  = 1;

    // Simulate and see what happens!
    #100;

    // Stop sim.
    $stop;
  end

endmodule
