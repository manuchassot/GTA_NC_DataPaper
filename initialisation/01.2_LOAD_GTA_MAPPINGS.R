print("Loading the mapping files...")

# SOURCE AUTHORITY - SPECIES
MAPPING_SOURCE_AUTHORITY_SPECIES = fread("../inputs/mappings/codelist_mapping_source_authority_species.csv")

# FISHING FLEET - COUNTRY
MAPPING_FLEET_COUNTRY = fread("../inputs/mappings/codelist_mapping_fishingfleet_firms_flag_fao_cwp.csv")

# Add country label
MAPPING_FLEET_COUNTRY = merge(MAPPING_FLEET_COUNTRY[, .(fleet_code = src_code, country_code = trg_code)], COUNTRIES[, .(code, country = label)], by.x = "country_code", by.y = "code", all.x = TRUE)

## GTA SPECIES GROUPS MAPPING ####
MAPPING_SP_SPG = fread("../inputs/mappings/codelist_mapping_species_asfis_speciesgroup_tunaatlas.csv")

# Add species group label
MAPPING_SP_SPG = merge(MAPPING_SP_SPG, SPECIES_GROUP[, .(code, species_group_label = label)], by.x = "trg_code", by.y = "code")

print("Mapping files loaded!")