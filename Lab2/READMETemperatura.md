# Reto de diseño: Control térmico de proceso en caldera industrial

## Descripción

El objetivo del reto de diseño es implementar un sistema digital capaz de determinar el estado de un proceso térmico a partir de una temperatura medida y una temperatura objetivo.

La operación requerida es:

```text
R = T - L
```

donde:

- `T[3:0]`: temperatura medida.
- `L[3:0]`: temperatura objetivo.
- `R[3:0]`: resultado de la resta.

El sistema debe identificar tres condiciones:

| Condición | Estado del proceso |
|---|---|
| `R < 0` | Producto en proceso de fabricación |
| `R = 0` | Temperatura ideal |
| `R > 0` | Producto quemado |

Para la implementación en la tarjeta FPGA se estableció una temperatura objetivo fija:

```text
L = 1000₂ = 8
```

De esta manera, los cuatro bits de entrada `T[3:0]` pueden utilizarse para seleccionar la temperatura medida.

---

## Implementación

El sistema reutiliza el módulo `sumador_restador_4bit` desarrollado anteriormente. Como se requiere realizar siempre una resta, la señal `Sel` se establece directamente en `1`.

La operación realizada por el sumador/restador es:

```text
R = T - 8
```

El módulo implementado es:

```verilog
module control_temperatura2(
    input  [3:0] T,

    output LED1,
    output LED2,
    output LED3,
    output LED4
);

    // Temperatura objetivo fija
    localparam [3:0] L = 4'b1000;

    wire [3:0] R;
    wire       Co;

    // T - L
    sumador_restador_4bit U1 (
        .A(T),
        .B(L),
        .Sel(1'b1),
        .R(R),
        .Co(Co)
    );

    // T < L
    wire PROCESS_STATE;
    assign PROCESS_STATE = R[3];

    // T = L
    wire PERFECT_STATE;
    assign PERFECT_STATE =
        ~(R[3] | R[2] | R[1] | R[0]);

    // T > L
    wire BURN_STATE;
    assign BURN_STATE =
        ~R[3] & (R[2] | R[1] | R[0]);

    // LEDs activos en bajo
    assign LED1 = ~PROCESS_STATE;
    assign LED2 = ~PERFECT_STATE;
    assign LED3 = ~BURN_STATE;

    // LED4 no utilizado
    assign LED4 = 1'b1;

endmodule
```

---

## Determinación de los estados

La identificación de los estados se realiza utilizando únicamente lógica combinacional sobre el resultado `R`.

### Producto en proceso

Cuando:

```text
T < L
```

la resta produce un resultado negativo. En complemento a 2, un resultado negativo tiene el bit más significativo igual a `1`.

Por esta razón:

```verilog
assign PROCESS_STATE = R[3];
```

permite identificar esta condición.

### Temperatura ideal

Cuando:

```text
T = L
```

el resultado de la resta es:

```text
R = 0000
```

La condición se detecta verificando que todos los bits de `R` sean cero:

```verilog
assign PERFECT_STATE =
    ~(R[3] | R[2] | R[1] | R[0]);
```

### Producto quemado

Cuando:

```text
T > L
```

el resultado es positivo y diferente de cero. Por lo tanto, su bit más significativo es `0` y al menos uno de los tres bits restantes debe ser `1`:

```verilog
assign BURN_STATE =
    ~R[3] & (R[2] | R[1] | R[0]);
```

---

## Control de los LEDs

Los LEDs de la tarjeta trabajan con lógica activa en bajo. Por lo tanto, un `0` lógico en la salida corresponde a un LED encendido.

Por esta razón las señales de estado se invierten al conectarlas a los LEDs:

```verilog
assign LED1 = ~PROCESS_STATE;
assign LED2 = ~PERFECT_STATE;
assign LED3 = ~BURN_STATE;
```

La correspondencia utilizada es:

| LED | Estado |
|---|---|
| `LED1` | `T < 8` → Producto en proceso |
| `LED2` | `T = 8` → Temperatura ideal |
| `LED3` | `T > 8` → Producto quemado |
| `LED4` | No utilizado |

---

# Simulación

La simulación permite comprobar que el sistema identifica correctamente los tres estados del proceso térmico.

Debido a que la temperatura objetivo está fija en:

```text
L = 1000₂ = 8
```

se deben probar valores de `T` menores, iguales y mayores que 8.

## Resultados de simulación

| T | L | R = T − L | Estado | LED |
|---|---|---|---|---|
| `0000` | `1000` | `1000` = -8 | En proceso | LED1 |
| `0001` | `1000` | `1001` = -7 | En proceso | LED1 |
| `0010` | `1000` | `1010` = -6 | En proceso | LED1 |
| `0011` | `1000` | `1011` = -5 | En proceso | LED1 |
| `0100` | `1000` | `1100` = -4 | En proceso | LED1 |
| `0101` | `1000` | `1101` = -3 | En proceso | LED1 |
| `0110` | `1000` | `1110` = -2 | En proceso | LED1 |
| `0111` | `1000` | `1111` = -1 | En proceso | LED1 |
| `1000` | `1000` | `0000` = 0 | Ideal | LED2 |
| `1001` | `1000` | `0001` = 1 | Quemado | LED3 |
| `1010` | `1000` | `0010` = 2 | Quemado | LED3 |
| `1011` | `1000` | `0011` = 3 | Quemado | LED3 |
| `1100` | `1000` | `0100` = 4 | Quemado | LED3 |
| `1101` | `1000` | `0101` = 5 | Quemado | LED3 |
| `1110` | `1000` | `0110` = 6 | Quemado | LED3 |
| `1111` | `1000` | `0111` = 7 | Quemado | LED3 |

## Análisis de los resultados

Para valores de `T` entre `0000` y `0111`, la temperatura medida es menor que la temperatura objetivo de 8. La resta genera valores negativos representados mediante complemento a 2, por lo que `R[3] = 1` y se activa el estado de proceso.

Por ejemplo:

```text
T = 0000
L = 1000
-----------
R = 1000
```

El resultado `1000` representa `-8`, por lo que:

```text
T < L
```

y se enciende `LED1`.

Cuando:

```text
T = 1000
L = 1000
```

se obtiene:

```text
R = 0000
```

Todos los bits del resultado son cero, por lo que se activa `PERFECT_STATE` y se enciende `LED2`. Este caso representa la temperatura ideal del proceso.

Finalmente, para valores de `T` superiores a 8, el resultado de la resta es positivo y diferente de cero. Por ejemplo:

```text
T = 1001
L = 1000
-----------
R = 0001
```

Por lo tanto:

```text
T > L
```

y se activa `BURN_STATE`, encendiendo `LED3`.

Los resultados permiten verificar que los tres estados definidos para el proceso térmico son identificados correctamente a partir del resultado del sumador/restador.

## Conclusión

La implementación permite utilizar el sumador/restador de 4 bits como elemento central de un sistema de decisión para el control de temperatura. Al fijar la temperatura objetivo en 8, la temperatura medida puede ingresarse directamente mediante los cuatro bits de `T`.

El sistema distingue correctamente entre temperaturas inferiores, iguales y superiores al valor objetivo mediante lógica combinacional, sin utilizar comparadores dedicados ni microcontroladores. Esto permite cumplir las restricciones establecidas para el reto de diseño.