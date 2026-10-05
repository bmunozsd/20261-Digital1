# Sumador/Restador de 4 bits

## Descripción

El sumador/restador de 4 bits permite realizar operaciones de suma y resta
entre dos números binarios de 4 bits mediante una señal de control `Sel`.

El circuito reutiliza el sumador de 4 bits desarrollado previamente. Para
realizar la resta mediante complemento a 2, la señal `Sel` controla la
inversión de los bits de `B` y también se utiliza como acarreo inicial.

El funcionamiento es:

- `Sel = 0`: realiza `A + B`.
- `Sel = 1`: realiza `A + ~B + 1`, equivalente a `A - B`.

Las señales principales del módulo son:

| Señal | Tipo | Descripción |
|---|---|---|
| `A[3:0]` | Entrada | Primer operando |
| `B[3:0]` | Entrada | Segundo operando |
| `Sel` | Entrada | Selección de suma o resta |
| `R[3:0]` | Salida | Resultado de la operación |
| `Co` | Salida | Acarreo de salida |

## Descripción de la implementación

Para realizar la resta se utiliza el complemento a 2 del operando `B`.
La inversión de los bits se realiza mediante compuertas XOR controladas por
la señal `Sel`.

La operación implementada puede expresarse como:

```text
Sel = 0  →  B_mod = B
Sel = 1  →  B_mod = ~B
```

Además, la señal `Sel` se conecta al acarreo de entrada del sumador de
4 bits:

```text
Sel = 0  →  Ci = 0
Sel = 1  →  Ci = 1
```

Por lo tanto, cuando `Sel = 1`, el circuito realiza:

```text
A + ~B + 1
```

que corresponde a:

```text
A - B
```

El módulo reutiliza el sumador de 4 bits desarrollado anteriormente:

```verilog
module sumador_restador_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input        Sel,
    output [3:0] R,
    output       Co
);

    wire [3:0] B_mod;

    assign B_mod = B ^ {4{Sel}};

    sumador_4bit U1 (
        .A(A),
        .B(B_mod),
        .Ci(Sel),
        .So(R),
        .Co(Co)
    );

endmodule
```

De esta manera, no es necesario desarrollar un circuito restador
independiente, ya que el mismo sumador puede realizar ambas operaciones
mediante la modificación controlada de la entrada `B`.

## Módulo utilizado para la implementación en la tarjeta

Para la implementación física se utilizó el módulo
`sumador_restador_prueba`. En este módulo se fija el segundo operando
`B` y la operación a realizar, dejando el primer operando `A` como entrada
externa.

```verilog
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
```

En este caso:

```text
B = 0101
Sel = 1
```

por lo que la operación realizada por el circuito es:

```text
R = A - 5
```

La salida `LED` se obtiene a partir de la inversión de `R` debido a la
configuración utilizada para los LEDs de la tarjeta. De manera similar,
`Buzzer` se obtiene a partir de la inversión de `Co`.

## Simulación

La simulación del sumador/restador se realizó mediante un testbench,
aplicando diferentes valores a las entradas `A`, `B` y `Sel`. El objetivo
fue comprobar tanto el funcionamiento del modo suma como el del modo
resta.

El testbench utilizado fue:

```verilog
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
```

## Resultados de la simulación

Se realizaron tres pruebas principales:

| A | B | Sel | Operación | R | Interpretación |
|---|---|---:|---|---|---|
| `0111` | `0101` | 1 | `7 - 5` | `0010` | 2 |
| `0011` | `0111` | 1 | `3 - 7` | `1100` | -4 |
| `0111` | `0101` | 0 | `7 + 5` | `1100` | 12 |

### Prueba 1: 7 - 5

Para:

```text
A   = 0111
B   = 0101
Sel = 1
```

el circuito se encuentra en modo resta. El complemento a 2 de `B` se
obtiene mediante:

```text
B       = 0101
~B      = 1010
~B + 1  = 1011
```

Por lo tanto:

```text
  0111
+ 1011
------
1 0010
```

El resultado de cuatro bits es:

```text
R = 0010
```

que corresponde a:

```text
2
```

El resultado obtenido en la simulación coincide con el resultado
matemático esperado.

### Prueba 2: 3 - 7

Para:

```text
A   = 0011
B   = 0111
Sel = 1
```

se obtiene el complemento a 2 de `B`:

```text
B       = 0111
~B      = 1000
~B + 1  = 1001
```

La operación realizada por el sumador es:

```text
  0011
+ 1001
------
  1100
```

Por lo tanto:

```text
R = 1100
```

En complemento a 2 de cuatro bits:

```text
1100 = -4
```

por lo que se verifica:

```text
3 - 7 = -4
```

Esta prueba permite comprobar que el circuito no solamente funciona para
resultados positivos, sino que también representa correctamente los
resultados negativos mediante complemento a 2.

### Prueba 3: 7 + 5

Para:

```text
A   = 0111
B   = 0101
Sel = 0
```

las compuertas XOR dejan pasar `B` sin modificar y el acarreo inicial es
cero. Por lo tanto, el circuito funciona como un sumador convencional:

```text
  0111
+ 0101
------
  1100
```

El resultado es:

```text
R = 1100
```

que corresponde a 12 cuando se interpreta como un número binario sin
signo.

## Análisis

Los resultados obtenidos en la simulación coinciden con las operaciones
esperadas en los tres casos evaluados. Cuando `Sel = 0`, el circuito
realiza una suma convencional, mientras que cuando `Sel = 1`, los bits de
`B` son invertidos y se agrega el `1` mediante el acarreo inicial,
implementando el complemento a 2.

La prueba `7 - 5` demuestra el funcionamiento de la resta con un
resultado positivo, mientras que `3 - 7` verifica la representación de un
resultado negativo. En este último caso, el resultado `1100` corresponde
a `-4` en complemento a 2 de cuatro bits.

Por otra parte, la prueba `7 + 5` permite comprobar que el mismo circuito
puede regresar al modo suma al modificar únicamente la señal `Sel`.

En conjunto, la simulación verifica que el sumador/restador funciona
correctamente y que la reutilización del sumador de 4 bits permite
implementar ambas operaciones sin necesidad de construir un circuito
restador independiente.

## Ejecución de la simulación

La compilación del diseño se puede realizar mediante Icarus Verilog:

```bash
iverilog -o sim_sumador_restador \
    sumador_1bit.v \
    sumador_4bit.v \
    sumador_restador_4bit.v \
    tb_sumador_restador_4bit.v
```

Posteriormente se ejecuta la simulación:

```bash
vvp sim_sumador_restador
```

El proceso genera el archivo:

```text
sumador_restador.vcd
```

Finalmente, las formas de onda pueden visualizarse mediante GTKWave:

```bash
gtkwave sumador_restador.vcd
```

En GTKWave se pueden observar las señales `A`, `B`, `Sel`, `R` y `Co`,
permitiendo comprobar temporalmente el comportamiento del circuito para
cada uno de los casos de prueba.

La tabla completa para todos los valores posibles de A es:

| A | B fijo | Operación | R | Co |
|---|---|---|---|---|
| `0000` | `0101` | 0 − 5 | `1011` | 0 |
| `0001` | `0101` | 1 − 5 | `1100` | 0 |
| `0010` | `0101` | 2 − 5 | `1101` | 0 |
| `0011` | `0101` | 3 − 5 | `1110` | 0 |
| `0100` | `0101` | 4 − 5 | `1111` | 0 |
| `0101` | `0101` | 5 − 5 | `0000` | 1 |
| `0110` | `0101` | 6 − 5 | `0001` | 1 |
| `0111` | `0101` | 7 − 5 | `0010` | 1 |
| `1000` | `0101` | 8 − 5 | `0011` | 1 |
| `1001` | `0101` | 9 − 5 | `0100` | 1 |
| `1010` | `0101` | 10 − 5 | `0101` | 1 |
| `1011` | `0101` | 11 − 5 | `0110` | 1 |
| `1100` | `0101` | 12 − 5 | `0111` | 1 |
| `1101` | `0101` | 13 − 5 | `1000` | 1 |
| `1110` | `0101` | 14 − 5 | `1001` | 1 |
| `1111` | `0101` | 15 − 5 | `1010` | 1 |