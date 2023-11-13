print("Downloading mapping code lists of each tRFMO from the github repo...")

# MAPPINGS ####

for (i in c("ccsbt", "iattc", "iccat", "iotc", "wcpfc")){
  
## RFMO species mapping ####
if (!file.exists(paste0("../inputs/mappings/codelist_mapping_species_", i, "_species_asfis.csv")))
  
  download.file(paste0("https://raw.githubusercontent.com/fdiwg/fdi-mappings/main/regional-to-global/", toupper(i), "/codelist_mapping_species_", i, "_species_asfis.csv"), destfile = paste0("../inputs/mappings/codelist_mapping_species_", i, "_species_asfis.csv"), mode = "wb")

## RFMO gear mapping ####
if(!file.exists(paste0("../inputs/mappings/codelist_mapping_gear_", i, "_isscfg_revision_1.csv")))
  
  download.file(paste0("https://raw.githubusercontent.com/fdiwg/fdi-mappings/main/regional-to-global/", toupper(i), "/codelist_mapping_gear_", i, "_isscfg_revision_1.csv"), destfile = paste0("../inputs/mappings/codelist_mapping_gear_", i, "_isscfg_revision_1.csv"), mode = "wb")

## RFMO fleet mapping ####
if(!file.exists(paste0("../inputs/mappings/codelist_mapping_flag_", i, "_fishingfleet_firms.csv")))
  
  download.file(paste0("https://raw.githubusercontent.com/fdiwg/fdi-mappings/main/regional-to-global/", toupper(i), "/codelist_mapping_flag_", i, "_fishingfleet_firms.csv"), destfile = paste0("../inputs/mappings/codelist_mapping_flag_", i, "_fishingfleet_firms.csv"), mode = "wb")

}

## FIRMS fleet to countries mapping ####
if(!file.exists("../inputs/mappings/codelist_mapping_fishingfleet_firms_flag_fao_cwp.csv"))
  
  download.file("https://raw.githubusercontent.com/fdiwg/fdi-mappings/main/global/firms/gta/codelist_mapping_fishingfleet_firms_flag_fao_cwp.csv", destfile = "../inputs/mappings/codelist_mapping_fishingfleet_firms_flag_fao_cwp.csv")
  
## Species to species group mapping ####
if(!file.exists("../inputs/mappings/codelist_mapping_species_asfis_speciesgroup_tunaatlas.csv"))
  
  download.file("https://raw.githubusercontent.com/fdiwg/fdi-mappings/main/global/firms/gta/codelist_mapping_species_asfis_speciesgroup_tunaatlas.csv", destfile = "../inputs/mappings/codelist_mapping_species_asfis_speciesgroup_tunaatlas.csv", mode = "wb")

## Species to ocean basin ####
if(!file.exists("../inputs/mappings/codelist_mapping_source_authority_species.csv"))
  
  download.file("https://raw.githubusercontent.com/fdiwg/fdi-mappings/main/cross-term/codelist_mapping_source_authority_species.csv", destfile = "../inputs/mappings/codelist_mapping_source_authority_species.csv", mode = "wb")

## Gear type to gear group mapping ####
if(!file.exists("../inputs/mappings/codelist_mapping_isscfg_revision_1_geargroup_tunaatlas.csv"))
  
  download.file("https://raw.githubusercontent.com/fdiwg/fdi-mappings/main/global/firms/gta/codelist_mapping_isscfg_revision_1_geargroup_tunaatlas.csv", destfile = "../inputs/mappings/codelist_mapping_isscfg_revision_1_geargroup_tunaatlas.csv", mode = "wb")

print("Mapping code lists of each tRFMO from the github repo downloaded!")
