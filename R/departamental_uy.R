#' @title Resultado de elecciones departamentales de Uruguay
#' @description Devuelve el resultado electoral por eleccion departamentall en cantdiad de votos
#'     y en porcentaje.
#' @param eleccion Anio de eleccion.
#' @return data.frame.
# @examples
# departamental_uy(eleccion = 1966)
# agrupar_partidos_uy(departamental_uy(1966))
#' @export


departamental_uy <- function(eleccion){

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
    class(dep) <- c(class(dep), "boreluy_departamental")
    sigla(dep)

}
