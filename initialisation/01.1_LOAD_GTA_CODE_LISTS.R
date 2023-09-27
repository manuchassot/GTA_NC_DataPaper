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

## GTA gear groups
GEAR_GROUPS = fread("../inputs/codelists/cl_geargroup.csv", colClasses = "character", encoding = "UTF-8")[, .(code, label)]

# Temp update of labels
GEAR_GROUPS[code == "BB", label := "Handlines and pole and lines"]
GEAR_GROUPS[code == "PS", label := "Surrounding nets"]
GEAR_GROUPS[code == "LL", label := "Longlines"]

## FIRMS fleets ####
FLEETS = fread("../inputs/codelists/cl_fishing_fleet.csv", encoding = "UTF-8")

## FAO countries ####
# IOTC version: https://data.iotc.org/reference/latest/domain/admin/#countries
#COUNTRIES = data.table(read.xlsx("../inputs/codelists/cl_countries.xlsx"))
COUNTRIES = fread("../inputs/codelists/cl_flagstate_iso3.csv")

print("Code list files loaded!")