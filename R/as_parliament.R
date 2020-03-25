#' @title as_parliament
#'
#' @description Convierte salida de la funcion \code{\link{parlamento_uy}} al formato necesario para
#'     poder usar el paquete \code{ggparliament}.
#' @param datos Datos de la clase \code{boreluy_parlamento}.
#' @param camara Por defecto es 1 que correponde a la camara baja o Camara de Represnetantes, si se
#'     indica 2 corresponde a la camara alta o Camara de Senadores.
#' @param color Paleta de colores con los que se van a identificar a los partidos politicos en el grafico.
#' @param tipo Tipo de parlamento (horseshoe, semicircle, circle, classroom, opposing benches)
#' @param ... argumentos adicionales de la funcion \code{\link[ggparliament]{parliament_data}}
#' @return data.frame.
#' @export

as_parliament <- function(datos,
                          camara = 1,
                          color = NULL,
                          tipo = "semicircle",  ...){


    if(!inherits(datos, "boreluy_parlamento")){stop("Los datos deben ser una salida de la funcion 'parlamento_uy'.", call. = FALSE)}

    if(camara == 1){
        camara <- 'Representantes'
        seats  <- datos$Diputados
    }else{
        camara <- 'Senadores'
        seats  <- datos$Senadores
    }

    newdata <- data.frame(year        = datos$Eleccion,
                          country     = 'Uruguay',
                          house       = camara,
                          party_long  = datos$Partido,
                          party_short = datos$Sigla,
                          seats       = seats,
                          government  = c(1, rep(0, nrow(datos)-1)),
                          colour      = color,
                          stringsAsFactors = FALSE
    )

    out <- ggparliament::parliament_data(
        election_data = newdata,
        type = tipo,
        parl_rows = nrow(newdata),
        party_seats = newdata$seats
    )

    out
}


