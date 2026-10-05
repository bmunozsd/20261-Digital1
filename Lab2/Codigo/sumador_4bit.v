module sumador_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input        Ci,
    output [3:0] So,
    output       Co
);

    wire C0;
    wire C1;
    wire C2;

    sumador_1bit FA0 (
        .A(A[0]),
        .B(B[0]),
        .Ci(Ci),
        .So(So[0]),
        .Co(C0)
    );

    sumador_1bit FA1 (
        .A(A[1]),
        .B(B[1]),
        .Ci(C0),
        .So(So[1]),
        .Co(C1)
    );

    sumador_1bit FA2 (
        .A(A[2]),
        .B(B[2]),
        .Ci(C1),
        .So(So[2]),
        .Co(C2)
    );

    sumador_1bit FA3 (
        .A(A[3]),
        .B(B[3]),
        .Ci(C2),
        .So(So[3]),
        .Co(Co)
    );

endmodule