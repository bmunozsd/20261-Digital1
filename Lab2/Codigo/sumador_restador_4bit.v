module sumador_restador_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input        Sel,
    output [3:0] R,
    output       Co
);

    wire [3:0] B_mod;

    // Si Sel=0 -> B_mod = B
    // Si Sel=1 -> B_mod = ~B
    assign B_mod = B ^ {4{Sel}};

    // Reutilizamos el sumador de 4 bits de la Parte 1
    // Sel entra como acarreo inicial para realizar el +1
    sumador_4bit U1 (
        .A(A),
        .B(B_mod),
        .Ci(Sel),
        .So(R),
        .Co(Co)
    );

endmodule