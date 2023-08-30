print("Loading the code list and mapping files...")

# CODE LISTS ####

## ASFIS species ####
SPECIES = fread(here("inputs/codelists/cl_asfis_species.csv"))

# LEVEL 0 species
SPECIES_LEVEL0 = fread(here("inputs/codelists/cl_species_level0.csv"))

# ITIS taxonomic information
SPECIES_ITIS = fread(here("inputs/codelists/cl_itis_species.csv"))

# SOURCE AUTHORITY - SPECIES
SOURCE_AUTHORITY_SPECIES = fread(here("inputs/mappings/codelist_mapping_source_authority_species.csv"))

# GTA species groups
SPECIES_GROUP = fread(here("inputs/codelists/cl_speciesgroup.csv"))

## ISSCGF gears ####
GEARS = fread(here("inputs/codelists/cl_isscfg_gear.csv"), colClasses = "character", encoding = "UTF-8")

## FIRMS fleets ####
FLEETS = fread(here("inputs/codelists/cl_fishing_fleet.csv"), encoding = "UTF-8")

## GTA SPECIES GROUPS MAPPING ####
MAPPING_SP_SPG = fread(here("inputs/mappings/codelist_mapping_species_asfis_speciesgroup_tunaatlas.csv"))

# Add species group label
MAPPING_SP_SPG = merge(MAPPING_SP_SPG, SPECIES_GROUP[, .(code, species_group_label = label)], by.x = "trg_code", by.y = "code")

print("Code list and mapping files loaded!")