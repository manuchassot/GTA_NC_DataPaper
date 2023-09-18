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
                  output_file = paste0("Recap.html"),
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


