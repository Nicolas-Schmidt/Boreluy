
#' @importFrom dplyr filter select group_by mutate if_else full_join arrange summarise right_join ungroup distinct summarize
#' @importFrom tidyr pivot_wider
#' @importFrom tibble as_tibble
#' @importFrom stats na.omit
#' @importFrom magrittr %>%


if(getRversion() >= "2.15.1"){
    utils::globalVariables(c('.'))
    utils::suppressForeignCheck(c('.'))
}


vbva <- function(vec){
    ubic <- which(vec$Partido %in% c('Voto en Blanco', 'Voto Anulado'))
    if(any(ubic)) vec$Sigla[ubic] <- c('VB', 'VA')
    return(vec)
}


sigla <- function(dat, anio){
    names(dat) <- tools::toTitleCase(names(dat))
    cbind(Eleccion = anio, vbva(right_join(partidos_uy[, -3], dat, by = 'Partido'))) %>% as_tibble()
}








