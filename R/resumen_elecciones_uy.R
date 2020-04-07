#' @title resumen elecciones uy
#' @description Resumen de la cantidad de elecciones por organo y por anio.
#' @return data.frame
#' @examples
#' resumen_elecciones_uy()
#' @export

resumen_elecciones_uy <- function() {

    j <- elecciones_uy %>% select(anio_eleccion, eleccion) %>% distinct()
    j2 <- table(j$anio_eleccion, j$eleccion) %>%
            as.data.frame() %>%
            pivot_wider(names_from = 'Var2', values_from = 'Freq')
    names(j2)[which(names(j2) == 'Consejo Nacional de Administracion')] <- 'CNA'
    j2 <- j2[, c('Var1', 'Presidencial', 'Balotaje','Departamental', 'Legislativa', 'CNA')]
    j3 <- cbind(j2[1], ifelse(j2[-1] == 0, " ", "X"))
    rownames(j3) <- j3[,1]
    names(j3) <- paste0(" ", names(j3))
    j3 <- j3[,-1]
    header(j3)
    print(j3)
    cat(paste0("\n", paste(rep("-", 63), collapse = ""), "\n\n"))

}
