#' @title as_esaps
#' @description Convierte salida de la funcion \code{resultados_elecciones_uy} al formato necesario para
#'     poder usar el paquete \code{esaps}.
#' @param datos Datos de la clase \code{boreluy_elecciones}.
#' @return data.frame.
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
    if(attr(datos, 'parlamento')){
        if(attr(datos, 'departamento')){
            stop('No es posible compilar las bancas por departamento para hacer calculos de desproporcionalidad: use `por_departamento = TRUE`.',  call. = FALSE)
        }else{
            datos2 <- datos %>%
                mutate(seats = round(datos$Diputados / sum(datos$Diputados),1)*100) %>%
                select(Partido, seats)
            names(datos2)[1] <- 'party'
        }
        salida <- full_join(salida, datos2, by = 'party')
    }
    as.data.frame(salida)
}
