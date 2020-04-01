#' @title Agrupa partidos politicos
#' @description Permite agrupar partidos politicos de la salida de la funcion \code{resultados_elecciones_uy}.
#'     Junta las categorias de Voto en Blanco y Voto Anulado y en Otros Partidos a los que no alcanzan determinado umbral.
#' @param datos data.frame de clase \code{boreluy_elecciones} que devuelve la funcion \code{resultados_elecciones_uy}.
#' @param umbral Valor relativo al porcentaje bajo el cual se van a agrupar a los partidos como 'Otros Partidos'
#' @return data.frame.
#' @examples
#' elec99 <- resultado_eleccion_uy(anio = 1999, tipo = "Presidencial", por_departamento = FALSE)
#' agrupar_partidos_uy(elec99)
#' @export


agrupar_partidos_uy <- function(datos, umbral = 2){

    if(!inherits(datos, "boreluy_elecciones")){stop("Los datos deben ser una salida de la funcion `resultados_elecciones_uy`.", call. = FALSE)}
    if(inherits(datos, "be_departamento")){
        tab <- split(datos, datos$Departamento) %>%  map(ap, umbral = umbral)
        dep <- rep(names(tab), sapply(tab, nrow))
        tab <- do.call(rbind, tab)
        tab$Departamento <- dep
        tab[, c(1, 2, 6, 5, 3, 4)]

    }else{
        tab <- ap(datos = datos, umbral = umbral)
        tab[,c(1, 2, 5, 3, 4)]
    }

}
