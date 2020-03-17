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


    if(is.null(tipo)){tipo <- elecciones$eleccion[which.max(elecciones$anio)]}
    if(tipo == 'Departamental'){por_departamento <-  TRUE}
    datos <- elecciones %>% filter(anio_eleccion == anio,  eleccion == tipo)

    if(por_departamento){

        a <- datos %>%
            group_by(partido, departamento) %>%
            summarise(Votos = sum(votos, na.rm = TRUE))
        b <- a %>% group_by(departamento) %>%  summarize(total = sum(Votos, na.rm = TRUE))
        ab <- full_join(a, b, 'departamento') %>%
            mutate(Porcentaje = (Votos / total * 100)) %>%
            arrange(-Porcentaje) %>%
            split(., .$departamento) %>%
            do.call(rbind,.) %>%
            select(-total)


    } else {

        ab <- datos %>%
            group_by(partido) %>%
            summarise(Votos = sum(votos)) %>%
            mutate(Porcentaje = (Votos / sum(Votos) * 100)) %>%
            arrange(-Porcentaje)

    }
    names(ab) <- tools::toTitleCase(names(ab))
    return(ab)

}







