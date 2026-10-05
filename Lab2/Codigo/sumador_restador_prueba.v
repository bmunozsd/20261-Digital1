module sumador_restador_prueba(
    input  [3:0] A,
    output [3:0] LED,
    output       Buzzer
);

    wire [3:0] B = 4'b0101;
    wire Sel = 1'b1;

    wire [3:0] R;
    wire Co;

    sumador_restador_4bit U1 (
        .A(A),
        .B(B),
        .Sel(Sel),
        .R(R),
        .Co(Co)
    );

    assign LED = ~R;
    assign Buzzer = ~Co;

endmodule