/* FIR COMPENSATION FILTE

   - Takes CIC output (cic_out) and applies a fixed-point FIR compensation filter to correct CIC passband droop.
   - Supports two operating modes via 'mode':
        mode = 0 → coefficient set h0_x  (e.g., Nyquist = 2 kHz)
        mode = 1 → coefficient set h1_x  (e.g., Nyquist = 1 kHz)
   - Uses a transposed/partitioned structure with two delay lines (topwires / bottomwires) and separate coefficient
     sets for "top" and "bottom" branches as per the polyphase FIR circuit .
   - Output 'fir_out' is a widened, filtered version of cic_out suitable for further scaling and HB filtering.
   
   */

module fir_filter#(
    parameter cic_out_bit = 26,
    parameter N1 = 26,  
    parameter N2 = 40,   
    parameter N3 = 11,   // num. of taps in top branch 
    parameter N4 = 12    // num. of taps in bottom branch
)(
    input  clk_cic,
    input  clk_en,
    input  rst,
    input  mode,                      
    input  signed [N1-1:0] cic_out,     // FIR input (from CIC)
    output signed [N2-1:0] fir_out      // FIR output
);

    // DELAY LINES & COEFF ARRAYS 
    wire signed [N1-1:0] topwires    [0:N3+1];  // top branch delay line
    wire signed [N1-1:0] bottomwires [0:N4-1];  // bottom branch delay line

    wire signed [10:0] coeffs_top    [0:N3];    // selected top coefficients
    wire signed [10:0] coeffs_bottom [0:N4-2];  // selected bottom coefficients

    wire signed [N1+10:0] multiplied_top    [0:N3];    // products: top branch
    wire signed [N1+10:0] multiplied_bottom [0:N4-2];  // products: bottom branch

    //COEFFICIENT SETS (MODE-DEPENDENT) 
    
    localparam signed [10:0] h0_0  = 11'b11111010001;  
    localparam signed [10:0] h0_1  = 11'b00000000000;  
    localparam signed [10:0] h0_2  = 11'b00000111110;  
    localparam signed [10:0] h0_3  = 11'b00000000000;  
    localparam signed [10:0] h0_4  = 11'b11101010111;  
    localparam signed [10:0] h0_5  = 11'b00000000000;  
    localparam signed [10:0] h0_6  = 11'b00001111100;  
    localparam signed [10:0] h0_7  = 11'b00000000000;  
    localparam signed [10:0] h0_8  = 11'b11100101010;  
    localparam signed [10:0] h0_9  = 11'b00000000000; 
    localparam signed [10:0] h0_10 = 11'b01010001010;  
    localparam signed [10:0] h0_11 = 11'b00111111111;  
    localparam signed [10:0] h0_12 = 11'b01010001010;  
    localparam signed [10:0] h0_13 = 11'b00000000000;
    localparam signed [10:0] h0_14 = 11'b11100101010;  
    localparam signed [10:0] h0_15 = 11'b00000000000;  
    localparam signed [10:0] h0_16 = 11'b00001111100;  
    localparam signed [10:0] h0_17 = 11'b00000000000;  
    localparam signed [10:0] h0_18 = 11'b11101010111;
    localparam signed [10:0] h0_19 = 11'b00000000000;  
    localparam signed [10:0] h0_20 = 11'b00000111110;
    localparam signed [10:0] h0_21 = 11'b00000000000;
    localparam signed [10:0] h0_22 = 11'b11111010001;
    
    localparam signed [10:0] h1_0  = 11'b11101100100; 
    localparam signed [10:0] h1_1  = 11'b11100100000;  
    localparam signed [10:0] h1_2  = 11'b00001011010;
    localparam signed [10:0] h1_3  = 11'b00000011010;  
    localparam signed [10:0] h1_4  = 11'b11101111111; 
    localparam signed [10:0] h1_5  = 11'b11111010001; 
    localparam signed [10:0] h1_6  = 11'b00001101111;  
    localparam signed [10:0] h1_7  = 11'b00000101110;  
    localparam signed [10:0] h1_8  = 11'b11001110001; 
    localparam signed [10:0] h1_9  = 11'b11111010001;  
    localparam signed [10:0] h1_10 = 11'b00100101100;  
    localparam signed [10:0] h1_11 = 11'b01111101000; 
    localparam signed [10:0] h1_12 = 11'b00100101100;  
    localparam signed [10:0] h1_13 = 11'b11111010001;  
    localparam signed [10:0] h1_14 = 11'b11001110001;  
    localparam signed [10:0] h1_15 = 11'b00000101110; 
    localparam signed [10:0] h1_16 = 11'b00001101111;  
    localparam signed [10:0] h1_17 = 11'b11111010001; 
    localparam signed [10:0] h1_18 = 11'b11101111111;  
    localparam signed [10:0] h1_19 = 11'b00000011010;  
    localparam signed [10:0] h1_20 = 11'b00001011010;  
    localparam signed [10:0] h1_21 = 11'b11100100000; 
    localparam signed [10:0] h1_22 = 11'b11101100100; 
    
    
    
    
    // COEFF SELECTION (BASED ON MODE)
    // Top-branch coefficients
    assign coeffs_top[0]  = (mode) ? h1_0  : h0_0;
    assign coeffs_top[1]  = (mode) ? h1_2  : h0_2;
    assign coeffs_top[2]  = (mode) ? h1_4  : h0_4;
    assign coeffs_top[3]  = (mode) ? h1_6  : h0_6;
    assign coeffs_top[4]  = (mode) ? h1_8  : h0_8;
    assign coeffs_top[5]  = (mode) ? h1_10 : h0_10;
    assign coeffs_top[6]  = (mode) ? h1_12 : h0_12;
    assign coeffs_top[7]  = (mode) ? h1_14 : h0_14;
    assign coeffs_top[8]  = (mode) ? h1_16 : h0_16;
    assign coeffs_top[9]  = (mode) ? h1_18 : h0_18;
    assign coeffs_top[10] = (mode) ? h1_20 : h0_20;
    assign coeffs_top[11] = (mode) ? h1_22 : h0_22;
    
    // Bottom-branch coefficients
    assign coeffs_bottom[0]  = (mode) ? h1_1  : h0_1;
    assign coeffs_bottom[1]  = (mode) ? h1_3  : h0_3;
    assign coeffs_bottom[2]  = (mode) ? h1_5  : h0_5;
    assign coeffs_bottom[3]  = (mode) ? h1_7  : h0_7;
    assign coeffs_bottom[4]  = (mode) ? h1_9  : h0_9;
    assign coeffs_bottom[5]  = (mode) ? h1_11 : h0_11;
    assign coeffs_bottom[6]  = (mode) ? h1_13 : h0_13;
    assign coeffs_bottom[7]  = (mode) ? h1_15 : h0_15;
    assign coeffs_bottom[8]  = (mode) ? h1_17 : h0_17;
    assign coeffs_bottom[9]  = (mode) ? h1_19 : h0_19;
    assign coeffs_bottom[10] = (mode) ? h1_21 : h0_21;
    
    // INPUT REGISTER FOR BOTTOM BRANCH 
    reg [N1-1:0] bottomwire_temp;
    
    always @(posedge clk_cic or posedge rst) begin
        if (rst)
            bottomwire_temp <= 0;
        else
            bottomwire_temp <= cic_out;
    end

    assign bottomwires[0] = bottomwire_temp;
    
    // DELAY LINES (TOP AND BOTTOM)
    genvar j;
    assign topwires[0] = cic_out;
    generate
        for (j = 0; j <= N3; j = j + 1) begin : toprow
            dff #(.Computation(N1)) U_DFF_INSTANCE (
                clk_cic, rst, clk_en, topwires[j], topwires[j+1]
            );
        end
    endgenerate 
    
    // Bottom branch delay line
    genvar i;
    generate
        for (i = 0; i < N4-1; i = i + 1) begin : bottomrow
            dff #(.Computation(N1)) U_DFF_INSTANCE2 (
                clk_cic, rst, clk_en, bottomwires[i], bottomwires[i+1]
            );
        end
    endgenerate    
    
    // MULTIPLICATION STAGE 
    // Multiply delayed samples with their selected coefficients
    genvar k;
    generate
        for (k = 0; k <= N3; k = k + 1) begin : mul_top
            assign multiplied_top[k] = coeffs_top[k] * topwires[k+1];
        end
    endgenerate 
           
    genvar m;
    generate
        for (m = 0; m < N4-1; m = m + 1) begin : mul_bottom
            assign multiplied_bottom[m] = coeffs_bottom[m] * bottomwires[m+1];
        end
    endgenerate 
        
    // ACCUMULATION 
    wire signed [49:0] summed_wire[0:N3+N4-2];

    // First pairwise sum from bottom branch
    assign summed_wire[0] = multiplied_bottom[0] + multiplied_bottom[1];
    
    // Accumulate remaining bottom multipliers
    genvar p;
    generate
        for (p = 0; p < N4-3; p = p + 1) begin : add_bottom
            assign summed_wire[p+1] = multiplied_bottom[p+2] + summed_wire[p];
        end
    endgenerate
            
    // Add first top multiplier to bottom accumulated sum
    assign summed_wire[N4-2] = multiplied_top[0] + summed_wire[N4-3];
    
    // Accumulate remaining top multipliers
    genvar q;
    generate
        for (q = 0; q < N3; q = q + 1) begin : add_top
            assign summed_wire[N4+q-1] = multiplied_top[q+1] + summed_wire[N4+q-2];
        end
    endgenerate
    
    // Final FIR output . Further scaling happens in later blocks.
    assign fir_out = summed_wire[N4+N3-2];

endmodule
