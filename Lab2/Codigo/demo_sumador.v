
module demo_sumador (
    input  wire [3:0] ckey,
    output wire [3:0] LED,
    output wire BUZZER
);
    wire [3:0] So;
    wire Co;

    sumador_4bit uut (
        .A(ckey),
        .B(4'b0001),
        .Ci(1'b0),
        .So(So),
        .Co(Co)
    );

    assign LED = ~So;
    assign BUZZER = ~Co;

endmodule
