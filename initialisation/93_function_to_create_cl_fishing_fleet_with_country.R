# Read code lists
cl_fishing_fleet <- read_csv("../inputs/codelists/cl_fishing_fleet.csv", )

cl_territory_to_country <- read_csv("../inputs/codelists/cl_territory_to_country.csv")

cl_fishing_fleet_with_country <- full_join(cl_fishing_fleet, cl_territory_to_country, by = c("label" = "territory"))

cl_fishing_fleet_with_country$country <- ifelse(is.na(cl_fishing_fleet_with_country$country), cl_fishing_fleet_with_country$label, cl_fishing_fleet_with_country$country)
cl_fishing_fleet_with_country$country <- ifelse(cl_fishing_fleet_with_country$country == "NA", NA, cl_fishing_fleet_with_country$country)
cl_fishing_fleet_with_country$country <- gsub("\\([^\\)]+\\)", "", cl_fishing_fleet_with_country$country)

cl_fishing_fleet_with_country$tocheck <- ifelse(cl_fishing_fleet_with_country$country != cl_fishing_fleet_with_country$label && !is.na(cl_fishing_fleet_with_country$country), "Yes", "No")

write.csv(cl_fishing_fleet_with_country, "../inputs/codelists/cl_fishing_fleet_with_country.csv", row.names = FALSE, fileEncoding = "utf8")
