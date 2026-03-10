`timescale 1ns / 1ps

module comp(
    input [31:0] a,
    input [31:0] b,
    output logic gt,
    output logic eq,
    output logic lt
    );
    
logic [31:0] diff;
logic [31:0] eq_bit;
logic [31:0] prefix_eq;
logic [31:0] gt_bit;
logic [31:0] lt_bit;

genvar i;

generate

for (i = 0; i < 32; i = i + 1) begin
    assign diff[i] = a[i] ^ b[i];    // XOR detects difference
    assign eq_bit[i] = ~diff[i];    // bits are equal if XOR = 0
end

endgenerate


assign prefix_eq[31] = 1'b1;

generate
// prefix_eq[i] becomes 1 only if all more significant bits are equal
for (i = 30; i >= 0; i = i - 1) begin
    assign prefix_eq[i] = prefix_eq[i+1] & eq_bit[i+1];
end
endgenerate


generate

for (i = 0; i < 32; i = i + 1) begin
    assign gt_bit[i] = prefix_eq[i] & a[i] & ~b[i]; // a greater at bit i
    assign lt_bit[i] = prefix_eq[i] & ~a[i] & b[i]; // b greater at bit i
end
endgenerate


assign gt = |gt_bit;   // OR reduction: if any gt_bit is 1
assign lt = |lt_bit;   // OR reduction: if any lt_bit is 1
assign eq = &eq_bit;   // AND reduction: all bits must be equal


endmodule
