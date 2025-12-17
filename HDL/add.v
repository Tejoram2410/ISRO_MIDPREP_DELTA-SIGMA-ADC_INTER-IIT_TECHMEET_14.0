/* ADDER MODULE
   Signed adder 
   Performs: out = in1 + in2
    */

module adder #(
    parameter Computation = 50
)(
    input  signed [Computation-1:0] in1,
    input  signed [Computation-1:0] in2,
    output signed [Computation-1:0] out
);

    assign out = in1 + in2;  

endmodule
