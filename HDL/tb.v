/* TESTBENCH FOR COMPLETE RTL FILTER CHAIN
   - Loads a long 1-bit PCM stream from the text file "1V_100Hz.txt".
     This file is generated externally from Simulink sigma-delta modulator .

   - Feeds these PCM bits serially into the top_module, which includes:
       CIC → FIR → Scaling → Half-Band Filter → Final 20-bit output.

   - Captures the final 20-bit decimated samples hb_out(half band output)- which is the final 20 bit output
   - Writes to "20_bit_adc_out.txt".

   - This output file is later imported into MATLAB where ENOB and SNDR for the RTL architecture are computed and compared
    against the Simulink reference model.
   
*/

module tb();

reg clk, reset, pcm_data;
wire signed [19:0] hb_out;
reg mode = 1;

// Instantiate full filter chain
top_module filter(clk, reset, pcm_data, mode, hb_out);

// Clock parameters (based on 4.096 MHz modulator rate / OSR)
parameter CLK_PERIOD  = (1000000000)/(4096*1000);
parameter OSR_overall = 4096;

// PCM memory (loaded from file)
reg signed pcm_mem [8192000:0];
integer i, fout_hb;

//RESET & CLOCK GEN 
initial begin
    reset = 0;
    clk   = 0;
    #(CLK_PERIOD/2) reset = 1;           // apply reset
    #((CLK_PERIOD/2)+10) reset = 0;      // release reset
end

always #(CLK_PERIOD/2) clk = ~clk;       // 4.096 MHz clock

initial begin
    //  Load long PCM bitstream from file
    //  This acts as the sigma-delta modulator output.
    $readmemb("1V_100Hz.txt", pcm_mem);
    $display("PCM data loaded, starting simulation...");

    // Open output file to store 20-bit samples
    fout_hb = $fopen("20_bit_adc_out.txt", "w");

    // Feed PCM bits into design at full clock rate
    for (i = 0; i < 8192000; i = i + 1) begin
        pcm_data = pcm_mem[i];
        #(CLK_PERIOD);
    end

    // Close output file after simulation
    $fclose(fout_hb);
end

// OUTPUT CAPTURE
// Write a new 20-bit sample every OSR cycles 
always #((CLK_PERIOD)*(OSR_overall))
    $fwrite(fout_hb, "%b\n", hb_out);

endmodule
