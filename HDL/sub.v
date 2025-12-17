/* SUBTRACTOR MODULE
   Signed Subtraction 
   Performs: out = in1 - in2
    */


module sub#(
    parameter Computation = 50
)(
  input signed [Computation-1 :0] in1 ,in2,
  output signed [Computation-1 :0] out);
  
  assign out=in1-in2;
  endmodule