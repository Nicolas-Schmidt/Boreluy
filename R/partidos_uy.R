#'partidos_uy
#'
#'Contiene el nombre y el anio de fundacion de todos los partidos politicos
#'uruguayos desde 1918 hasta 2020 que partidiparon en alguna instancia electoral
#'en el periodo citado.
#'
#'\describe{
#'    \item{Partido}{Nombre completo del partido politicao que participo en alguna eleccion nacional o departamental.}
#'    \item{Sigla}{Sigla del Partido Politico.}
#'    \item{Fundacion}{Anio de fundacion del partido.}
#'    \item{primer_eleccion}{Anio de la primer eleccion en el periodo (1918-2020) en la que participa el partido politico.}
#'    \item{alcance}{Esta variable puede asumir dos valores: 'Departametal' o 'Nacional'. Refiere al alcance que tiene el partido. Es una variable que permite distinguir partidos departamentales o locales de nacionales}
#'    \item{elecciones}{Vector de anios en los que participo de elecciones el partido politico}
#'
#' }
#' @docType data
#' @keywords datasets
#' @name partidos_uy
#' @usage data(partidos_uy)
#' @format data.frame con 112 filas y 6 columnas
'partidos_uy'
