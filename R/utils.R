
#' @importFrom dplyr filter select group_by mutate if_else full_join left_join arrange summarise right_join ungroup distinct summarize
#' @importFrom tidyr pivot_wider
#' @importFrom tibble as_tibble tibble
#' @importFrom stats na.omit
#' @importFrom purrr map
#' @importFrom magrittr %>%
#' @importFrom Rdpack reprompt


vars <- c('elecciones_uy', 'eleccion', 'concurrente', 'anio_eleccion', 'partido',
          'departamento', 'camara', 'bancas', 'Bancas', 'Senadores', 'Diputados',
          'votos', 'Votos', 'total', 'Porcentaje', 'partidos_uy', 'corte', 'Partido',
          'seats', 'Eleccion')

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
    cbind(Eleccion = anio, vbva(right_join(partidos_uy[, c(1, 2)], dat, by = 'Partido'))) %>% as_tibble()
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
    ) %>% arrange(-Porcentaje) %>% left_join(., partidos_uy[,c(1, 2)], by = 'Partido')

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


rpuy <- function(anio = integer(), por_departamento = FALSE){

    elec <- elecciones_uy %>%
        filter(eleccion %in% c('Legislativa', 'Presidencial'),
               concurrente == 1,
               anio_eleccion == anio) %>%
        select(c('anio_eleccion',
                 'eleccion',
                 'partido',
                 'fraccion',
                 'departamento',
                 'votos',
                 'bancas_senado',
                 'bancas_diputados',
                 'total_bancas_diputados',
                 'total_bancas_senado'))
    elec2 <- rbind(
        uno <- cbind(elec[, -c(7:10)], bancas = elec$bancas_diputados,
                     camara = 'Diputados',
                     integrantes = elec$total_bancas_diputados),
        dos <- cbind(elec[, -c(7:10)], bancas = elec$bancas_senado,
                     camara = 'Senadores',
                     integrantes = elec$total_bancas_senado)
    )
    a <- elec2 %>%
        group_by(partido, departamento, camara) %>%
        summarise(Bancas = sum(bancas)) %>%
        filter(Bancas != 0) %>%
        pivot_wider(names_from = camara, values_from = Bancas) %>%
        mutate(Senadores = if_else(is.na(Senadores), 0, Senadores)) %>%
        ungroup() %>%
        na.omit()

    b <- a %>%
        select(partido, Senadores) %>%
        distinct()
    b2 <- a %>%
        group_by(partido) %>%
        summarise(Diputados = sum(Diputados)) %>%
        full_join(b, by = 'partido') %>%
        arrange(-Diputados)


    if(por_departamento){
        a <- a[, c('partido', 'departamento', 'Diputados', 'Senadores')]
        names(a) <- tools::toTitleCase(names(a))
    }else{
        a <- b2[,c('partido', 'Diputados', 'Senadores')]
        names(a) <- tools::toTitleCase(names(a))
        #b2
    }

    return(a)
}
