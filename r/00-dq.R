# packages
require('validate')
require('readr')
require('tidyverse')

# parameters:
today <- Sys.Date()

# read in the data
somministrazioni <-
  read_csv(file = "./dati/somministrazioni-vaccini-latest.csv", trim_ws = F)
somministrazioni_summary <-
  read_csv(
    file = "./dati/somministrazioni-vaccini-summary-latest.csv",
    col_types = cols(
      data_somministrazione = col_date(format = "%Y-%m-%d"),
      area = col_character(),
      totale = col_double(),
      sesso_maschile = col_double(),
      sesso_femminile = col_double(),
      categoria_operatori_sanitari_sociosanitari = col_double(),
      categoria_personale_non_sanitario = col_double(),
      categoria_ospiti_rsa = col_double()
    )
  )

consegne <- read_csv(file = "./dati/consegne-vaccini-latest.csv")

checker <- function(dataset) {
  ruleset_path <-  paste0("./r/rules/", dataset, ".yaml")
  ruleset <- validator(.file = ruleset_path)
  results <- confront(eval(as.name(dataset)), ruleset)


  failures <- filter(summary(results), fails > 0) %>%
    mutate(date = as.Date(today)) %>% 
    select(date, name)

  return(failures)
}
checker("somministrazioni")
