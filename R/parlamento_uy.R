#' @title Composicion del parlamento
#' @description Devuelve la integracin del parlameto (camara baja y camara alta)
#'     en cantidad de bancas por partido y por departamento.
#' @param anio Anio de eleccion
#' @param por_departamento Por defecto es \code{FALSE}. Si es \code{TRUE} devuelve
#'     el resultado por departamento, como la camara alta es de circunscrupcion nacional
#'     el resultado va a ser contsnte en todos los departamemtos.
#' @return data.frame.
#' @examples
#' parlamento_uy(1971, FALSE)
#' @export


parlamento_uy <- function(anio = 1971,
                       por_departamento = FALSE){

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
        #names(a) <- tools::toTitleCase(names(a))
    }else{
        a <- b2[,c('partido', 'Diputados', 'Senadores')]
        #names(a) <- tools::toTitleCase(names(a))
        #b2
    }
    salida <- arrange(sigla(dat = a, anio = anio), -Senadores)
    class(salida) <- c(class(salida), 'boreluy_parlamento')

    return(salida)
}









