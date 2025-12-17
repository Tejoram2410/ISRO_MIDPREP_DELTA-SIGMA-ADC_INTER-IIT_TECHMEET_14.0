/* CIC FILTER MODULE
 
   Implements the 4-stage CIC structure:
   Integrator → Decimator → Comb → Output Scaling.
   Produces a wide CIC output (cic_out_temp) and a scaled decimated output (cic_out) clk_en controls decimation rate.
*/

module cic_filter #(
parameter cic_out_bit = 26
)(
    input clk, reset, pcm_data, mode,
    output signed [cic_out_bit-1:0] cic_out,     // final CIC output
    output clk_en,                                // decimation enable
    output signed [49:0] cic_out_temp           // wide comb output
);

    wire signed [49:0] out_integrated_data;       // output of integrator chain

    //INTEGRATOR STAGE 
    // Accumulates input samples
    integrator INTEGRATOR (clk, reset, pcm_data, out_integrated_data);

    //DECIMATOR 
    // Generates clk_en for comb stage based on mode.
    decimator DECIMATION (clk, mode, clk_en);

    //COMB STAGE 
    // Differentiates the integrated signal on decimation edges.
    comb COMB ( clk, clk_en, reset, out_integrated_data, cic_out_temp);

    //OUTPUT SCALING 
    // Converts wide comb output to final 26 bit cic_out resolution.
    scale_round_convergent_50_to_unfixed scale ( cic_out_temp, cic_out );

endmodule
