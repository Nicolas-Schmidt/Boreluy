#' @title Agrupa partidos politicos
#' @description Permite agrupar partidos politicos de la salida de la funcion \code{nacional_uy} y \code{departamental_uy}.
#'     Junta las categorias de Voto en Blanco y Voto Anulado y en Otros Partidos a los que no alcanzan determinado umbral.
#' @param datos data.frame que devuelve la funcion \code{nacional_uy} y \code{departamental_uy}.
#' @param umbral Valor relativo al porcentaje bajo el cual se van a agrupar a los partidos como 'Otros Partidos'
#' @return data.frame.
#' @examples
#' elec71 <- nacional_uy(eleccion = 1971)
#' agrupar_partidos_uy(elec71)
#' @export

agrupar_partidos_uy <- function(datos, umbral = 2){

    datos$corte <- ifelse(datos$Porcentaje < umbral, 'Otros Partidos', datos$Partido)
    datos$corte <- ifelse(datos$Partido %in% c('Voto Anulado', 'Voto en Blanco'), 'Voto Blanco/Anulado', datos$corte)

    if(attributes(datos)$DPU == "boreluy_departamental") { ### check
        datos1 <- datos %>% group_by(corte, Eleccion, Departamento)
        datos1 <-  ap(datos1, umbral = umbral, departamental = TRUE) %>%
            select(Eleccion, Departamento, Partido, Sigla, Votos, Porcentaje) %>%
            arrange(Eleccion, Departamento,  -Votos) %>% ungroup()
    } else {
        datos1 <- datos %>% group_by(corte, Eleccion)
        datos1 <-  ap(datos1, umbral = umbral, departamental = FALSE) %>%
            select(Eleccion, Partido, Sigla, Votos, Porcentaje, Diputados, Senadores)%>%
            arrange(Eleccion,  -Votos) %>% ungroup()
    }

    datos1$Sigla <- ifelse(datos1$Partido == 'Voto Blanco/Anulado', 'VB/VA',
                           ifelse(datos1$Partido == 'Otros Partidos', 'OtrosP.', datos1$Sigla))
    bind_cols(Fecha = unique(datos$Fecha), datos1)

}
