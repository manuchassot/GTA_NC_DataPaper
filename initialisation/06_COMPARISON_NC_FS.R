CAPTURE_TO_COMPARE <- CAPTURE

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
                              `America, South - Inland waters` = "Other",
                              `Atlantic, Northwest` = "Atlantic Ocean",
                              `Atlantic, Northeast` = "Atlantic Ocean",
                              `Atlantic, Western Central` = "Atlantic Ocean",
                              `Atlantic, Eastern Central` = "Atlantic Ocean",
                              `Mediterranean and Black Sea` = "Other",
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



dir.create(here("inputs/data/comparison_Fishstat_NC/Fishstat"), recursive = TRUE)
dir.create(here("inputs/data/comparison_Fishstat_NC/NC"), recursive = TRUE)

CAPTURE_TO_COMPARE$year <- as.Date(paste(CAPTURE_TO_COMPARE$year, "-01-01", sep = ""), format = "%Y-%m-%d")
NC$year <- as.Date(paste(NC$year, "-01-01", sep = ""), format = "%Y-%m-%d")


saveRDS(CAPTURE_TO_COMPARE , here("inputs/data/comparison_Fishstat_NC/Fishstat/rds.rds"))
saveRDS(NC, here("inputs/data/comparison_Fishstat_NC/NC/rds.rds"))

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

CAPTURE_TO_COMPARE$gear_label <- "UNK"

common_cols <- c("species", "measurement_type", "year", "measurement_value", 
                 "country_code", "species_group_gta", "taxon", "species_name", 
                 "gear_label", "fleet_label", "ocean_basin", "measurement_unit")

parameters_child_global <- list(fig.path = "figures", 
                                print_map = FALSE, parameter_time_dimension = "year", 
                                unique_analyse = FALSE, 
                                parameter_init =here("inputs/data/comparison_Fishstat_NC/Fishstat"), 
                                parameter_final = here("inputs/data/comparison_Fishstat_NC/NC"), 
                                parameter_colnames_to_keep =common_cols,
                                parameter_diff_value_or_percent = "Difference in value",
                                parameter_fact = "catch", shape_without_geom = NULL, 
                                species_group = NULL, child_header = "", 
                                parameter_titre_dataset_1 = "Fishstat",
parameter_titre_dataset_2 = "Nominal catch" )


source(purl(here("rmd/Comparison_NC_FS/Functions_markdown.Rmd")))
rmarkdown::render(here("rmd/Comparison_NC_FS/comparison.Rmd"), 
                  envir =  child_env_global, 
                  output_dir = here("rmd/outputs/Comp_FS_NC"))

