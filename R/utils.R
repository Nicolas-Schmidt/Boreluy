
#' @importFrom dplyr filter select group_by rename mutate if_else full_join left_join arrange summarise right_join ungroup distinct summarize
#' @importFrom tidyr pivot_wider
#' @importFrom tibble as_tibble tibble deframe
#' @importFrom stringr str_to_title
#' @importFrom stats na.omit
#' @importFrom purrr map
#' @importFrom magrittr %>%
#' @importFrom Rdpack reprompt
#' @importFrom ggparliament parliament_data
#' @importFrom ggplot2 ggplot aes geom_tile scale_fill_manual labs theme element_text theme_minimal

vars <- c('elecciones_uy', 'eleccion', 'concurrente', 'partido', 'fecha', 'cant_votos', 'Cant_votos',
          'departamento', 'camara', 'Senadores', 'Diputados', 'sum_votos_par', 'por_deptos', 'seats', 'Freq',
          'por_nacional', 'sum_diputados', 'sum_senadores', 'Por_nacional', 'Sum_diputados', 'Sum_senadores',
          'votos', 'Votos', 'total', 'Porcentaje', 'partidos_uy', 'Por_deptos', 'bancas_diputados', 'bancas_senado',
          'corte', 'Eleccion', 'Departamento', 'Partido', 'Sigla', 'Fecha', 'anio_eleccion', 'Var2', 'Var1',
          'Sum_votos_par', 'election', 'unit', 'sum_partidos', 'votes', 'votes_nac'
          )

if(getRversion() >= "2.15.1"){
    utils::globalVariables(c('.', vars))
    utils::suppressForeignCheck(c('.', vars))
}




sigla <- function(dat){

    p <- partidos_uy
    p[nrow(p) + 1, c(1:2)] <- c('Voto en Blanco', 'VB')
    p[nrow(p) + 1, c(1:2)] <- c('Voto Anulado', 'VA')
    u <- which(names(dat) == 'Partido')
    left_join(dat, p[, 1:2], by = 'Partido') %>%
        select(1:u, Sigla, (u+1):ncol(.))

}


ap <- function(datos, umbral = 2){
    datos1 <- datos %>%
        summarise(Votos = sum(Votos), Porcentaje = sum(Porcentaje)) %>%
        rename(Partido = corte) %>%
        left_join(., partidos_uy[,c("Partido","Sigla")], by = 'Partido')
    datos1
}



header <- function(base){

    total <- sum(base == "X")
    parcial <- apply(base, 2, function(x){sum(x == 'X', na.rm = TRUE)})
    porcen <- paste0(" (", round(parcial/total*100), "%)")

    cat("\n\n--- Cantidad de elecciones ------------------------------------\n\n")
    cat(crayon::green$bold("-->"), " Presidencial                       :", crayon::blue$bold(parcial[1], porcen[1]),"\n")
    cat(crayon::green$bold("-->"), " Balotaje                           :", crayon::blue$bold(parcial[2], " ",  porcen[2]) ,"\n")
    cat(crayon::green$bold("-->"), " Departamental                      :", crayon::blue$bold(parcial[3], porcen[3]) ,"\n")
    cat(crayon::green$bold("-->"), " Legislativa                        :", crayon::blue$bold(parcial[4], porcen[4]) ,"\n")
    cat(crayon::green$bold("-->"), " Consejo Nacional de Administracion :", crayon::blue$bold(parcial[5], " ", porcen[5]) ,"\n\n")
    cat("---------------------------------------------------------------\n\n")
}



init_summ <- function(){
    j <- elecciones_uy %>% select(anio_eleccion, eleccion) %>% distinct()
    table(j$anio_eleccion, j$eleccion) %>% as.data.frame()

}


pre_out <- function(datos, eleccion, vbva.rm) {

    d <- datos %>%  dplyr::filter(anio_eleccion == {{eleccion}})
    if(vbva.rm){
        ubic <- which(d$partido %in% c('Voto en Blanco', 'Voto Anulado'))
        d <- d[-ubic, ]
    }
    d %>%
        group_by(departamento, partido, fecha) %>%
        summarise(
            cant_votos = sum(votos, na.rm = TRUE),
            Diputados = sum(bancas_diputados, na.rm = TRUE),
            Senadores = sum(bancas_senado, na.rm = TRUE)/length(unique(departamento))
        ) %>%
        ungroup() %>%
        group_by(departamento) %>%
        mutate (por_deptos = round((cant_votos / sum(cant_votos, na.rm = TRUE)) * 100, 2)) %>%
        ungroup() %>%
        mutate(total = sum(cant_votos, na.rm = TRUE)) %>%
        group_by(partido) %>%
        mutate(
            por_nacional = round((sum(cant_votos, na.rm = TRUE) / total) * 100, 2),
            sum_diputados = sum(Diputados, na.rm = TRUE),
            sum_senadores = sum(Senadores, na.rm = TRUE)/length(unique(departamento)),
            sum_votos_par = sum(cant_votos, na.rm = TRUE),
            fecha = as.Date(fecha)
        ) %>%
        ungroup() %>%
        select(-c(total))
}



concurrente <- function(eleccion, tipo){

    elecciones_uy %>%
        filter(eleccion == {{tipo}}, anio_eleccion == {{eleccion}}) %>%
        select(concurrente) %>%
        unique() %>%
        deframe()
}














