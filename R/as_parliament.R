#' @title as_parliament
#'
#' @description Convierte salida de la funcion \code{\link{nacional_uy}} al formato necesario para
#'     poder usar el paquete \code{ggparliament}.
#' @param datos Datos de la clase \code{boreluy_parlamento}.
#' @param camara Por defecto es 1 que correponde a la camara baja o Camara de Represnetantes, si se
#'     indica 2 corresponde a la camara alta o Camara de Senadores.
#' @param color Paleta de colores con los que se van a identificar a los partidos politicos en el grafico.
#' @param tipo Tipo de parlamento (horseshoe, semicircle, circle, classroom, opposing benches)
#' @param ... argumentos adicionales de la funcion \code{\link[ggparliament]{parliament_data}}
#' @return data.frame.
#' @examples
#' diputados <- nacional_uy(eleccion = 1971)
#' as_parliament(diputados, camara = 1, color = c('#E81B23', '#3333FF', '#B4B4B4'))
#'
#' # ggplot2::ggplot(diputados, aes(x, y, colour = party_long)) +
#' #    ggplot2::geom_parliament_seats() +
#' #    ggplot2::geom_highlight_government(government == 1) +
#' #    ggplot2::draw_majoritythreshold(n = mayoria, label = FALSE, type = 'semicircle') +
#' #    ggplot2::geom_parliament_bar(colour = colour, party = party_long) +
#' #    ggplot2::theme_ggparliament() +
#' #    ggplot2::labs(colour = NULL, title = titulo, subtitle = "") +
#' #    ggplot2::scale_colour_manual(values = datos$colour, limits = datos$party_long)
#'
#' @export

as_parliament <- function(datos,
                          camara = 1,
                          color,
                          tipo = "semicircle",  ...){


    m <- "Los datos deben ser una salida de la funcion `nacional_uy(., por departamento = FALSE)`."
    if(!inherits(datos, "boreluy_nacional")) stop(m, call. = FALSE)
    if('Departamento' %in% names(datos)) stop(m, call. = FALSE)

    datos[datos == 0] <- NA
    datos <- na.omit(datos)
    if(camara == 1) {
        camara <- 'Representantes'
        seats  <- datos$Diputados
    } else {
        camara <- 'Senadores'
        seats  <- datos$Senadores
    }
    newdata <- data.frame(year        = as.numeric(substring(datos$Fecha, 1, 4)),
                          country     = 'Uruguay',
                          house       = camara,
                          party_long  = datos$Partido,
                          party_short = datos$Sigla,
                          seats       = seats,
                          government  = c(1, rep(0, nrow(datos)-1)),
                          colour      = sample(grDevices::colors(), size = length(seats)),
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

