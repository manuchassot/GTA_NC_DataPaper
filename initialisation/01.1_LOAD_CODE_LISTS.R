print("Loading the code list files...")

# CODE LISTS ####

## ASFIS species ####
SPECIES = fread("../inputs/codelists/cl_asfis_species.csv")

# LEVEL 0 species
SPECIES_LEVEL0 = fread("../inputs/codelists/cl_species_level0.csv")

# ITIS taxonomic information
SPECIES_ITIS = fread("../inputs/codelists/cl_itis_species.csv")

# GTA species groups
SPECIES_GROUP = fread("../inputs/codelists/cl_speciesgroup.csv")

## ISSCGF gears ####
GEARS = fread("../inputs/codelists/cl_isscfg_gear.csv", colClasses = "character", encoding = "UTF-8")

## FIRMS fleets ####
FLEETS = fread("../inputs/codelists/cl_fishing_fleet.csv", encoding = "UTF-8")

print("Code list files loaded!")