print("Loading the mapping files...")

# SOURCE AUTHORITY - SPECIES
MAPPING_SOURCE_AUTHORITY_SPECIES = fread("../inputs/mappings/codelist_mapping_source_authority_species.csv")

# FISHING FLEET - COUNTRY
# No countries for 
MAPPING_FLEET_COUNTRY = data.table(read.xlsx("../inputs/mappings/codelist_mapping_fishing_fleet_country.xlsx"))

# Add country label
#MAPPING_FLEET_COUNTRY = merge(MAPPING_FLEET_COUNTRY, COUNTRIES[, .(CODE_ISO3, FULL_NAME_EN, SHORT_NAME_EN, NOCS_CATEGORY)], by.x = "country_code", by.y = "CODE_ISO3", all.x = TRUE)
MAPPING_FLEET_COUNTRY = merge(MAPPING_FLEET_COUNTRY, COUNTRIES[!is.na(code), .(code, label)], by.x = "country_code", by.y = "code", all.x = TRUE)

## GTA SPECIES GROUPS MAPPING ####
MAPPING_SP_SPG = fread("../inputs/mappings/codelist_mapping_species_asfis_speciesgroup_tunaatlas.csv")

# Add species group label
MAPPING_SP_SPG = merge(MAPPING_SP_SPG, SPECIES_GROUP[, .(code, species_group_label = label)], by.x = "trg_code", by.y = "code")

print("Mapping files loaded!")