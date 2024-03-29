
#' @importFrom dplyr filter select group_by rename mutate if_else full_join left_join arrange summarise right_join ungroup distinct summarize bind_cols
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

ap <- function(datos, umbral = 2, departamental){

    if(departamental){
        datos1 <- datos %>%
            summarise(Votos      = sum(Votos),
                      Porcentaje = sum(Porcentaje)) %>%
            rename(Partido = corte) %>%
            left_join(., partidos_uy[,c("Partido","Sigla")], by = 'Partido')
    } else {

        datos1 <- datos %>%
            summarise(Votos      = sum(Votos),
                      Porcentaje = sum(Porcentaje),
                      Diputados  = sum(Diputados),
                      Senadores  = sum(Senadores)) %>%
            rename(Partido = corte) %>%
            left_join(., partidos_uy[,c("Partido","Sigla")], by = 'Partido')
    }
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

#init_summ <- function(){
#    j <- elecciones_uy %>% select(anio_eleccion, eleccion) %>% distinct()
#    table(j$anio_eleccion, j$eleccion) %>% as.data.frame()
#}

init_summ <- function(){

    j <- elecciones_uy %>% select(anio_eleccion, eleccion, concurrente) %>% distinct()
    j <- rbind(j[, -3], data.frame(anio_eleccion = j[which(j$concurrente == 1), "anio_eleccion"], eleccion = "Legislativa"))
    table(j$anio_eleccion, j$eleccion) %>% as.data.frame()
}


pre_out <- function(datos, eleccion, vbva.rm) {

    d <- datos %>%  dplyr::filter(anio_eleccion == {{eleccion}})
    if(vbva.rm){
        ubic <- which(d$partido %in% c('Voto en Blanco', 'Voto Anulado'))
        d <- d[-ubic, ]
    }
    if(eleccion %in% c(1922, 1925)){
        if(eleccion == 1922){
            u <- which(d$organo == "Camara de Senadores")
            d[u, "fecha"] <- as.Date("1922-11-26")
            #d$eleccion <- ifelse(d$organo == "Camara de Senadores", "Legislativa: CSS", "Legislativa: CRR")
            }
        d %>% split(., .$fecha) %>% lapply(., pooled) %>% do.call("rbind", .)
    }else{
            pooled(d)
        }
}

elecR <- as.character(c(1922, 1925, 1926, 1928, 1930, 1932))

pooled <- function(d){

    d %>%
        group_by(departamento, partido, fecha) %>%
        summarise(
            cant_votos = sum(votos, na.rm = TRUE),
            Diputados = sum(bancas_diputados, na.rm = TRUE),
            ## step 1e
            Senadores = ifelse(substring(fecha[1], 1, 4) %in% elecR, sum(bancas_senado, na.rm = TRUE), sum(bancas_senado, na.rm = TRUE)/length(unique(departamento)))
        ) %>%
        ungroup() %>%
        group_by(departamento) %>%
        mutate (por_deptos = round((cant_votos / sum(cant_votos, na.rm = TRUE)) * 100, 2)) %>%
        ungroup() %>%
        mutate(total = sum(cant_votos, na.rm = TRUE)) %>%
        group_by(partido) %>%
        mutate(
            por_nacional =  (sum(cant_votos, na.rm = TRUE) / total) * 100,
            sum_diputados = sum(Diputados, na.rm = TRUE),
            ## step 2e
            sum_senadores = ifelse(substring(fecha[1], 1, 4) %in% elecR, sum(Senadores, na.rm = TRUE), sum(Senadores, na.rm = TRUE)/length(unique(departamento))),
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

e1962_66 <- function(x){

    x[x$election == 1962 & x$party == "Partido Democrata Cristiano"   ,"party"] <- "Union Civica"
    x[x$election == 1962 & x$party == "Frente Izquierda de Liberacion","party"] <- "Partido Comunista del Uruguay"
    x[x$election == 1962 & x$party == "Union Popular"                 ,"party"] <- "Partido Socialista"

    x[x$election == 1966 & x$party == "Partido Democrata Cristiano"   ,"party"] <- "Union Civica"
    x[x$election == 1966 & x$party == "Frente Izquierda de Liberacion","party"] <- "Partido Comunista del Uruguay"
    #x[x$election == 1966 & x$party == "Union Popular"                 ,"party"] <- "Partido Socialista"
    return(x)
}

zero <- function(.X){.X[.X$Votos != 0,]}

#' @title departamentos
#' @description contiene los nombres de los 19 departamentos de Uruguay
#' @export

departamentos <- c(
    "Artigas",
    "Canelones",
    "Cerro Largo",
    "Colonia",
    "Durazno",
    "Flores",
    "Florida",
    "Lavalleja",
    "Maldonado",
    "Montevideo",
    "Paysandu",
    "Rio Negro",
    "Rivera",
    "Rocha",
    "Salto",
    "San Jose",
    "Soriano",
    "Tacuarembo",
    "Treinta y Tres"
)








