#' @title Resultados electorales de elecciones nacionales y departamemntales
#' @description Devuelve el resultado electoral por eleccion en cantdiad de votos
#'     y en porcentaje.
#' @param anio Anio de eleccion.
#' @param tipo Tipo de eleccion.
#' @param por_departamento Por defecto es \code{FALSE}. Si es \code{TRUE} devuelve el resultado por departamento.
#' @return data.frame.
#' @examples
#' resultado_elecciones_uy(anio = 1999, tipo = "Presidencial", por_departamento = FALSE)
#' @export


resultado_elecciones_uy <- function(anio = max(elecciones_uy$anio),
                     tipo = NULL,
                     por_departamento = FALSE
                     ){

    if(is.null(tipo)){tipo <- elecciones_uy$eleccion[which.max(elecciones_uy$anio)]}
    if(tipo == 'Departamental'){por_departamento <-  TRUE}
    datos <- elecciones_uy %>% filter(anio_eleccion == anio,  eleccion == tipo)

    if(por_departamento){
        a <- datos %>%
            group_by(partido, departamento) %>%
            summarise(Votos = sum(votos, na.rm = TRUE))
        b <- a %>% group_by(departamento) %>%  summarize(total = sum(Votos, na.rm = TRUE))
        ab <- full_join(a, b, 'departamento') %>%
            mutate(Porcentaje = round((Votos / total * 100), 2)) %>%
            arrange(-Porcentaje) %>%
            split(., .$departamento) %>%
            do.call(rbind,.) %>%
            select(-total)
    }else{
        ab <- datos %>%
            group_by(partido) %>%
            summarise(Votos = sum(votos)) %>%
            mutate(Porcentaje = round((Votos / sum(Votos) * 100),2)) %>%
            arrange(-Porcentaje)
    }
    sal <- sigla(dat = ab, anio = anio)
    attr(sal, 'departamento') <- por_departamento
    class(sal) <- c(class(sal), "boreluy_elecciones")
    return(sal)
}







