print("Loading the mapping files...")

# SOURCE AUTHORITY - SPECIES
MAPPING_SOURCE_AUTHORITY_SPECIES = fread("../inputs/mappings/codelist_mapping_source_authority_species.csv")

## GTA SPECIES GROUPS MAPPING ####
MAPPING_SP_SPG = fread("../inputs/mappings/codelist_mapping_species_asfis_speciesgroup_tunaatlas.csv")

# Add species group label
MAPPING_SP_SPG = merge(MAPPING_SP_SPG, SPECIES_GROUP[, .(code, species_group_label = label)], by.x = "trg_code", by.y = "code")

print("Mapping files loaded!")