/* COMB FILTER MODULE

   Implements a 4-stage CIC comb section.
   - Each stage performs a first-order difference: y[n] = x[n] - x[n-1]
   - Operates only when clk_en = 1, i.e., at the decimated sample rate determined by the decimator module.
   - Input  : in_integrated_data  (from integrator chain)
   - Output : out_comb_data       (differentiated CIC output)
*/

module comb #(
    parameter Computation = 50
)(
   input  clk,
   input  clk_en,                               
   input  reset,
   input  signed [Computation-1:0] in_integrated_data,
   output signed [Computation-1:0] out_comb_data
);

    wire signed [Computation-1:0] delay_line_in[3:0];
    wire signed [Computation-1:0] delay_line_out[2:0];
    wire signed [Computation-1:0] dff_out[3:0];

    //COMB STAGE 1 
    // y1[n] = x[n] - x[n-1]
    sub sub1(in_integrated_data, dff_out[0], delay_line_in[0]);
    dff #(.Computation(50)) dut1(clk, reset, clk_en, in_integrated_data, dff_out[0]);
    dff #(.Computation(50)) dut2(clk, reset, clk_en, delay_line_in[0], delay_line_out[0]);

    //COMB STAGE 2 
    // y2[n] = y1[n] - y1[n-1]
    sub sub2(delay_line_out[0], dff_out[1], delay_line_in[1]);
    dff #(.Computation(50)) dut3(clk, reset, clk_en, delay_line_out[0], dff_out[1]);
    dff #(.Computation(50)) dut4(clk, reset, clk_en, delay_line_in[1], delay_line_out[1]);

    //COMB STAGE 3
    // y3[n] = y2[n] - y2[n-1]
    sub sub3(delay_line_out[1], dff_out[2], delay_line_in[2]);
    dff #(.Computation(50)) dut5(clk, reset, clk_en, delay_line_out[1], dff_out[2]);    
    dff #(.Computation(50)) dut6(clk, reset, clk_en, delay_line_in[2], delay_line_out[2]);

    //COMB STAGE 4 
    // y4[n] = y3[n] - y3[n-1]
    sub sub4(delay_line_out[2], dff_out[3], delay_line_in[3]);
    dff #(.Computation(50)) dut7(clk, reset, clk_en, delay_line_out[2], dff_out[3]);    
    dff #(.Computation(50)) dut8(clk, reset, clk_en, delay_line_in[3], out_comb_data);

endmodule
