
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Paquete de R `Boreluy` <img src='man/figures/logo_Boreluy.png' align="right" height="180" />

*Nicolas Schmidt, Antonio Cardarello, Diego Lujan*

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/suspended.svg)](https://www.repostatus.org/#active)
<!-- badges: end --> <!-- badges: end -->

### Acerca de

### Instalacion

``` r
# install.packages("devtools")
devtools::install_github("Nicolas-Schmidt/`Boreluy")
```

## Resultados electorales

``` r
library(Boreluy)
library(ggplot2)
library(magrittr)


elec71 <- resultado_elecciones_uy(anio = 1971, tipo = 'Presidencial', por_departamento = FALSE)

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

<img src="man/figures/README-unnamed-chunk-2-1.png" width="60%" />

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

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" height="100%" />

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

##### Camara de Representantes

``` r
diputados <- 
    parlamento_uy(anio = 1971, por_departamento = FALSE) %>% 
    Boreluy::as_parliament(., camara = 1, color = c('#E81B23', '#3333FF', '#B4B4B4')) %>% 
    par_uy(., titulo = "Camara de Representantes Uruguay 1971", mayoria = 51)

diputados
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="60%" />

##### Camara de Senadores

``` r
senadores <- 
    parlamento_uy(anio = 1971, por_departamento = FALSE) %>% 
    Boreluy::as_parliament(., camara = 2, color = c('#E81B23', '#3333FF', '#B4B4B4')) %>% 
    par_uy(., titulo = "Camara de Senadores Uruguay 1971", mayoria = 16)

senadores
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="60%" />
