module control_temperatura(
    input  [3:0] T,
    input  [3:0] L,
    output       PERFECT_LED,
    output       PROCESS_LED,
    output       BURN_LED
);

    wire [3:0] R;
    wire       Co;

    // Siempre realizamos T - L
    sumador_restador_4bit U1 (
        .A(T),
        .B(L),
        .Sel(1'b1),
        .R(R),
        .Co(Co)
    );

    // T < L
    assign PROCESS_LED = R[3];

    // T = L
    assign PERFECT_LED = ~(R[3] | R[2] | R[1] | R[0]);

    // T > L
    assign BURN_LED = ~R[3] & (R[2] | R[1] | R[0]);

endmodule