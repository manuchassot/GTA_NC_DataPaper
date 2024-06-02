# Read the three datasets ####

## Folder with GTA data
wd = "C:/Users/echassot/OneDrive - Food and Agriculture Organization/IOTC/DATA/DataDissemination/TUNA_ATLAS/2024/data"

## global_catch_1deg_1m_surface_firms_level0 ####
CA_11_M_RAW = fread(paste0(wd, "/global_catch_1deg_1m_surface_firms_level0/data/global_catch_1deg_1m_surface_firms_level0_harmonized.csv"), colClasses = c("gear_type" = "character", "geographic_identifier" = "character"))

## global_catch_5deg_1m_firms_level0 ####
CA_55_M_RAW = fread(paste0(wd, "/global_catch_5deg_1m_firms_level0/data/global_catch_5deg_1m_firms_level0_harmonized.csv"), colClasses = c("gear_type" = "character", "geographic_identifier" = "character"))

## global_catch_firms_level0 ####
CA_ALL_M_RAW = fread(paste0(wd, "/global_catch_firms_level0/data/global_catch_firms_level0_harmonized.csv"), colClasses = c("gear_type" = "character", "geographic_identifier" = "character"))

## Consolidate the datasets ####

catch_consolidate = function(DataSet){

# Append taxonomic information
DataSet = merge(DataSet, SPECIES_ITIS[, .(species_group_gta = `Species group`, species_code_asfis = `ASFIS code`, taxon = `Scientific name`, species_aggregate = Aggregate, tsn = TSN)], by.x = "species", by.y = "species_code_asfis", all.x = TRUE)

# Append species English name
DataSet = merge(DataSet, SPECIES_LEVEL0[, .(code, species_name = name_en)], by.x = "species", by.y = "code", all.x = TRUE)

# Append gear information
DataSet = merge(DataSet, GEARS[, .(code, gear_label = label)], by.x = "gear_type", by.y = "code", all.x = TRUE)

# Append fleet labels
DataSet = merge(DataSet, FLEETS[, .(code, fleet_label = label)], by.x = "fishing_fleet", by.y = "code", all.x = TRUE)

# Append countries
DataSet = merge(DataSet, MAPPING_FLEET_COUNTRY, by.x = "fishing_fleet", by.y = "fleet_code", all.x = TRUE)

# Add year
DataSet[, year := year(time_start)]

return(DataSet)
}

CA_11_M = catch_consolidate(CA_11_M_RAW)
CA_55_M = catch_consolidate(CA_55_M_RAW)
CA_ALL_M = catch_consolidate(CA_ALL_M_RAW)
