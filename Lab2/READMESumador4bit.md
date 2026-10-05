# Sumador de 4 bits

## Descripción

Se implementó un sumador binario de 4 bits utilizando cuatro módulos de
sumador completo de 1 bit conectados en cascada. El circuito recibe dos
operandos de cuatro bits (`A` y `B`) y un acarreo de entrada (`Ci`).

Las salidas del circuito son:

- `So[3:0]`: resultado de la suma de cuatro bits.
- `Co`: acarreo de salida.

El acarreo generado por cada sumador de 1 bit se utiliza como acarreo de
entrada para la siguiente etapa, permitiendo realizar la suma completa de
los dos operandos.

## Archivos

La implementación y verificación del sumador se relacionan con los
siguientes archivos:

- `sumador_4bit.v`: módulo del sumador de 4 bits.
- `tb_sumador_4bit_all.v`: banco de pruebas utilizado para verificar todas
  las combinaciones posibles de entrada.
- `sumador_4bit_all.vcd`: archivo generado durante la simulación para
  visualizar las señales en GTKWave.
- `demo_sumador.v`: módulo utilizado para realizar la demostración física
  del sumador en la tarjeta FPGA.

## Simulación

La verificación del sumador de 4 bits se realizó mediante el testbench
`tb_sumador_4bit_all.v`.

El testbench define dos operandos de cuatro bits y un acarreo de entrada:

```verilog
reg [3:0] A;
reg [3:0] B;
reg       Ci;
```

Las salidas del sumador se definen como:

```verilog
wire [3:0] So;
wire       Co;
```

El módulo `sumador_4bit` se instancia como el dispositivo bajo prueba:

```verilog
sumador_4bit uut (
    .A(A),
    .B(B),
    .Ci(Ci),
    .So(So),
    .Co(Co)
);
```

## Verificación exhaustiva

El testbench utiliza tres ciclos `for` para recorrer todas las
combinaciones posibles de `A`, `B` y `Ci`.

```verilog
for (i = 0; i < 16; i = i + 1) begin

    for (j = 0; j < 16; j = j + 1) begin

        for (k = 0; k < 2; k = k + 1) begin
```

Los operandos `A` y `B` pueden tomar 16 valores cada uno, desde `0000`
hasta `1111`, mientras que `Ci` puede tomar los valores `0` y `1`.

Por lo tanto, el número total de combinaciones verificadas es:

```text
16 × 16 × 2 = 512 combinaciones
```

Esto permite realizar una verificación exhaustiva del sumador de 4 bits.

## Cálculo del resultado esperado

Para cada combinación, el testbench calcula automáticamente el resultado
esperado mediante:

```verilog
expected = A + B + Ci;
```

La variable `expected` tiene cinco bits:

```verilog
reg [4:0] expected;
```

Esto permite representar tanto los cuatro bits correspondientes al
resultado como el posible acarreo de salida.

Por ejemplo:

```text
1111 + 0001 + 0 = 10000
```

En este caso:

```text
Co = 1
So = 0000
```

y el resultado completo es:

```text
{Co, So} = 10000
```

## Comparación automática

Después de aplicar cada combinación de entradas, el testbench espera
10 ns:

```verilog
#10;
```

Posteriormente compara el resultado obtenido por el circuito con el
resultado esperado:

```verilog
if ({Co, So} != expected)
```

Si existe alguna diferencia, se muestra un mensaje de error indicando
las entradas utilizadas, el resultado esperado y el resultado obtenido.

```verilog
$display(
    "ERROR: A=%b B=%b Ci=%b | Esperado=%b | Obtenido=%b",
    A, B, Ci, expected, {Co, So}
);
```

Al finalizar las 512 pruebas se muestra:

```text
Simulacion terminada.
```

Por lo tanto, si durante la ejecución no aparecen mensajes `ERROR`, se
verifica que todas las combinaciones probadas producen el resultado
esperado.

## Generación del archivo VCD

El testbench genera el archivo de formas de onda mediante:

```verilog
$dumpfile("sumador_4bit_all.vcd");
$dumpvars(0, tb_sumador_4bit_all);
```

El archivo `sumador_4bit_all.vcd` contiene las señales de la simulación y
puede abrirse posteriormente con GTKWave para observar el comportamiento
temporal del circuito.

## Ejecución

La compilación del módulo y del testbench se realiza mediante Icarus
Verilog:

```bash
iverilog -o sim_sumador_4bit sumador_4bit.v tb_sumador_4bit_all.v
```

Posteriormente se ejecuta la simulación:

```bash
vvp sim_sumador_4bit
```

Finalmente, las señales pueden visualizarse en GTKWave:

```bash
gtkwave sumador_4bit_all.vcd
```

## Demostración física en FPGA

Para la implementación física se utilizó el archivo `demo_sumador.v`.

En esta configuración, el operando `A` corresponde a las cuatro entradas
de la tarjeta:

```verilog
.A(ckey)
```

Mientras que el segundo operando y el acarreo de entrada se mantienen
fijos:

```verilog
.B(4'b0001),
.Ci(1'b0)
```

Por lo tanto, la operación realizada físicamente es:

```text
A + 0001
```

Las cuatro salidas del resultado se conectan a los LED:

```verilog
assign LED = ~So;
```

La inversión se utiliza debido a la lógica activa en bajo de los LED de
la tarjeta.

El acarreo de salida se conecta al buzzer:

```verilog
assign BUZZER = ~Co;
```

De esta forma, la demostración permite observar el resultado de la suma
mediante los LED y la generación del acarreo mediante el buzzer.

## Prueba física

Al variar las cuatro entradas de `A`, se obtienen los siguientes
resultados:

| A | B | Ci | Resultado | Co |
|---|---|---|---|---|
| `0000` | `0001` | 0 | `0001` | 0 |
| `0001` | `0001` | 0 | `0010` | 0 |
| `0010` | `0001` | 0 | `0011` | 0 |
| `0011` | `0001` | 0 | `0100` | 0 |
| `0100` | `0001` | 0 | `0101` | 0 |
| `0101` | `0001` | 0 | `0110` | 0 |
| `0110` | `0001` | 0 | `0111` | 0 |
| `0111` | `0001` | 0 | `1000` | 0 |
| `1000` | `0001` | 0 | `1001` | 0 |
| `1001` | `0001` | 0 | `1010` | 0 |
| `1010` | `0001` | 0 | `1011` | 0 |
| `1011` | `0001` | 0 | `1100` | 0 |
| `1100` | `0001` | 0 | `1101` | 0 |
| `1101` | `0001` | 0 | `1110` | 0 |
| `1110` | `0001` | 0 | `1111` | 0 |
| `1111` | `0001` | 0 | `0000` | 1 |

El último caso permite comprobar la generación del acarreo:

```text
1111 + 0001 = 10000
```

Los cuatro LED representan los cuatro bits menos significativos
(`0000`), mientras que el acarreo `Co=1` se utiliza para activar el
buzzer.

## Conclusión de la simulación

El testbench permitió verificar las 512 combinaciones posibles de las
entradas del sumador de 4 bits. La comparación automática entre
`{Co, So}` y `expected` permite comprobar de manera exhaustiva el
funcionamiento lógico del circuito.

Posteriormente, la implementación física mediante `demo_sumador.v`
permitió comprobar el funcionamiento del circuito en la FPGA utilizando
las entradas y salidas disponibles en la tarjeta.

### Punto importante para el in
### Punto importante para el informe

En este caso hay que distinguir **dos pruebas diferentes**:

**Simulación:** se prueban las **512 combinaciones** de `A`, `B` y `Ci`.



**Implementación física:** no se prueban las 512 combinaciones porque `demo_sumador.v` fija:

B=0001,

y solamente se varía `A`. Por tanto, físicamente se comprueban las **16 combinaciones de `A`**, desde `0000` hasta `1111`.

Esta distinción es importante para que el `README` y el informe no mezclen la verificación exhaustiva del testbench con la demostración realizada sobre la tarjeta.