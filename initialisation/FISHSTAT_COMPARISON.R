
fishstatdataset <- read_csv(here("inputs/data/comparison_Fishstat_NC/Capture_Quantity.csv"))
fishstatdataset$gear_type <- "UNK"
fishingfleet_FS <- read_csv(here("inputs/data/comparison_Fishstat_NC/CL_FI_COUNTRY_GROUPS.csv"))
cl_species_level0 <- read_csv("inputs/codelists/cl_species_level0.csv")

require(dplyr)
fishstatdataset_filtered <- dplyr::semi_join(fishstatdataset, 
                                               cl_species_level0, by = c("SPECIES.ALPHA_3_CODE" = "code")) %>% 
  dplyr::inner_join(fishingfleet_FS %>% dplyr::select(c(UN_Code, Name_En, ISO3_Code)), by =c ("COUNTRY.UN_CODE" = "UN_Code")) %>% 
  dplyr::rename(country = Name_En, species = SPECIES.ALPHA_3_CODE, year = PERIOD, geographic_identifier = AREA.CODE,
                fishing_fleet = COUNTRY.UN_CODE, measurement_value= VALUE) %>% 
  dplyr::select(-c(STATUS, MEASURE)) %>% 
  dplyr::mutate(measurement_unit = "t")

mapping_FS_NC <- read_csv(here("inputs/mappings/mapping_FS_NC.csv"))
mapping_FS_NC$fishing_fleet <- ifelse(mapping_FS_NC$ISO3_Code == "BEL", "EUBEL", mapping_FS_NC$fishing_fleet) 
mapping_FS_NC$fishing_fleet <- ifelse(mapping_FS_NC$ISO3_Code == "SVN", "EUSVN", mapping_FS_NC$fishing_fleet) 


fishstatdataset_filtered_mapped_to_GTA <-fishstatdataset_filtered %>% dplyr::select(-c(country, fishing_fleet))%>%
  left_join(mapping_FS_NC%>% dplyr::select(ISO3_Code, fishing_fleet) %>% distinct() , by = c("ISO3_Code")) %>% 
  mutate(fishing_fleet = ifelse(is.na(fishing_fleet), ISO3_Code, fishing_fleet )) %>% 
  dplyr::select(-ISO3_Code)

cl_country <- read_csv(here("inputs/codelists/cl_fishing_fleet_with_country.csv"))


COUNTRIES_SF_without_geom <- sf::st_drop_geometry(COUNTRIES_SF %>% dplyr::select(-geom))
country_to_territ_codes <- COUNTRIES_SF_without_geom %>% filter(ISO3CD != ISO_3) %>% 
  dplyr::select(country_code = ISO_3, territory_code = ISO3CD)

fishstatdataset_filtered_mapped_country <- fishstatdataset_filtered_mapped_to_GTA %>%
  left_join(country_to_territ_codes %>% distinct(), by = c("fishing_fleet" = "territory_code")) %>% 
  mutate(country_code = ifelse(is.na(country_code), fishing_fleet, country_code))


NC_country <- NC %>% left_join(country_to_territ_codes %>% distinct(), by = c("fishing_fleet" = "territory_code")) %>% 
  mutate(country_code = ifelse(is.na(country_code), fishing_fleet, country_code))


fishstatdataset_filtered_mapped_country_groupped <- fishstatdataset_filtered_mapped_country %>% group_by(species, year) %>%
  summarise(measurement_value = sum(measurement_value))

NC_RAW_groupped <- NC_country %>% group_by(species, year) %>%
  summarise(measurement_value = sum(measurement_value)) 

NC_RAW_groupped$dataset <- "NC"
fishstatdataset_filtered_mapped_country_groupped$dataset <- "FishStat"


comp_NC_FS <- rbind(NC_RAW_groupped, fishstatdataset_filtered_mapped_country_groupped)

require(ggplot2)
ggplot(comp_NC_FS) +
  aes(
    x = year,
    y = measurement_value,
    colour = dataset,
    group = species
  ) +
  geom_point(shape = "circle", size = 1.5) +
  scale_color_hue(direction = 1) +
  theme_minimal() +
  facet_wrap(vars(species), scales = "free")





#### Comparison detailled

NC_RAW_tidy_comp <- NC_country %>%
  dplyr::select(colnames(fishstatdataset_filtered_mapped_country))

NC_RAW_tidy_comp$year <- as.Date(paste(NC_RAW_tidy_comp$year, "-01-01", sep = ""), format = "%Y-%m-%d")
fishstatdataset_filtered_mapped_country$year <- as.Date(paste(fishstatdataset_filtered_mapped_country$year, "-01-01", sep = ""), format = "%Y-%m-%d")

append_information <- function(NC_RAW) {
  # Append taxonomic information
  NC <- merge(NC_RAW, SPECIES_ITIS[, .(species_group_gta = `Species group`, species_code_asfis = `ASFIS code`, taxon = `Scientific name`, species_aggregate = Aggregate, tsn = TSN)], by.x = "species", by.y = "species_code_asfis", all.x = TRUE)
  # Append species English name
  NC <- merge(NC, SPECIES_LEVEL0[, .(code, species_name = name_en)], by.x = "species", by.y = "code", all.x = TRUE)
  # Append gear information
  NC <- merge(NC, GEARS[, .(code, gear_label = label)], by.x = "gear_type", by.y = "code", all.x = TRUE)
  # Append fleet names
  NC <- merge(NC, FLEETS[, .(code, fleet_label = label)], by.x = "fishing_fleet", by.y = "code", all.x = TRUE)
  # Append country names
  NC <- merge(NC, FLEETS[, .(code, country_label = label)], by.x = "country_code", by.y = "code", all.x = TRUE)
  
  return(NC)
}

NC_informed <- append_information(NC_RAW_tidy_comp)
FS_informed <- append_information(fishstatdataset_filtered_mapped_country)







dir.create(here("inputs/data/comparison_Fishstat_NC/Fishstat"), recursive = TRUE)
dir.create(here("inputs/data/comparison_Fishstat_NC/NC"), recursive = TRUE)
saveRDS(FS_informed , here("inputs/data/comparison_Fishstat_NC/Fishstat/rds.rds"))
saveRDS(NC_informed, here("inputs/data/comparison_Fishstat_NC/NC/rds.rds"))

## Those files will be used in the comparison file

dir.create(paste0("rmd/outputs/Comp_FS_NC/figures"), recursive = TRUE, showWarnings = FALSE)


parameters_child_global <- list(fig.path = paste0("outputs/Comp_FS_NC/figures/"), 
                                print_map = FALSE, time_dimension = "year", 
                                unique_analyse = FALSE, 
                                parameter_init =here("inputs/data/comparison_Fishstat_NC/Fishstat"), 
                                parameter_final = here("inputs/data/comparison_Fishstat_NC/NC"), 
                                parameter_colnames_to_keep =c(       "year",                 
                                                      "geographic_identifier","species",     
                                                      "measurement_unit",         
                                                      "measurement_value", "country_label", 
                                                      "gear_label",
                                                      "species_group_gta"), 
                                parameter_fact = "catch")
child_env_global = new.env()
list2env(parameters_child_global, env = child_env_global)

require(bookdown)

rmarkdown::render(here("rmd/comparison.Rmd"), 
                  envir =  child_env_global, 
                  output_file = paste0("Recap.html"),
                  output_dir = here("rmd/outputs/Comp_FS_NC"))




