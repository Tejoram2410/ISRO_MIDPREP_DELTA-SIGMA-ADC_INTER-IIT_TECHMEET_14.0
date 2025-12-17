/* TOP MODULE
   
   This module connects the complete decimation/filtering chain:
   CIC → FIR → Half-Band filter.
   It receives 1-bit modulator data and outputs a 20-bit decimated digital signal suitable for ENOB/SNR analysis.
   
*/

module top_module#(
parameter cic_out_bit=26
)(
input clk,reset,pcm_data,mode,
output signed [19:0]data_out
);


wire signed [49:0] cic_out_temp;          // Wide internal CIC output
wire signed [25:0] cic_out;               // Decimated CIC output
wire signed [cic_out_bit+13:0] fir_temp;  // High-precision FIR output
wire signed [22:0] fir_out;               // Rounded FIR output
wire clk_en;                               // Clock enable for filters

//CIC FILTER 
cic_filter CIC(clk,reset,pcm_data,mode,cic_out,clk_en,cic_out_temp);

// FIR FILTER 
fir_filter FIR(clk,clk_en,reset,mode,cic_out,fir_temp);

//SCALING + ROUNDING OF FIR 
// Converts FIR output to 23-bit using convergent rounding.
scale_round_convergent_unfixed_to_23 scale(fir_temp, fir_out);

//HALF-BAND FILTER 
hb_filter HALFBAND(clk,clk_en,mode,reset,fir_out,data_out);

endmodule
