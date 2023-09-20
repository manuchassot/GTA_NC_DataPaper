setwd(here("rmd/Comparison_NC_FS"))
required_packages <- c("webshot",
                       "here", "usethis","ows4R","sp", "data.table", "flextable", "readtext", "sf", "dplyr", "stringr", "tibble",
                       "bookdown", "knitr", "purrr", "readxl", "base", "remotes", "utils", "DBI", 
                       "odbc", "rlang", "kableExtra", "readr", "tidyr", "ggplot2", "stats", "RColorBrewer", 
                       "cowplot", "RPostgreSQL", "curl", "officer", "gdata", "tidyr", "knitr", "tmap"
)

for (package in required_packages) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package, dependencies = TRUE)
  }
  library(package, character.only = TRUE)
}


last_path = function(y){tail(str_split(y,"/")[[1]],n=1)}

url_analysis_markdown <- "https://raw.githubusercontent.com/firms-gta/geoflow-tunaatlas/master/Analysis_markdown/"
target_dir <- getwd()  # Current working directory

copyrmd <- function(x, url_path = url_analysis_markdown) {
  target_file <- file.path(target_dir, last_path(x))
  
  if (!file.exists(target_file)) {
    download_url <- paste0(url_path, x)
    file.copy(download_url, target_file)
  }
}

# Existing files
c_existing <- c(
  "tableau_recap_global_action_effort.Rmd", 
  "comparison.Rmd", 
  "strata_conversion_factor_gihtub.Rmd", 
  "template.tex",
  "dmk-format.csl", 
  "setup_markdown.Rmd", 
  "strata_in_georef_but_no_nominal.Rmd"
)

# Child Rmd files you want to include
c_child <- c(
  "Setup_markdown.Rmd",
  "Parameters_settings.Rmd",
  "file_formatting.Rmd",
  "Explenation.Rmd",
  "Filtering_data.Rmd",
  "Groupping_differences.Rmd",
  "Strataloss.Rmd",
  "Summarydifferences.Rmd",
  "Compnumberstratas.Rmd",
  "Timecoverage.Rmd",
  "Spatialcoverage.Rmd",
  "Otherdimensions.Rmd",
  "Timediff.Rmd",
  "Geographicdiff.Rmd",
  "Differences_for_each_dimensions.Rmd",
  "Recap_without_mapping.Rmd",
  "Annexe.Rmd", "Functions_markdown.Rmd"
)

# Combine existing and child Rmd files
c_all <- c(c_existing, c_child)

# Download all files
lapply(c_all, copyrmd)




# Read data and code lists
fishstatdataset <- read_csv(here("inputs/data/FSJ/Capture_Quantity.csv"))
fishingfleet_FS <- read_csv(here("inputs/data/FSJ/CL_FI_COUNTRY_GROUPS.csv"))
cl_species_level0 <- read_csv(here("inputs/codelists/cl_species_level0.csv"))


fishstatdataset_filtered <- semi_join(fishstatdataset, 
                                      cl_species_level0, by = c("SPECIES.ALPHA_3_CODE" = "code")) %>% 
  inner_join(fishingfleet_FS %>% select(c(UN_Code, Name_En)), by =c ("COUNTRY.UN_CODE" = "UN_Code")) %>% 
  dplyr::rename(country = Name_En, species = SPECIES.ALPHA_3_CODE, year = PERIOD, geographic_identifier = AREA.CODE,
                fishing_fleet = COUNTRY.UN_CODE, measurement_value= VALUE) %>% 
  dplyr::select(-c(STATUS, MEASURE)) %>% 
  mutate(measurement_unit = "t")
fishstatdataset_groupped <- fishstatdataset_filtered %>% group_by(year, species) %>% summarise(measurement_value = sum(measurement_value))

#checking fishing_fleet 
cl_country <- read_csv(here("inputs/codelists/cl_fishing_fleet_with_country.csv"))
codelist_mapping_fishing_fleet_country <- read_excel("~/GTA_NC_DataPaper/inputs/mappings/codelist_mapping_fishing_fleet_country.xlsx")
NC_RAW_country <- NC_RAW %>% inner_join(cl_country %>% select(code, country), by = c("fishing_fleet" = "code")) %>% 
  select(-fishing_fleet) 
NC_RAW_country <- NC_RAW %>% inner_join(codelist_mapping_fishing_fleet_country %>% select( fishing_fleet = fleet_code, code = country_code), by = c("fishing_fleet" = "code")) %>% 
  select(-fishing_fleet) 



FS_not_in_NC <-setdiff(fishstatdataset_filtered$country,NC_RAW_country$country)
NC_not_in_FS <-setdiff(NC_RAW_country$country,fishstatdataset_filtered$country)
#many does not correspond

#fixing_by_hand
# fishstatdataset_filtered$country <- ifelse(country == "United Kingdom", "UK", country)
# fishstatdataset_filtered$country <- ifelse(country == "Congo, Dem. Rep. of the", "Congo, Republic of", country)

# to be handlded later, for now removed. 

fishstatdataset_filtered <- fishstatdataset_filtered %>% dplyr::select(-c(country, fishing_fleet))

#checking species

length(unique(fishstatdataset_filtered$species))

length(unique(cl_species_level0$code))

## One species of level 0 is not in fishstatdataset

## Comparison to global nominal catch

NC_RAW <- NC_RAW %>% mutate(year = lubridate::year(time_start))

NC_RAW_tidy_comp <- NC_RAW %>%
  dplyr::select(colnames(fishstatdataset_filtered))

NC_RAW_tidy_comp$year <- as.Date(paste(NC_RAW_tidy_comp$year, "-01-01", sep = ""), format = "%Y-%m-%d")
fishstatdataset_filtered$year <- as.Date(paste(fishstatdataset_filtered$year, "-01-01", sep = ""), format = "%Y-%m-%d")


NC_RAW_groupped <- NC_RAW %>% group_by(species, year) %>%
  summarise(measurement_value = sum(measurement_value)) 

NC_RAW_groupped <- NC_RAW_groupped %>% mutate(year = as.Date(year))


NC_RAW_groupped$dataset <- "NC"
fishstatdataset_filtered$dataset <- "FishStat"


comp_NC_FS <- rbind(NC_RAW_groupped, fishstatdataset_filtered)

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



dir.create(here("inputs/data/comparison_Fishstat_NC/Fishstat"), recursive = TRUE)
dir.create(here("inputs/data/comparison_Fishstat_NC/NC"), recursive = TRUE)
saveRDS(fishstatdataset_filtered , here("inputs/data/comparison_Fishstat_NC/Fishstat/rds.rds"))
saveRDS(NC_RAW_tidy_comp, here("inputs/data/comparison_Fishstat_NC/NC/rds.rds"))

## Those files will be used in the comparison file

dir.create(here("rmd/outputs/Comp_FS_NC/figures"), recursive = TRUE, showWarnings = FALSE)


parameters_child_global <- list(fig.path = here("rmd/outputs/Comp_FS_NC/figures/"), 
                                print_map = FALSE, time_dimension = "year", 
                                unique_analyse = FALSE, 
                                parameter_init =here("inputs/data/comparison_Fishstat_NC/Fishstat"), 
                                parameter_final = here("inputs/data/comparison_Fishstat_NC/NC"), 
                                parameter_colnames_to_keep =c(       "year",                 
                                                                     "geographic_identifier","species",     
                                                                     "measurement_unit",         
                                                                     "measurement_value", "country_label", 
                                                                     "gear_label",
                                                                     "species_group_gta"), parameter_diff_value_or_percent = "Difference in value",
                                parameter_fact = "catch")
child_env_global = new.env()
list2env(parameters_child_global, env = child_env_global)

require(bookdown)

rmarkdown::render(here("rmd/comparison.Rmd"), 
                  envir =  child_env_global, 
                  output_dir = here("rmd/outputs/Comp_FS_NC"))

#####################

# filtering_param <-  readRDS(here("inputs/data/comparison_Fishstat_NC/communtime_species.rds"))

dir.create(here("rmd/outputs/Comp_FS_NC_FILTERED/figures"), recursive = TRUE, showWarnings = FALSE)

parameters_child_global$parameter_init =here("inputs/data/comparison_Fishstat_NC/Fishstatfiltered")
parameters_child_global$parameter_final = here("inputs/data/comparison_Fishstat_NC/NCfiltered")
parameters_child_global$fig.path = paste0(here("rmd/outputs/Comp_FS_NC_FILTERED/figures/"))
child_env_global = new.env()
list2env(parameters_child_global, env = child_env_global)

rmarkdown::render(here("rmd/comparison.Rmd"), 
                  envir =  child_env_global, 
                  output_file = paste0("Comp_FS_NC_filtered.html"),
                  output_dir = here("rmd/outputs/Comp_FS_NC_FILTERED"))



