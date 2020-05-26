#' @title as_esaps
#' @description Convierte salida de la funcion \code{nacional_uy} al formato necesario para
#'     poder usar el paquete \code{esaps}.
#' @param datos Datos de la clase \code{boreluy_elecciones}.
#' @return data.frame.
#' @examples
#' elec <- nacional_uy(eleccion = 1971)
#'
#' elec <- as_esaps(elec)
#'
#' # Numero efectivo de partidos
#' # esaps::enp(elec)
#'
#'
#' # Desproporcionalidad electoral
#' # esaps::dispro(elec, method = 1)
#'
#' # Nacionalizacion del sistema de partidos y de los partidos politicos
#' # esaps::psns(tidy_data = elec, method = 1, pns = TRUE)
#'
#'
#' @export

as_esaps <- function(datos){

    if(!inherits(datos, "boreluy_nacional")) stop("Los datos deben ser una salida de la funcion `nacional_uy`.", call. = FALSE)
    if(any(names(datos) == 'Departamento')) unidad <- datos$Departamento else unidad <- 'Uruguay'
    salida <- tibble::tibble(
        election = substring(datos$Fecha, 1, 4),
        unit     = unidad,
        party    = datos$Partido,
        votes    = datos$Porcentaje
    )
    if('Diputados' %in% names(datos)){
        if('Departamento' %in% names(datos)){
            datos2 <- datos %>% group_by(Fecha, Departamento) %>%
                mutate(seats = Diputados / sum(Diputados)*100) %>%
                ungroup() %>%
                select(Fecha, Partido, seats, Departamento) %>%
                rename(unit = Departamento)
        } else {
            datos2 <- datos %>% group_by(Fecha) %>%
                mutate(seats = Diputados / sum(Diputados)*100) %>%
                ungroup() %>%
                select(Fecha, Partido, seats)
        }
        datos2 <- datos2 %>% mutate(Fecha = substring(datos$Fecha, 1, 4))
        names(datos2)[1:2] <- c('election', 'party')
        salida <- full_join(salida, datos2, by = intersect(names(salida), names(datos2)))
    }
     return(salida %>% arrange(election, unit))
}






