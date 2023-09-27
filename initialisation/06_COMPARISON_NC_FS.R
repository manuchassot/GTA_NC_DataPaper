
## Those files will be used in the comparison file

dir.create(here("rmd/Comparison_NC_FS/figures"), recursive = TRUE, showWarnings = FALSE)
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
target_dir <- here("rmd/Comparison_NC_FS")  # Current working directory

copyrmd <- function(x, url_path = url_analysis_markdown) {
  target_file <- file.path(target_dir, last_path(x))

  if (!file.exists(target_file)) {
    download_url <- paste0(url_path, x)
    download.file(url = download_url, destfile = target_file, mode = "wb")
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




# Tidying for comparison  -------------------------------------------------
CAPTURE_TO_COMPARE <- CAPTURE


NC_TO_COMPARE <- NC
NC_TO_COMPARE$measurement_type <- "UNK"


NC_TO_COMPARE <- NC_TO_COMPARE %>% left_join(MAPPING_FLEET_FSJ_COUNTRY, by = c("fishing_fleet"= "code")) %>% 
  left_join(CL_COUNTRIES, by = c("fsj_country_code" = "COUNTRY_CODE"))

NC_TO_COMPARE <- NC_TO_COMPARE %>% dplyr::select(-c(country_code, UN_CODE, fleet_label)) %>% 
  dplyr::rename(country_code = fsj_country_code, fleet_label = COUNTRY)
  




# Diff label diff label ---------------------------------------------------

unique(NC_TO_COMPARE %>% filter(fleet_label != label) %>% dplyr::select(fleet_label, label)%>% distinct())

NC_not_FS <- setdiff(NC_TO_COMPARE$fleet_label, CAPTURE_TO_COMPARE$COUNTRY)
FS_not_NC <- setdiff(CAPTURE_TO_COMPARE$COUNTRY, NC_TO_COMPARE$fleet_label)


# CAPTURE_TO_COMPARE3 <- unique((CAPTURE_TO_COMPARE %>% filter(!is.na(COUNTRY_CODE) & is.na(code)))$COUNTRY)
# print(CAPTURE_TO_COMPARE3)
# No equivalent for country to map from JSF to other


# "Territory/Country from First List","Equivalent Country from Second List"
# "British Indian Ocean Ter","United Kingdom"
# "US Virgin Islands","United States of America"
# "Montenegro","Serbia and Montenegro"
# "Sudan (former)","Sudan"
# "French Guiana","France"
# "Tokelau","New Zealand"
# "Greenland","Greenland" maybe only since 2008?
# "Isle of Man","United Kingdom"
# "Northern Mariana Is.","United States of America"
# "Guam","United States of America"
# "Channel Islands","United Kingdom"
# "Congo, Dem. Rep. of the","Congo"
# "Guadeloupe","France"
# "Martinique","France"
# "American Samoa","United States of America"
# "New Caledonia","France"
# "Réunion","France"

mapping_from_FSJ_to_NC <- read_csv(here("inputs/mappings/Mapping_from_fsj_to_nc.csv")) %>% 
  dplyr::select(FSJ, NC)

# Code_NC <- mapping_from_FSJ_to_NC %>% inner_join(NC_TO_COMPARE %>% 
#                                                    dplyr::select(label, country_code), by = c("NC"="label"))

CAPTURE_TO_COMPARE <- CAPTURE_TO_COMPARE %>% dplyr::left_join(mapping_from_FSJ_to_NC, 
                                                        by = c("COUNTRY"="FSJ")) %>% 
  mutate(COUNTRY = ifelse(is.na(NC), COUNTRY, NC)) %>% dplyr::select(-NC)

NC_not_FS <- setdiff(NC_TO_COMPARE$fleet_label, CAPTURE_TO_COMPARE$COUNTRY)
FS_not_NC <- setdiff(CAPTURE_TO_COMPARE$COUNTRY, NC_TO_COMPARE$fleet_label)




names(CAPTURE_TO_COMPARE)[names(CAPTURE_TO_COMPARE) %in% c("SPECIES.ALPHA_3_CODE", "MEASURE", 
                                     "PERIOD", "VALUE", "COUNTRY_CODE", "COUNTRY", 
                                     "SPECIES", "SPECIES_SCIENTIFIC", "ISSCAAP_NAME", 
                                     "FISHING_GROUND", "MEASUREMENT_NAME")] <- 
  c("species", "measurement_type", "year", "measurement_value", 
    "country_code", "fleet_label", "species_name", "taxon", "species_group_gta", 
    "ocean_basin", "measurement_unit")


CAPTURE_TO_COMPARE <- CAPTURE_TO_COMPARE %>% dplyr::select(-c('STATUS'))

CAPTURE_TO_COMPARE$measurement_unit <- "t"

CAPTURE_TO_COMPARE$ocean_basin <- recode(CAPTURE_TO_COMPARE$ocean_basin,
                              `America, South - Inland waters` = "America, South - Inland waters",
                              `Atlantic, Northwest` = "Atlantic Ocean",
                              `Atlantic, Northeast` = "Atlantic Ocean",
                              `Atlantic, Western Central` = "Atlantic Ocean",
                              `Atlantic, Eastern Central` = "Atlantic Ocean",
                              `Mediterranean and Black Sea` = "Mediterranean and Black Sea",
                              `Atlantic, Southwest` = "Atlantic Ocean",
                              `Atlantic, Southeast` = "Atlantic Ocean",
                              `Atlantic, Antarctic` = "Atlantic Ocean",
                              `Indian Ocean, Western` = "Indian Ocean",
                              `Indian Ocean, Eastern` = "Indian Ocean",
                              `Indian Ocean, Antarctic` = "Indian Ocean",
                              `Pacific, Northwest` = "Western-Central Pacific Ocean",
                              `Pacific, Northeast` = "Western-Central Pacific Ocean",
                              `Pacific, Western Central` = "Western-Central Pacific Ocean",
                              `Pacific, Eastern Central` = "Eastern Pacific Ocean",
                              `Pacific, Southwest` = "Western-Central Pacific Ocean",
                              `Pacific, Southeast` = "Western-Central Pacific Ocean",
                              `Pacific, Antarctic` = "Western-Central Pacific Ocean")



# Mapping for fishing_fleet -----------------------------------------------


# Mapping fleet label to fleet label
# Proposition


# mapping <- read_csv(here("inputs/mappings/mapping_from_FSJ_to_NC.csv"))
# 
# CAPTURE_TO_COMPARE <- CAPTURE_TO_COMPARE %>% 
#   dplyr::left_join(mapping, by = c("fleet_label"="Mapped Label")) %>% 
#   mutate(`fleet_label` = ifelse(is.na(`Original Label`), fleet_label, `Original Label`)) %>% 
#   dplyr::select(-c(`Original Label`, code))

# Mapping country to country ----------------------------------------------








dir.create(here("inputs/data/comparison_Fishstat_NC/Fishstat"), recursive = TRUE)
dir.create(here("inputs/data/comparison_Fishstat_NC/NC"), recursive = TRUE)

CAPTURE_TO_COMPARE$year <- as.Date(paste(CAPTURE_TO_COMPARE$year, "-01-01", sep = ""), format = "%Y-%m-%d")
CAPTURE_TO_COMPARE$gear_label <- "UNK"
CAPTURE_TO_COMPARE <- CAPTURE_TO_COMPARE %>% mutate(country_code = ifelse(fleet_label == "Other nei", "NEI", country_code))

NC_TO_COMPARE$year <- as.Date(paste(NC_TO_COMPARE$year, "-01-01", sep = ""), format = "%Y-%m-%d")
NC_TO_COMPARE <- NC_TO_COMPARE %>% mutate(fleet_label = ifelse(country_code == "NEI", "Other nei", fleet_label))

saveRDS(CAPTURE_TO_COMPARE , here("inputs/data/comparison_Fishstat_NC/Fishstat/rds.rds"))
saveRDS(NC_TO_COMPARE, here("inputs/data/comparison_Fishstat_NC/NC/rds.rds"))



common_cols <- c("species", "measurement_type", "year", "measurement_value", 
                 "country_code", "species_group_gta", "taxon", "species_name", 
                 "gear_label", "fleet_label", "ocean_basin", "measurement_unit")

parameters_child_global <- list(fig.path = "figures", 
                                print_map = FALSE, parameter_time_dimension = "year", 
                                unique_analyse = FALSE, 
                                parameter_init =here("inputs/data/comparison_Fishstat_NC/Fishstat"), 
                                parameter_final = here("inputs/data/comparison_Fishstat_NC/NC"), 
                                parameter_colnames_to_keep =c("species", "measurement_type", "year", "measurement_value", 
                                                              "country_code", "species_group_gta", "taxon", "species_name", 
                                                              "gear_label", "fleet_label", "ocean_basin", "measurement_unit"),
                                parameter_diff_value_or_percent = "Difference in value",
                                parameter_fact = "catch", shape_without_geom = NULL, 
                                species_group = NULL, child_header = "", 
                                parameter_titre_dataset_1 = "Fishstat",
parameter_titre_dataset_2 = "Nominal catch" )

child_env_global <- new.env()
list2env(parameters_child_global, child_env_global)

source(purl(here("rmd/Comparison_NC_FS/Functions_markdown.Rmd")))
rmarkdown::render(here("rmd/Comparison_NC_FS/comparison.Rmd"), 
                  envir =  child_env_global, 
                  output_dir = here("rmd/Comparison_NC_FS/figures"))



## Comparison on filtered data species, year and ocean basin 
NC_TO_COMPARE_filtered <- NC_TO_COMPARE
CAPTURE_TO_COMPARE_filtered <- CAPTURE_TO_COMPARE

NC_TO_COMPARE_filtered <- NC_TO_COMPARE_filtered %>% dplyr::filter(species %in% unique(CAPTURE_TO_COMPARE_filtered$species))
CAPTURE_TO_COMPARE_filtered <- CAPTURE_TO_COMPARE_filtered %>% filter(species %in% unique(NC_TO_COMPARE_filtered$species))


NC_TO_COMPARE_filtered <- NC_TO_COMPARE_filtered %>% filter(year %in% unique(CAPTURE_TO_COMPARE_filtered$year))
CAPTURE_TO_COMPARE_filtered <- CAPTURE_TO_COMPARE_filtered %>% filter(year %in% unique(NC_TO_COMPARE_filtered$year))

NC_TO_COMPARE_filtered <- NC_TO_COMPARE_filtered %>% filter(ocean_basin %in% unique(CAPTURE_TO_COMPARE_filtered$ocean_basin))
CAPTURE_TO_COMPARE_filtered <- CAPTURE_TO_COMPARE_filtered %>% filter(ocean_basin %in% unique(NC_TO_COMPARE_filtered$ocean_basin))


dir.create(here("inputs/data/comparison_Fishstat_NC/Fishstat_filtered"), recursive = TRUE)
dir.create(here("inputs/data/comparison_Fishstat_NC/NC_filtered"), recursive = TRUE)

saveRDS(CAPTURE_TO_COMPARE_filtered , here("inputs/data/comparison_Fishstat_NC/Fishstat_filtered/rds.rds"))
saveRDS(NC_TO_COMPARE_filtered, here("inputs/data/comparison_Fishstat_NC/NC_filtered/rds.rds"))



parameters_child_global <- list(fig.path = "figures_filtered", 
                                print_map = FALSE, parameter_time_dimension = "year", 
                                unique_analyse = FALSE, 
                                parameter_init =here("inputs/data/comparison_Fishstat_NC/Fishstat_filtered"), 
                                parameter_final = here("inputs/data/comparison_Fishstat_NC/NC_filtered"), 
                                parameter_colnames_to_keep =c("species", "measurement_type", "year", "measurement_value", 
                                                              "country_code", "species_group_gta", "taxon", "species_name", 
                                                              "gear_label", "fleet_label", "ocean_basin", "measurement_unit"),
                                parameter_diff_value_or_percent = "Difference in value",
                                parameter_fact = "catch", shape_without_geom = NULL, 
                                species_group = NULL, child_header = "", 
                                parameter_titre_dataset_1 = "Fishstat",
                                parameter_titre_dataset_2 = "Nominal catch" )

child_env_global <- new.env()
list2env(parameters_child_global, child_env_global)

source(purl(here("rmd/Comparison_NC_FS/Functions_markdown.Rmd")))
rmarkdown::render(here("rmd/Comparison_NC_FS/comparison.Rmd"), 
                  envir =  child_env_global, 
                  output_dir = here("rmd/Comparison_NC_FS/figures_filtered"))

for (ocean in unique(NC_TO_COMPARE_filtered$ocean_basin)){
  
  dir.create(here(paste0("rmd/Comparison_NC_FS/", ocean)), recursive = TRUE)
  
  parameters_child_global <- list(fig.path = ocean, 
                                  print_map = FALSE, parameter_time_dimension = "year", 
                                  unique_analyse = FALSE, 
                                  parameter_filtering = list("ocean_basin" = ocean),
                                  parameter_init =here("inputs/data/comparison_Fishstat_NC/Fishstat_filtered"), 
                                  parameter_final = here("inputs/data/comparison_Fishstat_NC/NC_filtered"), 
                                  parameter_colnames_to_keep =c("species", "measurement_type", "year", "measurement_value", 
                                                                "country_code", "species_group_gta", "taxon", "species_name", 
                                                                "gear_label", "fleet_label", "ocean_basin", "measurement_unit"),
                                  parameter_diff_value_or_percent = "Difference in value",
                                  parameter_fact = "catch", shape_without_geom = NULL, 
                                  species_group = NULL, child_header = "", 
                                  parameter_titre_dataset_1 = "Fishstat",
                                  parameter_titre_dataset_2 = "Nominal catch" )
  
  child_env_global <- new.env()
  list2env(parameters_child_global, child_env_global)
  
  source(purl(here("rmd/Comparison_NC_FS/Functions_markdown.Rmd")))
  rmarkdown::render(here("rmd/Comparison_NC_FS/comparison.Rmd"), 
                    envir =  child_env_global, 
                    output_dir = here(paste0("rmd/Comparison_NC_FS/", ocean)))
}


# Temporal differences for each species FS/NC -----------------------------

# First, we will reshape the datasets to a format suitable for comparison

Fishstat <- CAPTURE_TO_COMPARE_filtered %>%
  dplyr::select(species, year, measurement_value) %>%
  group_by(species, year) %>%
  summarise(total_value = sum(measurement_value, na.rm = TRUE))

NominalCatch <- NC_TO_COMPARE_filtered %>%
  dplyr::select(species, year, measurement_value) %>%
  group_by(species, year) %>%
  summarise(total_value = sum(measurement_value, na.rm = TRUE))

# Merging datasets based on species and year
comparison <- left_join(Fishstat, NominalCatch, 
                        by = c("species", "year"),
                        suffix = c("_Fishstat", "_NC"))

# Calculating differences
comparison$difference <- comparison$total_value_NC - comparison$total_value_Fishstat

# Generating the plot for each species
species_list <- unique(comparison$species)

if (!dir.exists(here("outputs", "charts", "comparison_FS_NC_time_by_species"))) {
  dir.create(here("outputs", "charts", "comparison_FS_NC_time_by_species"), recursive = TRUE)
}


for(spec in species_list) {
  tmp_data <- filter(comparison, species == spec)
  
  total_diff <- sum(tmp_data$difference, na.rm = TRUE)
  higher <- ifelse(total_diff>0, "Nominal Catch", "Fishstat")
  legend_title <- paste("Dataset with Higher Value is ",higher, "\nTotal Difference:", round(total_diff))
  
  p <- ggplot(tmp_data, aes(x = year, y = difference, fill = difference > 0)) +
    geom_bar(stat="identity") +
    scale_fill_manual(values=c("red", "blue"), 
                      name=legend_title, 
                      breaks=c(TRUE, FALSE), 
                      labels=c("Nominal Catch", "Fishstat")) +
    labs(title=paste("Difference in Measurement Value for", spec), 
         y="Difference (Nominal Catch - Fishstat)", 
         x="Measurement Type") +
    theme_minimal() +
    theme(legend.title = element_text(size=10))  # Adjust this size if necessary
  
  print(p)
  
  # Save the plot, adjusting dimensions to avoid truncation
  ggsave(filename = here("outputs", "charts", "comparison_FS_NC_time_by_species", paste0(spec, "_comparison_plot.png")), 
         plot = p, width=10, height=7)  # You can adjust width and height as needed
}


# Compute the sum of the difference for each species
species_summary <- comparison %>%
  group_by(species) %>%
  summarise(total_difference = sum(difference, na.rm = TRUE))

# Count how many species have a higher total value in each dataset
Fishstat_higher <- sum(species_summary$total_difference < 0)
NC_higher <- sum(species_summary$total_difference > 0)


# Filter species with higher Fishstat values
Fishstat_higher_species <- species_summary %>%
  filter(total_difference < 0) %>%
  dplyr::select(species)


# Filter species with higher NominalCatch values
NC_higher_species <- species_summary %>%
  filter(total_difference > 0) %>%
  dplyr::select(species)





