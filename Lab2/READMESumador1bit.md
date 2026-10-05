# Sumador completo de 1 bit

## Descripción

Se implementó un sumador completo de 1 bit mediante Verilog. El circuito
recibe tres entradas binarias:

- `A`: primer operando.
- `B`: segundo operando.
- `Ci`: acarreo de entrada.

El circuito genera dos salidas:

- `So`: resultado de la suma.
- `Co`: acarreo de salida.

La lógica implementada corresponde a:

```text
So = A XOR B XOR Ci
Co = (A AND B) OR (Ci AND (A XOR B))
```

El módulo utilizado para implementar esta función es `sumador_1bit`.

## Implementación física

Para realizar la prueba en la tarjeta FPGA se utilizó el módulo
`demo_sumador_1bit.v`.

Este módulo utiliza el sumador completo como bloque interno y adapta sus
salidas a los dispositivos físicos de la tarjeta.

El resultado `So` se utiliza para controlar un LED, mientras que el
acarreo `Co` se utiliza para controlar otro LED y el buzzer.

Debido a que los LED de la tarjeta utilizan lógica activa en bajo, las
salidas destinadas a los LED se invierten antes de conectarlas a los
pines físicos.

De esta manera:

```text
So = 1  → LED de So encendido
So = 0  → LED de So apagado

Co = 1  → LED de Co encendido y buzzer activado
Co = 0  → LED de Co apagado y buzzer apagado
```

La asignación del buzzer permite utilizar la generación del acarreo como
una indicación física de que la suma produjo un resultado que requiere
un segundo bit.

## Tabla de funcionamiento

El sumador completo posee tres entradas binarias, por lo que existen
ocho combinaciones posibles:

| A | B | Ci | So | Co |
|---|---|----|----|----|
| 0 | 0 | 0  | 0  | 0  |
| 0 | 0 | 1  | 1  | 0  |
| 0 | 1 | 0  | 1  | 0  |
| 0 | 1 | 1  | 0  | 1  |
| 1 | 0 | 0  | 1  | 0  |
| 1 | 0 | 1  | 0  | 1  |
| 1 | 1 | 0  | 0  | 1  |
| 1 | 1 | 1  | 1  | 1  |

Cuando `Co=1`, se ha generado un acarreo y el buzzer se utiliza como
indicador de esta condición.

## Simulación

La simulación se realiza mediante el archivo:

```text
tb_sumador_1bit.v
```

El testbench permite aplicar diferentes combinaciones de `A`, `B` y
`Ci` al módulo `sumador_1bit` y observar las respuestas de `So` y `Co`.

Al tener tres entradas binarias, el número total de combinaciones es:

```text
2³ = 8
```

Por lo tanto, una verificación completa debe evaluar las ocho
combinaciones posibles.

## Ejecución de la simulación

Utilizando Icarus Verilog, el módulo y el testbench pueden compilarse
con:

```bash
iverilog -o sim_sumador_1bit sumador_1bit.v tb_sumador_1bit.v
```

La simulación se ejecuta mediante:

```bash
vvp sim_sumador_1bit
```

Si el testbench genera un archivo VCD, este puede visualizarse mediante
GTKWave:

```bash
gtkwave sumador_1bit.vcd
```

## Análisis de la simulación

La simulación permite verificar el comportamiento lógico del sumador
antes de realizar la implementación en la FPGA.

Para cada combinación de las entradas se comprueba que `So` represente
el bit menos significativo de la suma y que `Co` represente el acarreo
generado.

Por ejemplo:

```text
A = 1
B = 1
Ci = 0
```

produce:

```text
1 + 1 + 0 = 10₂
```

Por lo tanto:

```text
So = 0
Co = 1
```

En este caso se genera un acarreo y, en la implementación física, esta
condición se utiliza para activar el buzzer.

Otro caso es:

```text
A = 1
B = 1
Ci = 1
```

que produce:

```text
1 + 1 + 1 = 11₂
```

por lo que:

```text
So = 1
Co = 1
```

La simulación permite comprobar que el comportamiento lógico coincide
con la tabla de verdad del sumador completo.

## Implementación en la FPGA

Después de verificar el diseño mediante simulación, el proyecto fue
compilado en Quartus y programado en la tarjeta FPGA.

Las entradas del sumador se controlan mediante las entradas físicas de
la tarjeta, mientras que las salidas se visualizan mediante los LED.

El acarreo `Co` se utiliza adicionalmente para controlar el buzzer.
Así, la implementación física proporciona una indicación visual y
sonora cuando se genera un acarreo.

## Resultado

La simulación permite verificar las ocho combinaciones posibles del
sumador completo de 1 bit. Posteriormente, la implementación física
permite comprobar el mismo comportamiento mediante los dispositivos de
entrada y salida de la FPGA.

La utilización del buzzer como indicador del acarreo permite observar
físicamente la generación de `Co`, mientras que los LED permiten
visualizar el resultado `So` y el estado del acarreo.


Tabla de resultados y condiciones fisicas esperadas


| A | B | Ci | So | Co | LED So* | LED Co* | Buzzer* |
|---|---|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 0 | 1 | 0 | 0 |
| 0 | 1 | 0 | 1 | 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 0 | 1 | 0 | 1 | 1 |
| 1 | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
| 1 | 0 | 1 | 0 | 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 | 1 | 0 | 1 | 1 |
| 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |