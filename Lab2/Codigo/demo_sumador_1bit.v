module demo_sumador_1bit (
    input  wire A,
    input  wire B,
    input  wire Ci,
    output wire LED_SO,
    output wire LED_CO,
    output wire BUZZER
);

    wire So;
    wire Co;

    sumador_1bit uut (
        .A(A),
        .B(B),
        .Ci(Ci),
        .So(So),
        .Co(Co)
    );

    // LEDs activos en bajo
    assign LED_SO = ~So;
    assign LED_CO = ~Co;

    // Buzzer activo en bajo
    assign BUZZER = ~Co;

endmodule