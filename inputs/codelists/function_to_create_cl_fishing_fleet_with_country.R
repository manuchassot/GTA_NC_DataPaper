library(readr)
cl_territory_to_country <- read_delim("~/Documents/GTA_NC_DataPaper/inputs/codelists/cl_territory_to_country.csv", 
                                      delim = "\t", escape_double = FALSE, 
                                      trim_ws = TRUE)

cl_fishing_fleet_with_country <- full_join(cl_fishing_fleet, cl_territory_to_country, by = c("label" = "territory"))

cl_fishing_fleet_with_country$country <- ifelse(is.na(cl_fishing_fleet_with_country$country), cl_fishing_fleet_with_country$label, cl_fishing_fleet_with_country$country)
cl_fishing_fleet_with_country$country <- ifelse(cl_fishing_fleet_with_country$country == "NA", NA, cl_fishing_fleet_with_country$country)
cl_fishing_fleet_with_country$country <- gsub("\\([^\\)]+\\)", "", cl_fishing_fleet_with_country$country)

cl_fishing_fleet_with_country$tocheck <- ifelse(cl_fishing_fleet_with_country$country != cl_fishing_fleet_with_country$label && !is.na(cl_fishing_fleet_with_country$country), "Yes", "No")

fwrite(cl_fishing_fleet_with_country, here("inputs/codelists/cl_fishing_fleet_with_country.csv"))
