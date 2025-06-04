library(readr)
cl_territory_to_country <- read_delim(here("inputs/codelists/cl_territory_to_country.csv"), 
                                      delim = "\t", escape_double = FALSE, 
                                      trim_ws = TRUE)

cl_fishing_fleet <- read_csv(here("inputs/codelists/cl_fishing_fleet.csv"))

cl_fishing_fleet_with_country <- full_join(cl_fishing_fleet, cl_territory_to_country, by = c("label" = "territory"))

cl_fishing_fleet_with_country$country <- ifelse(is.na(cl_fishing_fleet_with_country$country), cl_fishing_fleet_with_country$label, cl_fishing_fleet_with_country$country)
cl_fishing_fleet_with_country$country <- ifelse(cl_fishing_fleet_with_country$country == "NA", NA, cl_fishing_fleet_with_country$country)
cl_fishing_fleet_with_country$country <- gsub("\\([^\\)]+\\)", "", cl_fishing_fleet_with_country$country) # toremove what is inside parethesis

cl_fishing_fleet_with_country$tocheck <- ifelse(cl_fishing_fleet_with_country$country != cl_fishing_fleet_with_country$label & !is.na(cl_fishing_fleet_with_country$country), "Yes", "No")

fwrite(cl_fishing_fleet_with_country, here("inputs/codelists/cl_fishing_fleet_with_country.csv"))













# territory to country COUNTRIES_SF

COUNTRIES_SF_without_geom <- sf::st_drop_geometry(COUNTRIES_SF %>% dplyr::select(-geom))
country_to_territ_codes <- COUNTRIES_SF_without_geom %>% filter(ISO3CD != ISO_3) %>% 
  dplyr::select(country_code = ISO_3, territory_code = ISO3CD)
