`timescale 1ns/1ps

module tb_sumador_1bit;

    reg A;
    reg B;
    reg Ci;

    wire So;
    wire Co;

    sumador_1bit uut (
        .A(A),
        .B(B),
        .Ci(Ci),
        .So(So),
        .Co(Co)
    );

    initial begin
        $dumpfile("sumador_1bit.vcd");
        $dumpvars(0, tb_sumador_1bit);

        $monitor("A=%b B=%b Ci=%b | Co=%b So=%b",
                 A, B, Ci, Co, So);

        A = 0; B = 0; Ci = 0;
        #10;

        A = 0; B = 0; Ci = 1;
        #10;

        A = 0; B = 1; Ci = 0;
        #10;

        A = 0; B = 1; Ci = 1;
        #10;

        A = 1; B = 0; Ci = 0;
        #10;

        A = 1; B = 0; Ci = 1;
        #10;

        A = 1; B = 1; Ci = 0;
        #10;

        A = 1; B = 1; Ci = 1;
        #10;

        $finish;

    end

endmodule