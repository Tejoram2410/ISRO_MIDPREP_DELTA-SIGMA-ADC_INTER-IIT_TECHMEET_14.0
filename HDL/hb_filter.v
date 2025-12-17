/* HALF-BAND (HB) FILTER

   - Final stage after FIR: performs narrowband half-band FIR filtering and prepares data for 20-bit output.
   - Supports two operating modes via 'mode':
        mode = 0 → coefficient set hb0_x
        mode = 1 → coefficient set hb1_x
   - Output 'hb_out' is a 20-bit scaled and rounded version of the 34-bit accumulator 'hb_out_temp'.
   
*/

module hb_filter(
    input  clk,
    input  clk_en,                         // decimated clock enable
    input  mode,                          
    input  rst,
    input  signed [22:0] fir_out,          // input from FIR stage
    output signed [19:0] hb_out            // final 20-bit output
);

    // 10-sample delay line for half-band structure
    wire signed [22:0] delay_line[0:9];

    // Wide internal accumulator for MAC operations
    wire signed [33:0] hb_out_temp;
    
    // Mode-selected half-band coefficients
    wire signed [10:0] k1, k2, k3, k4;

    // Register for first element in bottom delay line
    reg  signed [22:0] delay_line_temp;
    
    //  COEFFICIENT SETS (FIXED)
   

    localparam signed [10:0] hb0_0 = 11'b00000001110;
    localparam signed [10:0] hb0_1 = 11'b01001001000;
    localparam signed [10:0] hb0_2 = 11'b11110101100; 
    localparam signed [10:0] hb0_3 = 11'b01111101110; 

    localparam signed [10:0] hb1_0 = 11'b00000000111;
    localparam signed [10:0] hb1_1 = 11'b00100100100;
    localparam signed [10:0] hb1_2 = 11'b11111010110; 
    localparam signed [10:0] hb1_3 = 11'b00111110111; 

    // MODE-BASED COEFF SELECTION
    assign k1 = (mode) ? hb1_0 : hb0_0;
    assign k2 = (mode) ? hb1_1 : hb0_1;
    assign k3 = (mode) ? hb1_2 : hb0_2;
    assign k4 = (mode) ? hb1_3 : hb0_3;
    
    //  INPUT REGISTER TO DELAY LINE 
    // First tap of the delay line gets registered FIR output.
    always @(posedge clk or posedge rst) begin
        if (rst)
            delay_line_temp <= 0;
        else
            delay_line_temp <= fir_out;
    end

    assign delay_line[0] = delay_line_temp;

    // DELAY LINE (9 MORE STAGES)
    // Each dff is enabled by clk_en to run at decimated rate.
    genvar i;
    generate
        for (i = 0; i < 9; i = i + 1) begin : delayline
            dff #(.Computation(23)) U_DFF_INSTANCE (
                clk, rst, clk_en, delay_line[i], delay_line[i+1]
            );
        end
    endgenerate
 
    /*  HALF-BAND MAC STRUCTURE 
     Symmetric tap usage:
     (x[n] + x[n-9]) * k1
     (x[n-1] + x[n-7]) * k3
     (x[n-3] + x[n-5]) * k2
     center tap: x[n-4] * k4*/ 
    assign hb_out_temp =
          (fir_out       + delay_line[9]) * k1
        + (delay_line[1] + delay_line[7]) * k3
        + (delay_line[3] + delay_line[5]) * k2
        +  delay_line[4] * k4;
    
    // FINAL SCALING & ROUNDING 
    // Scales 34-bit hb_out_temp to signed 20-bit hb_out
    scale_round_convergent_34_20 scale (
        mode, hb_out_temp, hb_out
    );

endmodule
