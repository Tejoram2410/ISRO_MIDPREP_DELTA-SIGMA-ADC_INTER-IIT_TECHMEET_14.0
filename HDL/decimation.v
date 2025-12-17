/* DECIMATOR MODULE
  
   Generates a 1-cycle clock-enable pulse (dec_enable) used by the CIC comb stage and others filter ahead of CIC.

   FUNCTION:
   - This logic basically divides the main clock by either:
         • 2048  (mode = 0)
         • 4096  (mode = 1)
   - When the counter reaches the selected limit, dec_enable goes HIGH for one cycle and then resets the counter.
   - In short, dec_enable = "sample now" signal 
   - The clocks for all d flip flops remain same only but depending on clock enable signal it will sample the input
   - So no need to generate seperate new clocks 
*/

module decimator (
    input  wire clk,
    input  wire mode,         
    output reg  dec_enable    // 1-cycle clock enable pulse
);

    // 12-bit counter to count the high-frequency modulator clock
    reg [11:0] counter = 0;

    // Select decimation period based on mode:
    // mode = 0 → decimate every 2048 clocks
    // mode = 1 → decimate every 4096 clocks
    wire [11:0] limit = mode ? (4096 - 1) : (2048 - 1);

    always @(posedge clk) begin
    // When counter reaches limit, generate enable and reset counter
        if(counter == limit) begin
            counter    <= 0;
            dec_enable <= 1;          // 1-cycle pulse
        end else begin
            counter    <= counter + 1;
            dec_enable <= 0;          // otherwise keep low
        end
    end

endmodule
