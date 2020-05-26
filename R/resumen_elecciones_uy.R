#' @title resumen elecciones uy
#' @description Resumen de la cantidad de elecciones por organo y por anio.
#' @param tabla Por defecto es  \code{TRUE}. Devuelve una tabla resumen por anio.
#' @return Si tabla es \code{TRUE} devuelve un data.frame, si es  \code{FALSE} imprime un resumen.
#' @examples
#' resumen_elecciones_uy()
#' @export

resumen_elecciones_uy <- function(tabla = TRUE) {

    j2 <- init_summ() %>% pivot_wider(names_from = 'Var2', values_from = 'Freq')
    names(j2)[which(names(j2) == 'Consejo Nacional de Administracion')] <- 'CNA'
    j2 <- j2[, c('Var1', 'Presidencial', 'Balotaje','Departamental', 'Legislativa', 'CNA')]
    j3 <- cbind(j2[1], ifelse(j2[-1] == 0, " ", "X"))
    rownames(j3) <- j3[,1]
    names(j3) <- paste0(" ", names(j3))
    j3 <- j3[,-1]
    header(j3)
    if(tabla){return(j3)}
}



#' @title grafico elecciones uy
#' @description Resumen de la cantidad de elecciones por organo y por anio de forma grafica.
#' @export

grafico_elecciones_uy <- function(){

    init_summ() %>%
        mutate(Var2 = ifelse(as.character(Var2) == 'Consejo Nacional de Administracion', 'CNA',
                             as.character(Var2)),
               Var1 = as.numeric(as.character(Var1)),
               Freq = ifelse(Freq == 1, "Si", "No")) %>%
        ggplot(aes(factor(Var1), Var2, fill= factor(Freq))) +
        geom_tile(color = "white") +
        scale_fill_manual(values = c('#6CD2F7','#FEF732')) +
        theme_minimal() +
        #hrbrthemes::theme_ipsum_tw() +
        theme(axis.text.x = element_text(angle = 90), legend.position = "top") +
        labs(x = "", y = "", fill = "")
}


























