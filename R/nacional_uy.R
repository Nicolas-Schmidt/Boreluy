#' @title Resultado de elecciones nacionales de Uruguay
#' @description Devuelve el resultado electoral por eleccion nacional en cantdiad de votos
#'     y en porcentaje. Las eleccciones nacionales son: Presidencial, Balotaje, Legislativa y del
#'     Consejo Nacional de Administracion.
#' @param eleccion Anio de eleccion.
#' @param tipo Tipo de eleccion. POr defecto es 'Presidencial'
#' @param por_departamento Por defecto es \code{FALSE}. Si es \code{TRUE} devuelve el resultado por departamento.
#' @param vbva.rm Eliminar del calculo a los votos en blanco y anulados. Esto puede ser util para elecciones como el 'Balotaje'.
#' @return data.frame. Si la eleccion es concurrente (hay eleccion de cargos legislativos)
#'     devuelve la cantidad de bancas por partido. Si la eleccion no es concurrente solo devuelve
#'     el resultado en porcentaje de la eleccion por partido.
#' @examples
#' nacional_uy(eleccion = 1971)
#' nacional_uy(eleccion = 1999, por_departamento = TRUE)
#' nacional_uy(eleccion = 1999, tipo = 'Balotaje')
#' nacional_uy(1925, tipo = 'Legislativa')
#' @export


nacional_uy <- function(eleccion, tipo = 'Presidencial', por_departamento = FALSE, vbva.rm = FALSE){

    if(!(eleccion %in% elecciones(tipo = tipo))) stop(paste0("En ese anio no hubo eleccion ", tipo, "."), call. = FALSE)
    # pre out ------------------------------------------------------------------
    datos <- elecciones_uy %>%
        filter(eleccion == {{tipo}}) %>%
        pre_out(datos = .,  eleccion = {{eleccion}}, vbva.rm = vbva.rm) %>%
        mutate(eleccion = tipo) %>%
        select(fecha, eleccion, departamento, partido, cant_votos, sum_votos_par,
               por_deptos, por_nacional,
               Diputados, Senadores, sum_diputados, sum_senadores)
    names(datos) <- str_to_title(names(datos))
    if(por_departamento) {
        out <-
            datos %>%
            select(-c(Por_nacional, Sum_diputados, Sum_senadores, Sum_votos_par)) %>%
            rename(Porcentaje = Por_deptos,
                   Votos = Cant_votos) %>%
            arrange(Departamento, -Porcentaje)
    } else {
        out <-
            datos %>%
            select(-c(Por_deptos, Diputados, Senadores, Departamento, Cant_votos)) %>%
            rename(
                Porcentaje = Por_nacional,
                Diputados = Sum_diputados,
                Senadores = Sum_senadores,
                Votos = Sum_votos_par) %>%
            distinct() %>%
            arrange(-Porcentaje)

    }
    # salida en funcion de concurrencia ------------------------------------------
    if(concurrente(eleccion = {{eleccion}}, tipo = {{tipo}}) != 1){
        out <- out %>% select(-c(Diputados, Senadores))
    }
    end <- out %>% sigla() #%>% zero()
    attr(end, "DPU") <- "boreluy"
    return(end)
}













