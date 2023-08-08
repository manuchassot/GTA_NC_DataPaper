print("Downloading the code lists from the github repo...")

# CODE LISTS ####

## ASFIS species ####
if(!file.exists("../inputs/codelists/cl_asfis_species.csv")) 
  
download.file("https://raw.githubusercontent.com/fdiwg/fdi-codelists/main/global/cwp/cl_asfis_species.csv", destfile = "../inputs/codelists/cl_asfis_species.csv", mode = "wb")

## GTA species with ITIS taxonomic information
if(!file.exists("../inputs/codelists/cl_itis_species.csv"))

download.file("https://raw.githubusercontent.com/fdiwg/fdi-codelists/main/global/firms/gta/GTA_SPECIES_LIST_DRAFT.csv", destfile = "../inputs/codelists/cl_itis_species.csv")

## GTA species groups
if(!file.exists("../inputs/codelists/cl_speciesgroup.csv")) 
  
download.file("https://raw.githubusercontent.com/fdiwg/fdi-codelists/main/global/firms/gta/cl_speciesgroup.csv", destfile = "../inputs/codelists/cl_speciesgroup.csv", mode = "wb")

## ISSCFG gears ####
if(!file.exists("../inputs/codelists/cl_isscfg_gear.csv")) 
  
download.file("https://raw.githubusercontent.com/fdiwg/fdi-codelists/main/global/cwp/cl_isscfg_gear.csv", destfile = "../inputs/codelists/cl_isscfg_gear.csv", mode = "wb")

## FIRMS fleets ####
if (!file.exists("../inputs/codelists/cl_fishing_fleet.csv"))
  
download.file("https://raw.githubusercontent.com/fdiwg/fdi-codelists/main/global/firms/gta/cl_fishing_fleet.csv", destfile = "../inputs/codelists/cl_fishing_fleet.csv", mode = "wb")

# FILTERINGS ####

## Species filtering file ####
if(!file.exists("../inputs/codelists/cl_species_level0.csv"))
  
download.file("https://raw.githubusercontent.com/fdiwg/fdi-codelists/main/global/firms/gta/cl_species_level0.csv", destfile = "../inputs/codelists/cl_species_level0.csv", mode = "wb")

print("All code lists downloaded!")