`timescale 1ns/1ps

module tb_sumador_restador_4bit;

    reg [3:0] A;
    reg [3:0] B;
    reg       Sel;

    wire [3:0] R;
    wire       Co;

    sumador_restador_4bit DUT (
        .A(A),
        .B(B),
        .Sel(Sel),
        .R(R),
        .Co(Co)
    );

    initial begin

        $dumpfile("sumador_restador.vcd");
        $dumpvars(0, tb_sumador_restador_4bit);

        // 7 - 5 = 2
        A = 4'b0111;
        B = 4'b0101;
        Sel = 1'b1;
        #10;

        // 3 - 7 = -4
        A = 4'b0011;
        B = 4'b0111;
        Sel = 1'b1;
        #10;

        // 7 + 5 = 12
        A = 4'b0111;
        B = 4'b0101;
        Sel = 1'b0;
        #10;

        $finish;
    end

endmodule