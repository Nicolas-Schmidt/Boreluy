#' @title Agrupa partidos politicos
#' @description Permite agrupar partidos politicos de la salida de la funcion \code{resultado_eleccion_uy}.
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
    datos$corte <- ifelse(datos$Porcentaje < umbral, 'Otros Partidos', datos$Partido)
    datos$corte <- ifelse(datos$Partido %in% c('Voto Anulado', 'Voto en Blanco'), 'Voto Blanco/Anulado', datos$corte)

    if(inherits(datos, "be_departamento")){
        datos1 <- datos %>% group_by(corte, Eleccion, Departamento)
        datos1 <-  ap(datos1, umbral = umbral) %>%
            select(Eleccion, Departamento, Partido, Sigla, Votos, Porcentaje) %>%
            arrange(Eleccion, Departamento,  -Votos)

    }else{
        datos1 <- datos %>% group_by(corte, Eleccion)
        datos1 <-  ap(datos1, umbral = umbral) %>%
            select(Eleccion, Partido, Sigla, Votos, Porcentaje)%>%
            arrange(Eleccion,  -Votos)
    }

    datos1$Sigla <- ifelse(datos1$Partido == 'Voto Blanco/Anulado', 'VB/VA',
                           ifelse(datos1$Partido == 'Otros Partidos', 'OtrosP.', datos1$Sigla))
    datos1

}
