# Analyse filtering on SBF data

load(here("inputs/spatial_layers/SpatialLayers.RData"))
shapefile.fix <- shapefile.fix %>% rename(geom = the_geom) %>% dplyr::select(CWP_CODE, GRIDTYPE, SURFACE, geom)
shape_without_geom  <- shapefile.fix %>% as_tibble() %>%dplyr::select(-geom)
dir.create(here("rmd/outputs/filtering_species/figures/"), recursive = TRUE)
parameters_child_global <- list(fig.path = paste0("outputs/filtering_species/figures/"), 
                                print_map = FALSE, time_dimension = "time_start", 
                                unique_analyse = FALSE, 
                                parameter_init =here("inputs/Markdown/mapping_codelist"), 
                                parameter_final = here("inputs/Markdown/Filtering species"), 
                                parameter_colnames_to_keep =c(       "time_start",                 
                                                                     "geographic_identifier","species",     
                                                                     "measurement_unit",         
                                                                     "measurement_value", "source_authority"), 
                               child = FALSE, parameter_fact = "catch", continent= continent, 
                               shapefile.fix = shapefile.fix, shape_without_geom = shape_without_geom, parameter_titre_dataset_1 = "Before filtering", 
                               parameter_titre_dataset_2 = "After filtering")

child_env_global = new.env()
list2env(parameters_child_global, env = child_env_global)

require(bookdown)

rmarkdown::render(here("rmd/comparison.Rmd"), 
                  envir =  child_env_global, 
                  output_file = paste0("filtering_species.html"),
                  output_dir = here("rmd/outputs/filtering_species"))


parameters_child_global$parameter_filtering <- list(species= "SBF")
dir.create(here("rmd/outputs/filtering_sbf/figures/"), recursive = TRUE)
parameters_child_global$fig.path <- paste0("outputs/filtering_sbf/figures/")

child_env_global = new.env()
list2env(parameters_child_global, env = child_env_global)


rmarkdown::render(here("rmd/comparison.Rmd"), 
                  envir =  child_env_global, 
                  output_file = paste0("filtering_sbf.html"),
                  output_dir = here("rmd/outputs/filtering_sbf"))
