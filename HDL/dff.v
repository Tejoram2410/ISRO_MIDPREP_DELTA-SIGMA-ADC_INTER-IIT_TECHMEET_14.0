/* DFF WITH CLOCK ENABLE
   A parameterized register, Updates its output only when clk_en = 1.
   - rst  : asynchronous reset clears q to zero
   - clk_en : acts as sample-enable for decimated operations
   
*/

module dff #(
    parameter Computation = 50
)(
    input  wire clk,
    input  wire rst,
    input  wire clk_en,                            
    input  wire signed [Computation-1:0] d,          // input data
    output reg  signed [Computation-1:0] q           // stored output
);

    // Asynchronous reset
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 0;                                  // clear register
        else if (clk_en)
            q <= d;                                  // latch new value only when enabled
        // else hold previous q value
    end

endmodule
