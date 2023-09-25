print("Reading tRFMO nominal catches...")

# Nominal catches ####
unzip("../inputs/data/GTA/global_nominal_catch_firms_public.zip", exdir = "../inputs/data/GTA/")

NC_RAW = fread("../inputs/data/GTA/global_nominal_catch_firms_public20230918.csv", colClasses = c(gear_type = "character"))

# Append taxonomic information
NC = merge(NC_RAW, SPECIES_ITIS[, .(species_group_gta = `Species group`, species_code_asfis = `ASFIS code`, taxon = `Scientific name`, species_aggregate = Aggregate, tsn = TSN)], by.x = "species", by.y = "species_code_asfis", all.x = TRUE)

# Append species English name
NC = merge(NC, SPECIES_LEVEL0[, .(code, species_name = name_en)], by.x = "species", by.y = "code", all.x = TRUE)

# Append gear information
NC = merge(NC, GEARS[, .(code, gear_label = label)], by.x = "gear_type", by.y = "code", all.x = TRUE)

# Append fleet labels
NC = merge(NC, FLEETS[, .(code, fleet_label = label)], by.x = "fishing_fleet", by.y = "code", all.x = TRUE)

# Append countries
NC = merge(NC, MAPPING_FLEET_COUNTRY, by.x = "fishing_fleet", by.y = "fleet_code", all.x = TRUE)

# Add year
NC[, year := year(time_start)]

# Create ocean basin from areas
NC[geographic_identifier %in% c("Atlantic", "ATW", "A+M", "ATL", "ATE", "ATS", "MED", "ASW", "ASE", "ATN", "AT", "ANW","ANE"), ocean_basin := "Atlantic Ocean"]
NC[geographic_identifier %in% c("F51", "IOTC_WEST", "IOTC_EAST", "IOTC"), ocean_basin  := "Indian Ocean"]
NC[geographic_identifier %in% c("WCPO", "WCPFC"), ocean_basin := "Western-Central Pacific Ocean"]
NC[geographic_identifier == "EPO", ocean_basin := "Eastern Pacific Ocean"]

print("tRFMO nominal catches read!")

# temp data exports for manu
# NC_GTA_TROP_PS_YEAR_SPECIES_OCEAN = NC[gear_label %in% ("Purse seines") & species %in% c("BET", "SKJ", "YFT") & year(time_start)>1949, .(GEAR_GROUP = "PS", CATCH = round(sum(measurement_value))), keyby = .(YEAR = year, OCEAN = ocean_basin, SPECIES_CODE = species)]
# write.csv(NC_GTA_TROP_PS_YEAR_SPECIES_OCEAN, "../outputs/NC_GTA_TROP_PS_YEAR_SPECIES_OCEAN.csv", row.names = FALSE)
