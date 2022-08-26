## Boreluy 0.1.7

* Se adapta la salida de la funcion `agrupar_partidos_uy()` par las elecciones de la decada del 20 en donde las Legislativas del senado son por tercios. Por ejemplo, en el anio 1925 hay dos elecciones, ahora la funcion devuelve el resultado agrupado en un unico data.frame para las dos elecciones.


## Boreluy 0.1.6

* Se agregan datos de voto en blanco y voto anulado para las elecciones departamentales desde 1985 a la actualidad.

## Boreluy 0.1.5

* Datos de composicion de parlamento y elecciones departamentales 2020


## Boreluy 0.1.4

* La salida de `agrupar_partidos_uy()` ahora tiene las mismas variables que la salida de `nacional_uy()` y que `departamental_uy()`.
* Se arreglaron los conflictos de clase de boreluy con "tbl_df" y "tbl".
* as_esaps ahora funciona con `departamental_uy()`
* `departamental_uy()` ahora reporta si en el anio solicitado hay eleccion departamental.
* se agrega la funcion `elecciones()`
* se agrega argumento departamento a la funcion `departamental_uy()` para obtener resultados parciales territorialmente

## Boreluy 0.1.3

* Se ajusta por rutina nombre de partidos de eleccion de 1962 en funcion `as_esaps()`


## Boreluy 0.1.2

* Se ajusta visualización para elecciones presidenciales concurrentes con legislativas.

## Boreluy 0.1.1

* pre lanzamiento en publico con con ajustes globales. Se arregla inconsistencia entre entre clase `boreluy_nacional` y `boreluy_elecciones`, se unifica en 'boreluy'.

## Boreluy 0.1.0.908

* error en as_esaps() que significó un cambio en psns() de esaps

## Boreluy 0.1.0.907

* Se cambia la funcion `resultado_elecciones_uy` por `nacional_uy` y `departamental_uy`.La nuevas funciones requieren menos uso de argumentos y las salidas son mas completas.

## Boreluy 0.1.0.906

* Se agregó el argumento tabla a la función `resumen_elecciones_uy`
* Se agregó la función `grafico_elecciones_uy`

## Boreluy 0.1.0.905

* Se eliminó la función `resultado_parlamemto_uy` y pasó a argumento de la función `resultado_elecciones_uy` como `parlamento`.

## Boreluy 0.1.0.904

* Se agregan elecciones a la base `elecciones_uy` - 2019: Presidencial y Balotaje
* Se agregan partidos a la base `partidos_uy`
* se agrega el argumento `vbva.rm` a la función `resultados_electorales_uy`. Este argumento permite eliminar de los cálculos a los votos en blanco y anulados.
* Cambió el nombre de la función `parlamento_uy` a `resultado_parlamemto_uy`.
* Cambió el nombre de la función `resultado_elecciones_uy` a `resultado_eleccion_uy`.

## Boreluy 0.1.0.903

* Se agregan elecciones a la base 'elecciones_uy' - 2014: Balotaje 




