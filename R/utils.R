
#' @importFrom dplyr filter select group_by mutate if_else full_join left_join arrange summarise right_join ungroup distinct summarize
#' @importFrom tidyr pivot_wider
#' @importFrom tibble as_tibble tibble
#' @importFrom stats na.omit
#' @importFrom purrr map
#' @importFrom magrittr %>%


vars <- c('elecciones_uy', 'eleccion', 'concurrente', 'anio_eleccion', 'partido',
          'departamento', 'camara', 'bancas', 'Bancas', 'Senadores', 'Diputados',
          'votos', 'Votos', 'total', 'Porcentaje', 'partidos_uy', 'corte')

if(getRversion() >= "2.15.1"){
    utils::globalVariables(c('.', vars))
    utils::suppressForeignCheck(c('.', vars))
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


ap <- function(datos, umbral = 2){

    datos$corte <- ifelse(datos$Porcentaje < umbral, 'Otros Partidos', datos$Partido)
    datos$corte <- ifelse(datos$Partido %in% c('Voto Anulado', 'Voto en Blanco'), 'Voto Blanco/Anulado', datos$corte)
    datos1 <- datos %>%
        group_by(corte) %>%
        summarise(Porcentaje = sum(Porcentaje), Votos = sum(Votos))

    out <- tibble(
        Eleccion   = unique(datos$Eleccion),
        Partido    = datos1$corte,
        Votos      = datos1$Votos,
        Porcentaje = datos1$Porcentaje
    ) %>% arrange(-Porcentaje) %>% left_join(., partidos_uy[-3], by = 'Partido')

    out$Sigla <- ifelse(out$Partido == 'Voto Blanco/Anulado', 'VB/VA',
                        ifelse(out$Partido == 'Otros Partidos', 'OtrosP.', out$Sigla))

    out
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

