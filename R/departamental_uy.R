#' @title Resultado de elecciones departamentales de Uruguay
#' @description Devuelve el resultado electoral por eleccion departamentall en cantdiad de votos
#'     y en porcentaje.
#' @param eleccion Anio de eleccion.
#' @param departamento character vector con nombre de los departamentos seleccionados.
#'     Por defecto estan los 19 departamentos de Uruguay
#' @return data.frame.
#' @examples
#' departamental_uy(eleccion = 1966)
#' agrupar_partidos_uy(departamental_uy(1966))
#' departamental_uy(1966, departamento = c("Artigas", "Rivera", "Montevideo"))
#' @export


departamental_uy <- function(eleccion, departamento = departamentos){

    if(!(eleccion %in% elecciones(tipo = "Departamental"))) stop("En ese anio no hubo eleccion Departamental.", call. = FALSE)
    dep <- elecciones_uy %>%
        filter(eleccion == 'Departamental', anio_eleccion == {{eleccion}}) %>%
        group_by(departamento, partido, fecha) %>%
        summarize(sum_partidos = sum(votos, na.rm = TRUE)) %>%
        ungroup() %>%
        group_by(departamento) %>%
        mutate(total = sum(sum_partidos, na.rm = TRUE),
               Porcentaje = round((sum_partidos / total)*100, 2),
               Eleccion = 'Departamental',
               fecha = as.Date(fecha)) %>%
        ungroup() %>%
        arrange(departamento, -Porcentaje) %>%
        rename(Votos = sum_partidos) %>%
        select(fecha, Eleccion, departamento, partido, Votos, Porcentaje)
    names(dep) <- str_to_title(names(dep))
    out <- dep %>% sigla() %>% zero()
    out <- subset(out, Departamento %in% departamento)
    attr(out, "DPU") <- "boreluy_departamental"
    return(out)
}
