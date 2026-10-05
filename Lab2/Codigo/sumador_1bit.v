module sumador_1bit (
    input  A,
    input  B,
    input  Ci,
    output So,
    output Co
);

    assign So = A ^ B ^ Ci;
    assign Co = (A & B) | (Ci & (A ^ B));

endmodule