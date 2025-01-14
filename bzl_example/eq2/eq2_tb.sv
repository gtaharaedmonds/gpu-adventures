`timescale 1 ns / 10 ps

module eq2_tb;
  reg [1:0] test_in0, test_in1;
  wire test_out;

  eq2 uut (
      .a(test_in0),
      .b(test_in1),
      .aeqb(test_out)
  );

  initial begin
    // Test vector 1.
    test_in0 = 2'b00;
    test_in1 = 2'b00;
    #200;

    // Test vector 2.
    test_in0 = 2'b01;
    test_in1 = 2'b00;
    #200;

    // Test vector 3.
    test_in0 = 2'b01;
    test_in1 = 2'b11;
    #200;

    // Test vector 4.
    test_in0 = 2'b10;
    test_in1 = 2'b10;
    #200;

    // Test vector 5.
    test_in0 = 2'b10;
    test_in1 = 2'b00;
    #200;

    // Test vector 6.
    test_in0 = 2'b11;
    test_in1 = 2'b11;
    #200;

    // Test vector 7.
    test_in0 = 2'b11;
    test_in1 = 2'b01;
    #200;

    // Stop sim.
    $stop;
  end

endmodule
