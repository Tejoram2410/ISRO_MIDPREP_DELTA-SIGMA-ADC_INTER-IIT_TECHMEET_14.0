/*CIC OUTPUT SCALING + CONVERGENT ROUNDING

 - Input  : 50-bit wide CIC output (in_data)
 - Output : cic_out_bit-wide scaled value (out_data)
 - Implements convergent rounding using:
      * truncated_part : kept MSBs
      * round_bit      : first discarded bit 
      * sticky_bits    : OR of all remaining discarded bits
   round_up = round_bit & (sticky_bits | lsb_kept)
   This avoids rounding bias over many samples.*/


module scale_round_convergent_50_to_unfixed #(
    parameter cic_out_bit = 26
)(
    input  signed [49:0]in_data,
    output reg   signed [cic_out_bit-1:0] out_data
);

    wire signed [cic_out_bit-1:0] truncated_part;
    wire lsb_kept;     // LSB of the retained part
    wire round_bit;    // MSB of discarded field
    wire sticky_bits;  // OR of remaining discarded bits
    wire round_up;

    // MSBs that we keep after scaling
    assign truncated_part = in_data[49 : (49 - cic_out_bit + 1)];
    // LSB of truncated part (used for tie-breaking in convergent rounding)
    assign lsb_kept       = in_data[49 - cic_out_bit + 1];
    // First discarded bit ("halfway" bit)
    assign round_bit      = in_data[49 - cic_out_bit];
    // Any remaining discarded bits set?
    assign sticky_bits    = |(in_data[49 - cic_out_bit - 1 : 0]);

    // Convergent rounding decision
    assign round_up = round_bit & (sticky_bits | lsb_kept);

    always @(*) begin
        if (round_up)
            out_data = truncated_part + 1;
        else
            out_data = truncated_part;
    end

endmodule


/* FIR OUTPUT SCALING + CONVERGENT ROUNDING TO 23 BITS
 ----------------------------------------------------------
 - Input  : (cic_out_bit+14)-bit FIR output (in_data)
 - Output : 23-bit rounded result (out_data)
 - Uses a custom bit-slice (truncated_part) and convergent rounding:
      * lsb_kept    : LSB of kept field
      * round_bit   : first discarded bit
      * sticky_bits : OR of lower discarded bits
   upper_sticky_bit further includes selected upper bits, controlling how aggressively we treat near-halfway cases.*/

module scale_round_convergent_unfixed_to_23 #(
    parameter cic_out_bit = 26
)(
    input  signed [cic_out_bit+13:0] in_data,
    output reg   signed [22:0]       out_data
);

    wire signed [22:0] truncated_part;
    wire lsb_kept;
    wire round_bit;
    wire sticky_bits;
    wire upper_sticky_bit;
    wire round_up;

    // Select the 23-bit field to keep (sign + 22 data bits)
    assign truncated_part = { in_data[cic_out_bit+12],in_data[cic_out_bit+8 : cic_out_bit-13] };

    // LSB of kept field
    assign lsb_kept       = in_data[cic_out_bit-13];
    // "Halfway" bit just below LSB
    assign round_bit      = in_data[cic_out_bit-14];
    // Lower discarded bits
    assign sticky_bits    = |(in_data[cic_out_bit-15 : 0]);

    // Add extra bits into sticky behavior for safety margin
    assign upper_sticky_bit = sticky_bits | in_data[39] | (|(in_data[37:35]));

    // Convergent rounding decision
    assign round_up = round_bit & (upper_sticky_bit | lsb_kept);

    always @(*) begin
        if (round_up)
            out_data = truncated_part + 1;
        else
            out_data = truncated_part;
    end

endmodule

/* HALF-BAND OUTPUT SCALING + CONVERGENT ROUNDING TO 20 BITS
 - Input  : 34-bit accumulator output from HB filter (in_data)
 - Output : 20-bit final code (out_data)
 - Mode-dependent scaling:
      mode = 1 → one bit-slice and sticky strategy
      mode = 0 → slightly different slice & sticky extension
 - Uses convergent rounding (round-to-even) via:
      truncated_part, lsb_kept, round_bit, sticky_bits, upper_sticky_bit, round_up.*/

module scale_round_convergent_34_20 (
    input        mode,
    input  signed [33:0] in_data,
    output reg   signed [19:0] out_data
);

    reg [19:0] truncated_part;
    reg        lsb_kept;
    reg        round_bit;
    reg        sticky_bits;
    reg        upper_sticky_bit;
    reg        round_up;

    // Mode-dependent bit slicing and sticky behavior
    always @(*) begin
        if (mode == 1) begin
            // Mode 1: use one range of bits for output scaling
            truncated_part   = { in_data[33], in_data[32:14] };
            lsb_kept         = in_data[14];
            round_bit        = in_data[13];
            sticky_bits      = |in_data[12:0];
            upper_sticky_bit = sticky_bits;      
            round_up         = round_bit & (upper_sticky_bit | lsb_kept);
        end 
        else begin
            // Mode 0: Slightly different slice and extra sticky coverage
            truncated_part   = { in_data[33], in_data[31-1-1 : 13-1-1] };
            lsb_kept         = in_data[13-1-1];
            round_bit        = in_data[12-1-1];
            sticky_bits      = |in_data[11-1-1 : 0];
            upper_sticky_bit = sticky_bits | in_data[32:31];
            round_up         = round_bit & (upper_sticky_bit | lsb_kept);
        end
    end

    // Final convergent rounding step
    always @(*) begin
        if (round_up)
            out_data = truncated_part + 1;
        else
            out_data = truncated_part;
    end

endmodule
