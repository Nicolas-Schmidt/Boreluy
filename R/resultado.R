#' @title Resultados electorales de elecciones nacionales y departamemntales
#' @description Devuelve el resultado electoral por eleccion en cantdiad de votos
#'     y en porcentaje.
#' @param anio Anio de eleccion.
#' @param tipo Tipo de eleccion.
#' @param por_departamento Por defecto es \code{FALSE}. Si es \code{TRUE} devuelve el resultado por departamento.
#' @return data.frame.
#' @examples
#' \donttest{
#' eleccion(anio = 1999, tipo = "Presidencial", por_departamento = FALSE)
#' @export


eleccion <- function(anio = max(elecciones$anio),
                     tipo = NULL,
                     por_departamento = TRUE
                     ){


    elec <- elecciones[, c('anio_eleccion', 'eleccion', 'partido', 'fraccion', 'departamento', 'votos')]
    if(is.null(tipo)){tipo <- elecciones$eleccion[which.max(elecciones$anio)]}
    datos <- elec %>% filter(anio_eleccion == anio,  eleccion == tipo)

    if(por_departamento){

        a <- datos %>%
            mutate(id = paste(partido, departamento, sep = "__")) %>%
            group_by(id) %>%
            summarise(Votos = sum(votos)) %>%
            separate(col = 1, into = c('Partido', 'Departamento'), sep = "__")
        b <- a %>% group_by(Departamento) %>%  summarize(total = sum(Votos))
        ab <- full_join(a, b, 'Departamento') %>%
            mutate(Porcentaje = (Votos / total * 100)) %>%
            arrange(-Porcentaje) %>%
            split(., .$Departamento) %>%
            do.call(rbind,.) %>%
            select(-total)
        ab

    } else {

        a <- datos %>%
            group_by(partido) %>%
            summarise(Votos = sum(votos)) %>%
            mutate(Porcentaje = (Votos / sum(Votos) * 100)) %>%
            arrange(-Porcentaje)
        a
    }

}









#eleccion(anio = 1999, tipo = "Presidencial", FALSE)
# explora
#library(tidyverse)
#elecciones <- rio::import(here::here("data", "megaDB.xlsx"))


