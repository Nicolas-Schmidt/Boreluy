#' @title as_esaps
#' @description Convierte salida de la funcion \code{resultado_eleccion_uy} al formato necesario para
#'     poder usar el paquete \code{esaps}.
#' @param datos Datos de la clase \code{boreluy_elecciones}.
#' @return data.frame.
#' @examples
#' elec <- resultado_eleccion_uy(anio = 1971,
#'                               tipo = "Presidencial",
#'                               por_departamento = FALSE,
#'                               parlamento = TRUE)
#'
#' elec <- as_esaps(elec)
#'
#' # Numero efectivo de partidos
#' # esaps::enp(elec)
#'
#'
#'
#' # Desproporcionalidad electoral#'
#' elec <- resultado_eleccion_uy(anio = 1971,
#'                               tipo = "Presidencial",
#'                               por_departamento = TRUE,
#'                               parlamento = FALSE)
#' elec <- as_esaps(elec)
#' # esaps::psns(tidy_data = elec, method = 1, pns = TRUE)
#' # esaps::dispro(elec, method = 1)
#'
#'
#' @export

as_esaps <- function(datos){

    if(!inherits(datos, "boreluy_elecciones")) {
        stop("Los datos deben ser una salida de la funcion `resultados_elecciones_uy`.", call. = FALSE)
        }
    if(any(names(datos) == 'Departamento')) {
        unidad <- datos$Departamento
    } else {
        unidad <- 'Uruguay'
    }
    salida <- tibble::tibble(
        election = datos$Eleccion,
        unit     = unidad,
        party    = datos$Partido,
        votes    = datos$Porcentaje
    )
    if(inherits(datos, "be_parlamento")) {
        if(inherits(datos, "be_departamento")) {
            stop('No es posible compilar las bancas por departamento para hacer calculos de desproporcionalidad: use `resultado_eleccion_uy(., por_departamento = FALSE)`.',  call. = FALSE)
        } else {
            datos2 <- datos %>%
                group_by(Eleccion) %>%
                mutate(seats = Diputados / sum(Diputados)*100) %>%
                ungroup() %>%
                select(Eleccion, Partido, seats)
            names(datos2)[1:2] <- c('election', 'party')
        }
        salida <- full_join(salida, datos2, by = c('party', 'election'))
    }
    if(inherits(datos, "be_departamento")) {
        names(datos)[c(1, 2, 4)] <- c('election','party', 'unit')
        salida <- datos %>%
            group_by(party, election) %>%
            mutate(votes_par = sum(Votos)) %>%
            ungroup() %>%
            group_by(unit, election) %>%
            mutate(votes_nac = round(votes_par / sum(votes_par)*100, 2)) %>%
            ungroup() %>%
            select(party, votes_nac, election, unit) %>%
            distinct() %>%
            full_join(salida, ., by = c('election', 'unit', 'party'))
    }
    salida
}





