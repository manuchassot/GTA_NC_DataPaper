
fishstatdataset <- read_csv("inputs/data/Capture_Quantity.csv")
fishingfleet_FS <- read_csv("inputs/data/CL_FI_COUNTRY_GROUPS.csv")
cl_species_level0 <- read_csv("inputs/codelists/cl_species_level0.csv")


fishstatdataset_filtered <- semi_join(fishstatdataset, 
                                               cl_species_level0, by = c("SPECIES.ALPHA_3_CODE" = "code")) %>% 
  inner_join(fishingfleet %>% select(c(UN_Code, Name_En)), by =c ("COUNTRY.UN_CODE" = "UN_Code")) %>% 
  dplyr::rename(country = Name_En, species = SPECIES.ALPHA_3_CODE, year = PERIOD, geographic_identifier = AREA.CODE,
                fishing_fleet = COUNTRY.UN_CODE, measurement_value= VALUE) %>% 
  dplyr::select(-c(STATUS, MEASURE)) %>% 
  mutate(measurement_unit = "t")
fishstatdataset_groupped <- fishstatdataset_filtered %>% group_by(year, species) %>% summarise(measurement_value = sum(measurement_value))

#checking fishing_fleet 
cl_country <- read_csv(here("inputs/codelists/cl_fishing_fleet_with_country.csv"))
NC_RAW_country <- NC_RAW %>% inner_join(cl_country %>% select(code, country), by = c("fishing_fleet" = "code")) %>% select(-fishing_fleet) 



FS_not_in_NC <-setdiff(fishstatdataset_filtered$country,NC_RAW_country$country)
NC_not_in_FS <-setdiff(NC_RAW_country$country,fishstatdataset_filtered$country)
#many does not correspond

#fixing_by_hand
# fishstatdataset_filtered$country <- ifelse(country == "United Kingdom", "UK", country)
# fishstatdataset_filtered$country <- ifelse(country == "Congo, Dem. Rep. of the", "Congo, Republic of", country)

# to be handlded later, for now removed. 

fishstatdataset_filtered <- fishstatdataset_filtered %>% dplyr::select(-c(country, fishing_fleet))

#checking species

length(unique(fishstatdataset_groupped_filtered$species))

length(unique(cl_species_level0$code))

## One species of level 0 is not in fishstatdataset

## Comparison to global nominal catch


NC_RAW_groupped <- NC_RAW %>% group_by(species, year) %>%
  summarise(measurement_value = sum(measurement_value)) 

NC_RAW_groupped$dataset <- "NC"
fishstatdataset_groupped_filtered$dataset <- "FishStat"


comp_NC_FS <- rbind(NC_RAW_groupped, fishstatdataset_groupped_filtered)

require(ggplot2)
ggplot(comp_NC_FS) +
  aes(
    x = year,
    y = measurement_value,
    fill = dataset,
    colour = dataset,
    group = dataset
  ) +
  geom_point(shape = "circle", size = 0.5) +
  scale_fill_hue(direction = 1) +
  scale_color_hue(direction = 1) +
  theme_minimal() +
  facet_wrap(vars(species), scales = "free")





#### Comparison detailled

NC_RAW_tidy_comp <- NC_RAW %>%
  dplyr::select(colnames(fishstatdataset_filtered))

NC_RAW_tidy_comp$year <- as.Date(paste(NC_RAW_tidy_comp$year, "-01-01", sep = ""), format = "%Y-%m-%d")
fishstatdataset_filtered$year <- as.Date(paste(fishstatdataset_filtered$year, "-01-01", sep = ""), format = "%Y-%m-%d")


dir.create(here("inputs/data/comparison_Fishstat_NC/Fishstat"), recursive = TRUE)
dir.create(here("inputs/data/comparison_Fishstat_NC/NC"), recursive = TRUE)
saveRDS(fishstatdataset_filtered , here("inputs/data/comparison_Fishstat_NC/Fishstat/rds.rds"))
saveRDS(NC_RAW_tidy_comp, here("inputs/data/comparison_Fishstat_NC/NC/rds.rds"))

## Those files will be used in the comparison file

dir.create(paste0("rmd/outputs/Comp_FS_NC"), recursive = TRUE, showWarnings = FALSE)


parameters_child_global <- list(fig.path = paste0("outputs/Comp_FS_NC/"), 
                                print_map = FALSE, time_dimension = "year", 
                                unique_analyse = FALSE, 
                                parameter_init =here("inputs/data/comparison_Fishstat_NC/Fishstat"), 
                                parameter_final = here("inputs/data/comparison_Fishstat_NC/NC"), 
                                parameter_colnames_to_keep =c(       "year",                 
                                                      "geographic_identifier","species",     
                                                      "measurement_unit",         
                                                      "measurement_value"), 
                                parameter_fact = "catch")
child_env_global = new.env()
list2env(parameters_child_global, env = child_env_global)

require(bookdown)

rmarkdown::render(here("rmd/comparison.Rmd"), 
                  envir =  child_env_global, 
                  output_file = paste0("Recap.pdf"),
                  output_dir = here("rmd/outputs/COMP_FS_NC"))


