/* INTEGRATOR MODULE
   Implements a 4-stage CIC integrator chain.
   - converts 1-bit input to +1 / -1 (signed).
   - Each stage accumulates its input (running sum).
   - Output out_integrated_data is the final integrated result with extended word length (Computation bits).
*/

module integrator #(
    parameter Computation = 50
)(
   input  clk,
   input  reset,
   input  i_data,                                // 1-bit modulator input
   output signed [Computation-1:0] out_integrated_data
);

    // Signed representation of 1-bit input: +1 or -1
    reg  signed [Computation-1:0] conversion;

    // Internal buses for adder inputs/outputs between stages
    wire signed [Computation-1:0] delay_line_in[3:0];
    wire signed [Computation-1:0] delay_line_out[2:0];
    wire signed [Computation-1:0] dff_out[3:0];

    // 1-bit to +1 / -1 conversion 
    always @(posedge clk) begin
      if (i_data == 1'b1)
        conversion = 1;    // map logic '1' to +1
      else
        conversion = -1;   // map logic '0' to -1
    end

    //INTEGRATOR STAGE 1
    // out_1[n] = out_1[n-1] + conv
    adder ad1(conversion, dff_out[0], delay_line_in[0]);
    dff #(.Computation(50)) dut1(clk, reset, 1'b1, delay_line_in[0], dff_out[0]);
    dff #(.Computation(50)) dut2(clk, reset, 1'b1, delay_line_in[0], delay_line_out[0]);

    //INTEGRATOR STAGE 2 
    // out_2[n] = out_2[n-1] + out_1[n]
    adder ad2(delay_line_out[0], dff_out[1], delay_line_in[1]);
    dff #(.Computation(50)) dut3(clk, reset, 1'b1, delay_line_in[1], dff_out[1]);
    dff #(.Computation(50)) dut4(clk, reset, 1'b1, delay_line_in[1], delay_line_out[1]);

    //INTEGRATOR STAGE 3 
    // out_3[n] = out_3[n-1] + out_2[n]
    adder ad3(delay_line_out[1], dff_out[2], delay_line_in[2]);
    dff #(.Computation(50)) dut5(clk, reset, 1'b1, delay_line_in[2], dff_out[2]);    
    dff #(.Computation(50)) dut6(clk, reset, 1'b1, delay_line_in[2], delay_line_out[2]);

    //INTEGRATOR STAGE 4 
    // out_4[n] = out_4[n-1] + out_3[n]
    adder ad4(delay_line_out[2], dff_out[3], delay_line_in[3]);
    dff #(.Computation(50)) dut7(clk, reset, 1'b1, delay_line_in[3], dff_out[3]);    
    dff #(.Computation(50)) dut8(clk, reset, 1'b1, delay_line_in[3], out_integrated_data);

endmodule
