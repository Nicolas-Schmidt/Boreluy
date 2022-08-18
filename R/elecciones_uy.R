#'elecciones_uy
#'
#'Contiene el resultado de un conjunto de elecciones de nivel nacional de Uruaguat entre 1918 y 2020.
#'
#'\describe{
#'    \item{anio_eleccion}{Anio en el que se realizo la eleccion.}
#'    \item{fecha}{Fecha en la que se realizo la eleccion.}
#'    \item{eleccion}{Tipo de eleccion. Puede ser 'Presidencial', 'Departamental', 'Balotaje', 'Legislativa' o 'Consejo Nacional de Administracion'}
#'    \item{concurrente}{Elecciones concurrentes. Si hay elecciones concurrentes la variable asume el valor 1, en caso contrario asume el vaor de 0. La concurrencia en este caso solo refiere a elecciones Presidenciales y Legislativas.}
#'    \item{parcial}{Elecciones parciales. El parlamento en la decada de los anios 20 se cambiaba por tercios. Si la variable asume el valor de 1 es que es una eleccion parcial en caso contrario asume el valor de 0.}
#'    \item{organo}{Nombre del organo electivo.}
#'    \item{cargos}{Cantidad principal de cargos que se eligen en cada eleccion.}
#'    \item{partido}{Nombre del partido politico.}
#'    \item{departamento}{Nombre del departamento.}
#'    \item{fraccion}{Nombre de la fraccion del partido politico.}
#'    \item{sublema_senado}{Nombre del sublema al senado.}
#'    \item{cabeza_senado}{Nombre de la persona que encabeza la lista al senado.}
#'    \item{votos}{Cantidad de votos.}
#'    \item{bancas_diputados}{Cantidad de bancas a la Camara de Representantes obtenidas por cada partido politico.}
#'    \item{bancas_senado}{Cantidad de bancas a la Camara de Senadores obtenidas por cada partido politico.}
#'    \item{total_bancas_diputados}{Total de bancas que tiene la Camara de Representantes.}
#'    \item{total_bancas_senado}{Total de bancas que tiene la Camara de Senadores.}
#'    \item{habilitados}{Cantidad de ciudadanos habilitados para votar.}
#'    \item{poblacion}{Cantidad de poblacion (no está discriminada por lo mayores de edad que son los que pueden ejercer el derecho al voto dentro de otras condiciones).}
#'    \item{formula_presidente}{Candidato a la presidncia si es eleccion Presidencial o a Intendente si es eleccion Departamental}
#'    \item{formula_vice}{Candidato a la vicepresidencia en el caso de elecciones Presidenciales.}
#'    \item{partido_ganador}{Partido politico ganador de la eleccion.}
#'    \item{presidente}{Presidente electo en el caso de elecciones Presidenciales o Intendente en el caso de elecciones Departamentales.}
#'    \item{vice}{Vicepresidente electo en el caso de elecciones Presidenciales.}
#' }
#' @docType data
#' @keywords datasets
#' @name elecciones_uy
#' @usage data(elecciones_uy)
#' @format data.frame con 18332 filas y 24 columnas.
#' @details La unidad de analisis de esta base de datos es la fraccion a nivel departamental. Esto hace que se tenga el resultado electoral estructurado por cada fraccion de cada partido en cada departamento.
#'
#' @references
#' \insertRef{fabregat1946}{Boreluy}
#'
#' \insertRef{fabregat1950}{Boreluy}
#'
#' \insertRef{fabregat1958}{Boreluy}
#'
#' \insertRef{fabregat1962}{Boreluy}
#'
#' \insertRef{fabregat1966}{Boreluy}
#'
#' \insertRef{fabregat1971}{Boreluy}
#'
#' \insertRef{albornoz1984}{Boreluy}
#'
#' \insertRef{albornoz1989}{Boreluy}
#'
#' \insertRef{marius1999}{Boreluy}
#'
#' \insertRef{marius2004}{Boreluy}
NULL





