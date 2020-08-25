#' @title as_esaps
#' @description Convierte salida de la funcion \code{nacional_uy} al formato necesario para
#'     poder usar el paquete \code{esaps}.
#' @param datos Datos de la clase \code{boreluy}.
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

    if(!inherits(datos, "boreluy")) stop("Los datos deben ser una salida de la funcion `nacional_uy`.", call. = FALSE)
    if(any(names(datos) == 'Departamento')) unidad <- datos$Departamento else unidad <- 'Uruguay'
    salida <- tibble::tibble(
        election = substring(datos$Fecha, 1, 4),
        unit     = unidad,
        party    = datos$Partido,
        votes    = datos$Porcentaje
    )
    datos2 <- datos

    if('Diputados' %in% names(datos)){
        if('Departamento' %in% names(datos)){
            datos2 <-
                datos2 %>%
                group_by(Fecha, Departamento) %>%
                mutate(seats = Diputados / sum(Diputados, na.rm = TRUE) * 100) %>%
                ungroup()
        } else {
            datos2 <-
                datos2 %>%
                group_by(Fecha) %>%
                mutate(seats = Diputados / sum(Diputados, na.rm = TRUE) * 100) %>%
                ungroup()
        }
    }
    if('Departamento' %in% names(datos)){
        datos2 <-
            datos2 %>%
            mutate(total = sum(Votos, na.rm = TRUE)) %>%
            group_by(Partido) %>%
            mutate(votes_nac = (sum(Votos, na.rm = TRUE) / total * 100)) %>%
            ungroup() %>%
            rename(unit = Departamento) %>%
            mutate(votes_nac = ifelse(votes_nac == 0, NA, votes_nac))
    }
    datos2 <-
        datos2 %>% rename(
            party = Partido,
            election = Fecha,
            votes = Porcentaje
        ) %>%
        mutate(election = substring(election, 1, 4))

    vars <- c('election','unit', 'party', 'votes', 'votes_nac', 'seats')
    datos2 <- datos2[, names(datos2) %in% vars]
    datos2 <- full_join(salida, datos2, by = intersect(names(salida), names(datos2))) %>%
        mutate(votes = ifelse(votes == 0, NA, votes))
    return(datos2 %>% arrange(election, unit) %>% as.data.frame())
}






