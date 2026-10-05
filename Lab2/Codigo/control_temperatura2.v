module control_temperatura2(
    input  [3:0] T,

    output LED1,
    output LED2,
    output LED3,
    output LED4
);

    // Temperatura objetivo fija
    // Cambiar este valor según la temperatura objetivo deseada
    localparam [3:0] L = 4'b1000;  // L = 8

    wire [3:0] R;
    wire       Co;

    // ------------------------------------------------
    // Sumador/restador
    // Sel = 1 -> T - L
    // ------------------------------------------------

    sumador_restador_4bit U1 (
        .A(T),
        .B(L),
        .Sel(1'b1),
        .R(R),
        .Co(Co)
    );

    // ------------------------------------------------
    // Estados del proceso
    // ------------------------------------------------

    // T < L -> resultado negativo
    wire PROCESS_STATE;
    assign PROCESS_STATE = R[3];

    // T = L -> resultado igual a cero
    wire PERFECT_STATE;
    assign PERFECT_STATE =
        ~(R[3] | R[2] | R[1] | R[0]);

    // T > L -> resultado positivo
    wire BURN_STATE;
    assign BURN_STATE =
        ~R[3] & (R[2] | R[1] | R[0]);

    // ------------------------------------------------
    // LEDs
    // ------------------------------------------------

    assign LED1 = ~PROCESS_STATE;
    assign LED2 = ~PERFECT_STATE;
    assign LED3 = ~BURN_STATE;

    // LED4 no se utiliza
    assign LED4 = 1'b1;

endmodule