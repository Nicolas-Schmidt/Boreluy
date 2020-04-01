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
#' # Desproporcionalidad electoral
#' # esaps::dispro(elec, method = 1)
#'
#'
#' @export

as_esaps <- function(datos){

    if(!inherits(datos, "boreluy_elecciones")){
        stop("Los datos deben ser una salida de la funcion `resultados_elecciones_uy`.", call. = FALSE)
        }
    if(any(names(datos) == 'Departamento')){
        unidad <- datos$Departamento
    }else{
        unidad <- 'Uruguay'
    }
    salida <- tibble::tibble(
        election = datos$Eleccion,
        unit     = unidad,
        party    = datos$Partido,
        votes    = datos$Porcentaje
    )
    if(inherits(datos, "be_parlamento")){
        if(inherits(datos, "be_departamento")){
            stop('No es posible compilar las bancas por departamento para hacer calculos de desproporcionalidad: use `por_departamento = TRUE`.',  call. = FALSE)
        }else{
            datos2 <- datos %>%
                group_by(Eleccion) %>%
                mutate(seats = round(Diputados / sum(Diputados),3)*100) %>%
                ungroup() %>%
                select(Eleccion, Partido, seats)
            names(datos2)[1:2] <- c('election', 'party')
        }
        salida <- full_join(salida, datos2, by = c('party', 'election'))
    }
    salida
}

















