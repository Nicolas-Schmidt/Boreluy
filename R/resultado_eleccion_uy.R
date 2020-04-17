#' @title Resultados electorales de elecciones nacionales y departamemntales
#' @description Devuelve el resultado electoral por eleccion en cantdiad de votos
#'     y en porcentaje.
#' @param anio Anio de eleccion.
#' @param tipo Tipo de eleccion.
#' @param por_departamento Por defecto es \code{FALSE}. Si es \code{TRUE} devuelve el resultado por departamento.
#' @param parlamento Por defecto es \code{FALSE}. Si es \code{TRUE} devuelve la cantidad de diputados y Senadores que obtuvo cada partido.
#' @param vbva.rm Eliminar del calculo a los votos en blanco y anulados. Esto puede ser util para elecciones como el 'Balotaje'.
#' @return data.frame.
#' @examples
#' resultado_eleccion_uy(anio = 1971,
#'                       tipo = "Presidencial",
#'                       por_departamento = FALSE,
#'                       parlamento = TRUE)
#' @export


resultado_eleccion_uy <- function(anio = integer(),
                     tipo = NULL,
                     por_departamento = FALSE,
                     parlamento = FALSE,
                     vbva.rm = FALSE) {

    if(tipo == 'Departamental') {por_departamento <-  TRUE}
    datos <- elecciones_uy %>% filter(anio_eleccion == anio,  eleccion == tipo)
    if(vbva.rm) {datos <- filter(datos, !partido %in% c('Voto en Blanco', 'Voto Anulado'))}

    if(por_departamento) {

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
    } else {
        ab <- datos %>%
            group_by(partido) %>%
            summarise(Votos = sum(votos, na.rm = TRUE)) %>%
            mutate(Porcentaje = round((Votos / sum(Votos, na.rm = TRUE) * 100),2)) %>%
            arrange(-Porcentaje)
    }
    sal <- sigla(dat = ab, anio = anio)
    if(parlamento) {
        par <- rpuy(anio = anio, por_departamento = por_departamento)
        if(por_departamento) {
            sal <- full_join(sal, par, by = c('Partido', 'Departamento'))
        } else {
            sal <- full_join(sal, par, by = c('Partido'))
        }
        sal[is.na(sal)] <- 0L
        class(sal) <- c(class(sal), "be_parlamento")
    }
    if(por_departamento) {class(sal) <- c(class(sal), "be_departamento")}
    class(sal) <- c(class(sal), "boreluy_elecciones")
    return(sal)
}












