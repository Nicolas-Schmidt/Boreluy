
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Borel<span style="color:blue">**uy**</span> <img src='man/figures/logo_justino.png' align="right" height="180" />

*Nicolás Schmidt, Antonio Cardarello, Diego Luján*

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Travis build
status](https://travis-ci.com/Nicolas-Schmidt/Boreluy.svg?branch=master)](https://travis-ci.com/Nicolas-Schmidt/Boreluy)
<!-- badges: end -->

> Datos electorales de Uruguay 1918 - 2020.

### Descripción

Este paquete de R proporciona un conjunto de datos que contienen
resultados electorales al máximo nivel de desagregación posible y
comparable entre elecciones. Adicionalmente provee un conjunto de
funciones que permiten obtener agregaciones de los datos (resultado por
partido, por partido-departamento…).

El manual del paquete esta
[**aquí**](https://github.com/Nicolas-Schmidt/Boreluy/blob/master/man/figures/Manual_Boreluy.pdf).

> ¿Por qué Boreluy? ……

### Instalación

Versión en desarrollo

``` r
source("https://install-github.me/Nicolas-Schmidt/Boreluy")
```

## Elecciones Uruguayas

``` r
library(Boreluy)
resumen_elecciones_uy()
#> 
#> 
#> --- Cantidad de elecciones ------------------------------------
#> 
#> -->  Presidencial                       : 18  (34%) 
#> -->  Balotaje                           : 1    (2%) 
#> -->  Departamental                      : 20  (38%) 
#> -->  Legislativa                        : 10  (19%) 
#> -->  Consejo Nacional de Administracion : 4    (8%) 
#> 
#> ---------------------------------------------------------------
#> 
#>       Presidencial  Balotaje  Departamental  Legislativa  CNA
#> 1918                                                   X     
#> 1919                                      X            X     
#> 1920                                                        X
#> 1922             X                                     X     
#> 1925                                      X            X     
#> 1926             X                                     X     
#> 1928                                      X            X    X
#> 1930             X                                     X    X
#> 1931                                      X            X     
#> 1932                                                   X    X
#> 1934                                                   X     
#> 1938             X                        X                  
#> 1942             X                        X                  
#> 1946             X                        X                  
#> 1950             X                        X                  
#> 1954             X                        X                  
#> 1958             X                        X                  
#> 1962             X                        X                  
#> 1966             X                        X                  
#> 1971             X                        X                  
#> 1984             X                        X                  
#> 1989             X                        X                  
#> 1994             X                        X                  
#> 1999             X         X                                 
#> 2000                                      X                  
#> 2004             X                                           
#> 2005                                      X                  
#> 2010                                      X                  
#> 2014             X                                           
#> 2015                                      X                  
#> 
#> ---------------------------------------------------------------
```

## Resultados electorales

``` r

library(ggplot2)
library(magrittr)


elec71 <- resultado_elecciones_uy(anio = 1971, tipo = 'Presidencial', por_departamento = FALSE)

elec71
#> # A tibble: 9 x 5
#>   Eleccion Partido                                     Sigla  Votos Porcentaje
#>      <dbl> <chr>                                       <chr>  <dbl>      <dbl>
#> 1     1971 Partido Colorado                            PC    681624      39.8 
#> 2     1971 Partido Nacional                            PN    668822      39.0 
#> 3     1971 Frente Amplio                               FA    304275      17.8 
#> 4     1971 Voto Anulado                                VB     42508       2.48
#> 5     1971 Union Radical Cristiana                     URC     8844       0.52
#> 6     1971 Voto en Blanco                              VA      6139       0.36
#> 7     1971 Partido de Jubilados y Pensionistas         PJP      288       0.02
#> 8     1971 Movimiento Justiciero                       MJ       241       0.01
#> 9     1971 Partido Juventud por el Desarrollo Oriental PJDO      25       0


ggplot(data = elec71 , aes(x = reorder(Partido, Porcentaje), y = Porcentaje)) +
    geom_bar(stat = "identity", position = "stack", fill = "#00A08A", color = "black") +
    ylim(0,100) +
    coord_flip() +
    geom_text(aes(label = paste0(Porcentaje, "%")), hjust = -0.5, color = "gray9", size = 3) +
    labs(x = "", y = "",
         title = "Resultado de elección nacional de 1971",
         subtitle = "28 de noviembre de 1971") +
    theme_minimal()
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="60%" />

``` r
elec71 <- resultado_elecciones_uy(1971, 'Presidencial', por_departamento = TRUE) 

ggplot(data = elec71 , aes(x = reorder(Sigla, Porcentaje), y = Porcentaje)) +
    geom_bar(stat="identity", position = "stack", fill = "#00A08A", color = "black") +
    ylim(0,100) +
    coord_flip() +
    geom_text(aes(label = paste0(Porcentaje, "%")), hjust = -0.5, color = "gray9", size = 2) +
    labs(x = "", y = "",
         title = "Resultado de elección nacional de 1971",
         subtitle = "28 de noviembre de 1971") +
    theme_minimal() + 
    theme(axis.text.x = element_text(size = 6),
          axis.text.y = element_text(size = 6)) +
    facet_wrap(~Departamento)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" height="100%" />

## Parlamento

``` r
library(ggparliament)

parlamento_uy(anio = 1971, por_departamento = FALSE)
#> # A tibble: 3 x 5
#>   Eleccion Partido          Sigla Diputados Senadores
#>      <dbl> <chr>            <chr>     <dbl>     <dbl>
#> 1     1971 Partido Colorado PC           41        14
#> 2     1971 Partido Nacional PN           40        12
#> 3     1971 Frente Amplio    FA           18         5


# creamos una funcion para graficar parlamento
par_uy <- function(datos, titulo, mayoria, ...){
    
    ggplot(datos, aes(x, y, colour = party_long)) +
    geom_parliament_seats() + 
    geom_highlight_government(government == 1) +
    draw_majoritythreshold(n = mayoria, label = FALSE, type = 'semicircle') +
    geom_parliament_bar(colour = colour, party = party_long) + 
    theme_ggparliament() +
    labs(colour = NULL, 
         title = titulo,
         subtitle = "") +
    scale_colour_manual(values = datos$colour,
                        limits = datos$party_long)
}
```

#### Camara de Representantes

``` r
diputados <- 
    parlamento_uy(anio = 1971, por_departamento = FALSE) %>% 
    Boreluy::as_parliament(., camara = 1, color = c('#E81B23', '#3333FF', '#B4B4B4')) %>% 
    par_uy(., titulo = "Camara de Representantes Uruguay 1971", mayoria = 51)

diputados
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="60%" />

#### Camara de Senadores

``` r
senadores <- 
    parlamento_uy(anio = 1971, por_departamento = FALSE) %>% 
    Boreluy::as_parliament(., camara = 2, color = c('#E81B23', '#3333FF', '#B4B4B4')) %>% 
    par_uy(., titulo = "Camara de Senadores Uruguay 1971", mayoria = 16)

senadores
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="60%" />

#### Aplicaciones alternativas

``` r
datos <- 
    purrr::map_df(c(1984, 1989, 1994, 1999, 2004), resultado_elecciones_uy, 'Presidencial') %>% 
    as_esaps()

## Volatilidad electoral

esaps::evolat(datos, "Pedersen")
#>   election    unit eVolat
#> 1     1989 Uruguay  14.14
#> 2     1994 Uruguay  11.60
#> 3     1999 Uruguay  11.12
#> 4     2004 Uruguay  26.18


## Número efectivo de partidos

esaps::enp(datos)
#>   election    unit  enp
#> 1     1984 Uruguay 3.09
#> 2     1989 Uruguay 3.66
#> 3     1994 Uruguay 3.67
#> 4     1999 Uruguay 3.29
#> 5     2004 Uruguay 2.61
```

-----

##### Mantenedor

Nicolás Schmidt (<nschmidt@cienciassociales.edu.uy>)

##### Diseño de logo

Nadia Repetto (<narepetto@gmail.com>)
