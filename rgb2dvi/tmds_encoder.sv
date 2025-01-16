module tmds_encoder (
    input logic rst,
    input logic clk,
    // 8-bit pixel data input.
    input logic [7:0] din,
    // Control signals.
    input logic c0,
    c1,
    de,
    // 10-bit encoded data output.
    output logic [9:0] dout
);
  // Stage 1 signals.
  logic [7:0] din_1;
  logic [8:0] q_m_xor_1, q_m_xnor_1, q_m_1;
  logic [3:0] n1_din_1, n1_q_m_1;
  logic c0_1, c1_1, de_1;

  // Stage 2 signals.
  logic [8:0] q_m_2;
  logic [9:0] q_out_2;
  logic [3:0] n1_q_m_2, n0_q_m_2;
  logic c0_2, c1_2, de_2;
  logic signed [4:0] dc_bias_2, cnt_t_2, cnt_t_3;
  logic cond_balanced_2, cond_not_balanced_2;

  // Stage 3 signals.
  logic [9:0] q_out_3;

  always_ff @(posedge clk) begin
    din_1 <= din;
  end

  //
  // PIPELINE STAGE 1: Minimize transitions?
  //

  assign n1_din_1 = $countones(din_1);
  assign n1_q_m_1 = $countones(q_m_1);

  // Latch inputs.
  always_ff @(posedge clk) begin
    din_1 <= din;
    c0_1  <= c0;
    c1_1  <= c1;
    de_1  <= de;
  end

  // q_m XOR path.
  assign q_m_xor_1[0] = din_1[0];
  genvar i;
  generate
    for (i = 1; i < 8; i++) begin : gen_q_m_xor_1
      assign q_m_xor_1[i] = q_m_xor_1[i-1] ^ din_1[i];
    end
  endgenerate
  assign q_m_xor_1[8]  = 1;

  // q_m XNOR path.
  assign q_m_xnor_1[0] = din_1[0];
  generate
    for (i = 1; i < 8; i++) begin : gen_q_m_xnor_1
      assign q_m_xnor_1[i] = q_m_xnor_1[i-1] ~^ din_1[i];
    end
  endgenerate
  assign q_m_xnor_1[8] = 0;

  // Select XOR or XNOR path.
  always_comb begin
    if (n1_din_1 > 4 || (n1_din_1 == 4 && din_1[0] == 0)) begin
      q_m_1 = q_m_xor_1;
    end else begin
      q_m_1 = q_m_xnor_1;
    end
  end

  //
  // PIPELINE STAGE 2: Balance DC?
  //

  // Latch inputs.
  always_ff @(posedge clk) begin
    q_m_2 <= q_m_1;
    c0_2 <= c0_1;
    c1_2 <= c1_1;
    de_2 <= de_1;
    n1_q_m_2 <= n1_q_m_1;
    n0_q_m_2 <= 8 - n1_q_m_1;
  end

  // DC balanced output.
  assign cond_balanced_2 = cnt_t_3 == 0 || n1_q_m_2 == 4;

  assign cond_not_balanced_2 = (cnt_t_3 > 0 && n1_q_m_2 > 4) ||  // Too many 1s
      (cnt_t_3 < 0 && n1_q_m_2 < 4);  // Too many 0s

  always_comb begin
    if (de_2) begin
      unique case ({
        c1_2, c0_2
      })
        // Control signals.
        2'b00: q_out_2 = 10'b1101010100;
        2'b01: q_out_2 = 10'b0010101011;
        2'b10: q_out_2 = 10'b0101010100;
        2'b11: q_out_2 = 10'b1010101011;
      endcase
    end else if (cond_balanced_2) begin
      if (q_m_2[8] == 0) begin
        q_out_2 = {~q_m_2[8], q_m_2[8], ~q_m_2[7:0]};
      end else begin
        q_out_2 = {~q_m_2[8], q_m_2[8], q_m_2[7:0]};
      end
    end else if (cond_not_balanced_2) begin
      q_out_2 = {1'b1, q_m_2[8], ~q_m_2[7:0]};
    end else begin
      q_out_2 = {1'b0, q_m_2[8], q_m_2[7:0]};
    end
  end

  assign dc_bias_2 = $signed({1'b0, n0_q_m_2}) - $signed({1'b0, n1_q_m_2});

  always_comb begin
    if (de_2) begin
      cnt_t_2 = 0;
    end else if (cond_balanced_2) begin
      if (q_m_2[8] == 0) begin
        cnt_t_2 = cnt_t_3 + dc_bias_2;
      end else begin
        cnt_t_2 = cnt_t_3 - dc_bias_2;
      end
    end else if (cond_not_balanced_2) begin
      cnt_t_2 = cnt_t_3 + $signed(q_m_2[8] << 1) + dc_bias_2;
    end else begin
      cnt_t_2 = cnt_t_3 - $signed(q_m_2[8] << 1) - dc_bias_2;
    end
  end

  //
  // PIPELINE STAGE 3: Update state.
  //

  assign dout = q_out_3;

  always_ff @(posedge clk) begin
    cnt_t_3 <= cnt_t_2;
    q_out_3 <= q_out_2;
  end
endmodule
