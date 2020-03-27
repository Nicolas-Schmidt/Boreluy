#' @title as_esaps
#' @description Convierte salida de la funcion \code{\link{resultados_elecciones_uy}} al formato necesario para
#'     poder usar el paquete \code{esaps}.
#' @param datos Datos de la clase \code{boreluy_elecciones}.
#' @return data.frame.
#' @export

as_esaps <- function(datos){

    if(!inherits(datos, "boreluy_elecciones")){stop("Los datos deben ser una salida de la funcion `resultados_elecciones_uy`.", call. = FALSE)}

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
    salida
}
