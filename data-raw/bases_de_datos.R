

## -----------------------------------------------------------------------------
## elecciones_uy
## -----------------------------------------------------------------------------
#elecciones_uy <- rio::import(here::here('data-raw', 'elecciones_uy.xlsx'))
library(readxl)
elecciones_uy <- read_excel("data-raw/elecciones_uy.xlsx",
                              col_types = c("numeric", "date", "text",
                                            "numeric", "numeric", "text",
                                            "numeric", "text", "text",
                                            "text", "text", "text",
                                            "numeric", "numeric", "numeric",
                                            "numeric", "numeric", "numeric",
                                            "numeric", "text", "text", "text",
                                            "text", "text"))

rio::export(elecciones_uy, 'elecciones_uy.rda')
load('elecciones_uy.rda')
elecciones_uy <- elecciones_uy
save(elecciones_uy, file = here::here("data", "elecciones_uy.rda"))
file.remove('elecciones_uy.rda')

## -----------------------------------------------------------------------------
## partidos_uy
## -----------------------------------------------------------------------------

library(tidyverse)

elecciones_uy <- rio::import(here::here('data-raw', 'elecciones_uy.xlsx'))
party <- sort(unique(elecciones_uy$partido))
party2 <- data.frame(Partido = party, stringsAsFactors = FALSE)
partidos_uy <- rio::import(here::here('data-raw', 'partidos_uy.xlsx'))

all_party <- dplyr::full_join(party2, partidos_uy, by = 'Partido')
all_party <- all_party[-which(all_party$Partido %in% c("Voto Anulado", "Voto en Blanco" )), ]

vars <- elecciones_uy %>%
    select(anio_eleccion, eleccion, partido) %>%
    distinct() %>%
    group_by(partido) %>%
    summarise(primer_eleccion = min(anio_eleccion),
              alcance = ifelse(paste(unique(eleccion), collapse = " - ") == 'Departamental', 'Departamental', 'Nacional'),
              elecciones = paste(unique(anio_eleccion), collapse = " - ")
              )

names(vars)[1] <- 'Partido'
partidos_uy <- tibble::as_tibble(dplyr::left_join(all_party[1:3], vars, by = ))

rio::export(partidos_uy, here::here('data-raw', 'partidos_uy.xlsx'))
partidos_uy <- rio::import(here::here('data-raw', 'partidos_uy.xlsx'))


rio::export(partidos_uy, 'partidos_uy.rda')
load('partidos_uy.rda')
partidos_uy <- partidos_uy
save(partidos_uy, file = here::here("data", "partidos_uy.rda"))
file.remove("partidos_uy.rda")

## -----------------------------------------------------------------------------




