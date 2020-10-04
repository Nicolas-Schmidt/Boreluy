#' @title elecciones
#' @description Permite checar las elecciones disponibles en la base de datos \code{elecciones_uy}.
#' @param tipo tip de eleccion
#' @examples
#' elecciones(tipo = "Presidencial")
#' @export

elecciones <- function(tipo = character()){
    elecciones_uy %>% filter(eleccion == {{tipo}}) %>% select(anio_eleccion) %>% distinct() %>% deframe()
}
