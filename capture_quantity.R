
# 1) lecture des données
setwd(here::here())
map <- read_csv("mapping.csv")


CAPTURED <- CAPTURE
NCD <- NC

# 2) renommage automatique
names(CAPTURED)[ match(map$source, names(CAPTURED)) ] <- map$target

CAPTURED$measurement_unit <- "t"
class(NCD$measurement_unit) <- "character"
NCD$measurement_unit <- "t"

NC_not_FS <- setdiff(NCD$fishing_fleet, CAPTURED$fishing_fleet)
FS_not_NC <- setdiff(CAPTURED$fishing_fleet, NCD$fishing_fleet)

NC_not_FS_label <- setdiff(NCD$fleet_label, CAPTURED$fishing_fleet_label)
NC_not_FS_label <- setdiff(NCD$country, CAPTURED$fishing_fleet_label)
FS_not_NC_label <- setdiff(CAPTURED$fishing_fleet_label, NCD$fleet_label)
FS_not_NC_label <- setdiff(CAPTURED$fishing_fleet_label, NCD$country)

mapping_from_FSJ_to_NC <- read_delim("inputs/mappings/Mapping_from_fsj_to_nc.csv", 
                                     delim = ";", escape_double = FALSE, trim_ws = TRUE)


CAPTURED <- CAPTURED %>% dplyr::left_join(mapping_from_FSJ_to_NC, 
                                                              by = c("fishing_fleet_label"="FSJ")) %>% 
  mutate(fishing_fleet_label = ifelse(!is.na(NC), NC, fishing_fleet_label)) %>% dplyr::select(-NC)

NC_not_FS <- setdiff(NCD$fishing_fleet, CAPTURED$fishing_fleet)
FS_not_NC <- setdiff(CAPTURED$fishing_fleet, NCD$fishing_fleet)

NC_not_FS_label <- setdiff(NCD$fleet_label, CAPTURED$fishing_fleet_label)
FS_not_NC_label <- setdiff(CAPTURED$fishing_fleet_label, NCD$fleet_label)

mapping_FS_NC <- read_csv(here("inputs/mappings/mapping_FS_NC.csv"))

CAPTURED <- CAPTURED%>% dplyr::left_join(mapping_FS_NC, 
                                         by = c("fishing_fleet_label" = "Country_FishStatJ")) %>% 
  dplyr::mutate(fishing_fleet = ifelse(!is.na(fishing_fleet.y),fishing_fleet.y , fishing_fleet.x)) %>% 
  dplyr::mutate(fishing_fleet_label = ifelse(!is.na(Country_GTA),Country_GTA , fishing_fleet_label)) %>% 
  dplyr::select(-c(Country_GTA, fishing_fleet.y, fishing_fleet.x))


NC_not_FS <- setdiff(NCD$fishing_fleet, CAPTURED$fishing_fleet)
FS_not_NC <- setdiff(CAPTURED$fishing_fleet, NCD$fishing_fleet)

NC_not_FS_label <- setdiff(NCD$fleet_label, CAPTURED$fishing_fleet_label)
FS_not_NC_label <- setdiff(CAPTURED$fishing_fleet_label, NCD$fleet_label)
  

CAPTURED$ocean_basin <- recode(CAPTURED$ocean_basin,
                                         `America, South - Inland waters` = "America, South - Inland waters",
                                         `Atlantic, Northwest` = "Atlantic Ocean",
                                         `Atlantic, Northeast` = "Atlantic Ocean",
                                         `Atlantic, Western Central` = "Atlantic Ocean",
                                         `Atlantic, Eastern Central` = "Atlantic Ocean",
                                          # `Mediterranean and Black Sea` = "Mediterranean and Black Sea",
                                          `Mediterranean and Black Sea` = "Atlantic Ocean",
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

CAPTURED$ocean_basin <- recode(CAPTURED$ocean_basin,
                               `America, South - Inland waters` = "Pacific Ocean",
                               `Western-Central Pacific Ocean` = "Pacific Ocean",
                               `Eastern Pacific Ocean` = "Pacific Ocean")

NCD$ocean_basin <- recode(NCD$ocean_basin,
                               `Western-Central Pacific Ocean` = "Pacific Ocean",
                               `Eastern Pacific Ocean` = "Pacific Ocean")


CAPTURED$species_name <- recode(CAPTURED$species_name,
                               `True tunas NEI` = "True tunas nei",
                               `Tunas NEI` = "Tunas nei")

NC_not_FS_label <- setdiff(unique(NCD$fleet_label), unique(CAPTURED$fishing_fleet_label))
FS_not_NC_label <- setdiff(unique(CAPTURED$fishing_fleet_label), unique(NCD$fleet_label))

# NCD_test <- NCD %>% dplyr::inner_join(as.data.frame(MAPPING_FLEET_FSJ_COUNTRY), by = c("country_code" = "code"))

require(CWP.dataset)

CAPTURED$year <- paste0(CAPTURED$year, "-01-01")
NCD$year <- paste0(NCD$year, "-01-01")
NCD <- NCD %>% dplyr::rename(fishing_fleet_label =fleet_label )

species_intersect <- intersect(CAPTURED$species, NC$species)


CAPTURED_filtered <- CAPTURED %>% dplyr::filter(species %in% species_intersect
                                                | species_name %in% c("Tuna-like fishes NEI", 
                                                                      "True tunas nei", 
                                                                      "Tunas nei", 
                                                                      "Frigate and bullet tunas"))
sum(CAPTURED$measurement_value)
sum(CAPTURED_filtered$measurement_value)

NCD_filtered <- NCD%>% dplyr::filter(species %in% species_intersect
                            | species %in% c("TUN", 
                                                  "TUS"))
sum(NCD$measurement_value)
sum(NCD_filtered$measurement_value)

test <- CWP.dataset::comprehensive_cwp_dataframe_analysis(parameter_init = CAPTURED_filtered, 
                                                          parameter_final = NCD,
                                                          parameter_time_dimension = c("year"), 
                                                          print_map = FALSE, 
                                                          parameter_colnames_to_keep = c("species_name", 
                                                                                         "fishing_fleet_label", "measurement_unit", 
                                                                                         "year", "measurement_value", "ocean_basin"),
                                                          parameter_titre_dataset_1 = "FishStatJ", 
                                                          parameter_titre_dataset_2 = "GTA")
test$combined_summary_histogram <- NULL
test$other_dimension_analysis_list <- NULL

child_env_global = new.env()

list2env(test, envir = child_env_global)
child_env_global$step_title_t_f <- FALSE
child_env_global$child_header <- ""
require(kableExtra)
require(webshot)
base::options(knitr.duplicate.label = "allow")
rmarkdown::render(system.file("rmd/comparison.Rmd", package = "CWP.dataset"),
                  envir = child_env_global,
                  output_file = "COMP_GTA_FishStat", output_dir = getwd())



test_major_tunas <- CWP.dataset::comprehensive_cwp_dataframe_analysis(parameter_init = CAPTURED_filtered %>% 
                                                                        dplyr::filter(species %in% c("YFT", "SKJ", "ALB", "BET", "SWO")), 
                                                          parameter_final = NCD_filtered%>% 
                                                            dplyr::filter(species %in% c("YFT", "SKJ", "ALB", "BET", "SWO")),
                                                          parameter_time_dimension = c("year"), 
                                                          parameter_colnames_to_keep = c("species_name", 
                                                                                         "fishing_fleet_label", "measurement_unit", 
                                                                                         "year", "measurement_value", "ocean_basin"),
                                                          print_map = FALSE, 
                                                          parameter_titre_dataset_1 = "FishStatJ", 
                                                          parameter_titre_dataset_2 = "GTA", topnumber = 10)

test_major_tunas$combined_summary_histogram <- NULL
test_major_tunas$other_dimension_analysis_list <- NULL


child_env_global = new.env()

list2env(test_major_tunas, envir = child_env_global)
child_env_global$step_title_t_f <- FALSE
child_env_global$child_header <- ""
require(kableExtra)
require(webshot)
rmarkdown::render(system.file("rmd/comparison.Rmd", package = "CWP.dataset"),
                  envir = child_env_global,
                  output_file = "COMP_GTA_FishStat_major_tunas", output_dir = getwd())

rmarkdown::render(system.file("rmd/comparison.Rmd", package = "CWP.dataset"),
                  envir = child_env_global,
                  output_format = "bookdown::pdf_document2",
                  output_file = "COMP_GTA_FishStat_major_tunas", output_dir = getwd())


for (species_name_ in c("Skipjack tuna"     ,  
                        "Yellowfin tuna"    ,   
                        "Albacore"            ,
                        "Bigeye tuna"     ,      
                        "Swordfish")) {

  test_major_tunas <- CWP.dataset::comprehensive_cwp_dataframe_analysis(parameter_init = CAPTURED_filtered , 
                                                                        parameter_final = NCD_filtered,
                                                                        parameter_filtering = list(species_name = species_name_),
                                                                        parameter_time_dimension = c("year"), 
                                                                        parameter_colnames_to_keep = c("species_name", 
                                                                                                       "fishing_fleet_label", "measurement_unit", 
                                                                                                       "year", "measurement_value", "ocean_basin"),
                                                                        print_map = FALSE, 
                                                                        parameter_titre_dataset_1 = "FishStatJ", 
                                                                        parameter_titre_dataset_2 = "GTA", topnumber = 10)
  
  test_major_tunas$combined_summary_histogram <- NULL
  test_major_tunas$other_dimension_analysis_list <- NULL
  test_major_tunas$compare_strata_differences_list$number_init_column_final_column <- test_major_tunas$compare_strata_differences_list$number_init_column_final_column %>% 
    dplyr::filter(!(" " %in% c("Number of gridtype", 
                               "Number of measurement_unit", 
                               "Number of ocean_basin"
    )))
  
  child_env_global = new.env()
  
  list2env(test_major_tunas, envir = child_env_global)
  child_env_global$step_title_t_f <- FALSE
  child_env_global$child_header <- ""
  rmarkdown::render(system.file("rmd/comparison.Rmd", package = "CWP.dataset"),
                    envir = child_env_global,
                    output_format = "bookdown::pdf_document2",
                    output_file = paste0("COMP_GTA_FishStat", species_name_), output_dir = getwd())
  
}


for (ocean_basin_ in unique(NCD_filtered$ocean_basin)) {
  
  # Pour supprimer aussi les points et les espaces
  for (species_name_ in c("Skipjack tuna"     ,  
                          "Yellowfin tuna"    ,   
                          "Albacore"            ,
                          "Bigeye tuna"     ,      
                          "Swordfish")) {
  test_major_tunas <- CWP.dataset::comprehensive_cwp_dataframe_analysis(parameter_init = CAPTURED_filtered , 
                                                                        parameter_final = NCD_filtered,
                                                                        parameter_filtering = list(ocean_basin = ocean_basin_, 
                                                                                                   species_name = species_name_),
                                                                        parameter_time_dimension = c("year"), 
                                                                        parameter_colnames_to_keep = c("species_name", 
                                                                                                       "fishing_fleet_label", "measurement_unit", 
                                                                                                       "year", "measurement_value", "ocean_basin"),
                                                                        print_map = FALSE, 
                                                                        parameter_titre_dataset_1 = "FishStatJ", 
                                                                        parameter_titre_dataset_2 = "GTA", topnumber = 10, 
                                                                        coverage = TRUE)
  
  test_major_tunas$combined_summary_histogram <- NULL
  test_major_tunas$other_dimension_analysis_list <- NULL
  test_major_tunas$compare_strata_differences_list$number_init_column_final_column <- test_major_tunas$compare_strata_differences_list$number_init_column_final_column %>% 
    dplyr::filter(!(" " %in% c("Number of gridtype", 
                               "Number of measurement_unit", 
                               "Number of ocean_basin", "Number of species_name"
                               )))
  
  ocean_basin_cleaned_ <- str_remove_all(ocean_basin_, "[-_/\\. ]")
  
  child_env_global = new.env()
  
  list2env(test_major_tunas, envir = child_env_global)
  child_env_global$step_title_t_f <- FALSE
  child_env_global$child_header <- ""
  rmarkdown::render(system.file("rmd/comparison.Rmd", package = "CWP.dataset"),
                    envir = child_env_global,
                    output_format = "bookdown::pdf_document2",
                    output_file = paste0("COMP_GTA_FishStat", ocean_basin_cleaned_, species_name_), output_dir = getwd())
  }
  
}

 for (ocean_basin_ in unique(NCD_filtered$ocean_basin)) {
  
  test_major_tunas <- CWP.dataset::comprehensive_cwp_dataframe_analysis(parameter_init = parameter_init , 
                                                                        parameter_final = parameter_final,
                                                                        parameter_filtering = list(ocean_basin = ocean_basin_, 
                                                                                                   species = c("YFT", "SKJ", "ALB", "BET", "SWO")),
                                                                        parameter_time_dimension = c("year"), 
                                                                        parameter_colnames_to_keep = c("species","species_name", 
                                                                                                       "fishing_fleet_label", "measurement_unit", 
                                                                                                       "year", "measurement_value", "ocean_basin"),
                                                                        print_map = FALSE, 
                                                                        parameter_titre_dataset_1 = "FishStatJ", 
                                                                        parameter_titre_dataset_2 = "GTA", topnumber = 10)
  
  test_major_tunas$combined_summary_histogram <- NULL
  test_major_tunas$other_dimension_analysis_list <- NULL
  test_major_tunas$compare_strata_differences_list$number_init_column_final_column <- test_major_tunas$compare_strata_differences_list$number_init_column_final_column %>% 
    dplyr::filter(!(" " %in% c("Number of gridtype", 
                               "Number of measurement_unit", 
                               "Number of ocean_basin"
    )))
  
  child_env_global = new.env()
  
  list2env(test_major_tunas, envir = child_env_global)
  child_env_global$step_title_t_f <- FALSE
  child_env_global$child_header <- ""
  rmarkdown::render(system.file("rmd/comparison.Rmd", package = "CWP.dataset"),
                    envir = child_env_global,
                    output_format = "bookdown::pdf_document2",
                    output_file = paste0("COMP_GTA_FishStat", ocean_basin_), output_dir = getwd())
  
}
# Comparison_big ----------------------------------------------------------


CAPTURED_filtered$gear_type <- "UNK"
cl_species_level0 <- read_csv("inputs/codelists/cl_species_level0.csv")

require(dplyr)
fishstatdataset_filtered <- CAPTURED_filtered

# cl_country <- read_csv(here("inputs/codelists/cl_fishing_fleet_with_country.csv"))


# COUNTRIES_SF_without_geom <- sf::st_drop_geometry(COUNTRIES_SF %>% dplyr::select(-geom))
# country_to_territ_codes <- COUNTRIES_SF_without_geom %>% filter(ISO3CD != ISO_3) %>% 
#   dplyr::select(country_code = ISO_3, territory_code = ISO3CD)
# 
# fishstatdataset_filtered_mapped_country <- fishstatdataset_filtered %>%
#   left_join(country_to_territ_codes %>% distinct(), by = c("fishing_fleet" = "territory_code")) %>% 
#   mutate(country_code = ifelse(is.na(country_code), fishing_fleet, country_code))


NC_country <- NCD 


fishstatdataset_filtered_mapped_country_groupped <- fishstatdataset_filtered %>% group_by(species, year) %>%
  summarise(measurement_value = sum(measurement_value))

NC_RAW_groupped <- NC_country %>% group_by(species, year) %>%
  summarise(measurement_value = sum(measurement_value)) 

NC_RAW_groupped$dataset <- "NC"
fishstatdataset_filtered_mapped_country_groupped$dataset <- "FishStat"


comp_NC_FS <- rbind(NC_RAW_groupped, fishstatdataset_filtered_mapped_country_groupped)
plot_list <- list()  # Use a different variable name to avoid overwriting 'list'

library(ggplot2)

comp_NC_FS <- rbind(NC_RAW_groupped, fishstatdataset_filtered_mapped_country_groupped)

# Create a directory to store the saved plots
if (!dir.exists(here("outputs/charts/plotsFS_NC"))) {
  dir.create("outputs/charts/plotsFS_NC")
}

for (species_name in unique(comp_NC_FS$species)) {
  # Create a ggplot for the current species
  p <- ggplot(comp_NC_FS %>% dplyr::filter(species == species_name)) +
    aes(
      x = year,
      y = measurement_value,
      colour = dataset,
      group = species
    ) +
    geom_point(shape = "circle", size = 1.5) +
    scale_color_hue(direction = 1) +
    theme_minimal()
  
  # Define the filename for the saved plot
  filename <- paste0("outputs/charts/plotsFS_NC/", gsub(" ", "_",  species_name), "_plot.png")
  
  # Save the ggplot to a file
  ggsave(filename, p, width = 8, height = 6)  # Adjust width and height as needed
}


#### Comparison detailled

NC_RAW_tidy_comp <- NC_country 


NC_informed <- NC_RAW_tidy_comp %>% dplyr::ungroup()
FS_informed <- fishstatdataset_filtered_mapped_country_groupped %>% dplyr::ungroup()

not_commun_year <- rbind(NC_informed %>% dplyr::select(year) %>% distinct()%>% 
                           anti_join(FS_informed %>% dplyr::select(year) %>% distinct(), by =c ("year")) %>% 
                           dplyr::select(year) %>% distinct() %>% mutate(onlyin = "NC"), 
                         FS_informed %>% dplyr::select(year) %>% distinct()%>% 
                           anti_join(NC_informed %>% dplyr::select(year) %>% distinct(), by =c ("year")) %>% 
                           dplyr::select(year) %>% distinct()%>% mutate(onlyin = "FS"))

commun_time <- NC_informed %>% dplyr::select(year) %>% distinct()%>% 
  inner_join(FS_informed %>% dplyr::select(year) %>% distinct(), by =c ("year")) %>% 
  dplyr::select(year) %>% distinct()

commun_species <- NC_informed %>% dplyr::select(species) %>% distinct()%>% 
  inner_join(FS_informed %>% dplyr::select(species) %>% distinct(), by =c ("species")) %>% 
  dplyr::select(species) %>% distinct()

not_commun_species <- rbind(NC_informed %>% dplyr::group_by(species) %>% 
                              summarise(measurement_value =sum(measurement_value))%>% 
                              anti_join(FS_informed %>% dplyr::group_by(species)%>% 
                                          summarise(measurement_value =sum(measurement_value)) , by =c ("species"))%>%
                              mutate(onlyin = "NC"), 
                            FS_informed %>% dplyr::group_by(species) %>% 
                              summarise(measurement_value =sum(measurement_value)) %>% 
                              anti_join(NC_informed %>% dplyr::group_by(species)%>% 
                                          summarise(measurement_value =sum(measurement_value)), by =c ("species")) %>% 
                              mutate(onlyin = "FS"))



# saveRDS( list(year = not_commun_year, species =not_commun_species),
# here("inputs/data/comparison_Fishstat_NC/notcommuntime_species.rds"))


# We keep only the species and time where this data for both of the datasets

NC_informedcomp <- NC_informed %>% inner_join(commun_species) %>% inner_join(commun_time)
FS_informedcomp <- FS_informed%>% inner_join(commun_species) %>% inner_join(commun_time)

dir.create(here("inputs/data/comparison_Fishstat_NC/Fishstat"), recursive = TRUE)
dir.create(here("inputs/data/comparison_Fishstat_NC/NC"), recursive = TRUE)
saveRDS(FS_informed , here("inputs/data/comparison_Fishstat_NC/Fishstat/rds.rds"))
saveRDS(NC_informed, here("inputs/data/comparison_Fishstat_NC/NC/rds.rds"))

dir.create(here("inputs/data/comparison_Fishstat_NC/Fishstatfiltered"), recursive = TRUE)
dir.create(here("inputs/data/comparison_Fishstat_NC/NCfiltered"), recursive = TRUE)
saveRDS(FS_informedcomp , here("inputs/data/comparison_Fishstat_NC/Fishstatfiltered/rds.rds"))
saveRDS(NC_informedcomp , here("inputs/data/comparison_Fishstat_NC/NCfiltered/rds.rds"))



NC_informedcomp$Source <- "NC"
FS_informedcomp$Source <- "FS"


FS_informedcomp <- FS_informedcomp %>% dplyr::select(any_of(colnames(NC_informedcomp)))
NC_informedcomp <- NC_informedcomp %>% dplyr::select(any_of(colnames(FS_informedcomp)))

FS_NC <- rbind(NC_informedcomp, FS_informedcomp) %>%
  dplyr::group_by(year)
FS_NC$measurement_unit <- 't'
# Step 3: Calculate the total difference (t) by year and source authority
summary_data <- FS_NC %>%
  dplyr::summarise(total_difference = (sum(measurement_value[measurement_unit == "t" & Source == "FS"]) -
                                  sum(measurement_value[measurement_unit == "t" & Source == "NC"])) / 10000)

# Create a new column for fill color based on the sign of total_difference
summary_data <- summary_data %>%
  mutate(fill_color = ifelse(total_difference > 0, "NC < FS", "NC > FS"))

# Create the figure with the specified fill colors
gg <- ggplot(summary_data, aes(x = year, y = total_difference, fill = fill_color)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("NC > FS" = "red", "NC < FS" = "blue")) +
  labs(title = "Total Difference (t) by Year between Catches of Tuna and Tuna-Like Species",
       x = "Year",
       y = "Total Difference (x10 000 t)") +
  theme_minimal() +
  theme(legend.title = element_blank())

ggsave(here("outputs/charts/plotsFS_NC/diff_by_year_FS_NC_filtered.png"), plot = gg, width = 8, height = 6, dpi = 300)



# Comp_by_species_bassin --------------------------------------------------

Fishstat <- CAPTURED %>%
  dplyr::select(species, year, measurement_value, ocean_basin) %>%
  group_by(species, year, ocean_basin) %>%
  summarise(total_value = sum(measurement_value, na.rm = TRUE))

NominalCatch <- NCD %>%
  dplyr::select(species, year, measurement_value, ocean_basin) %>%
  group_by(species, year, ocean_basin) %>%
  summarise(total_value = sum(measurement_value, na.rm = TRUE))

# Merging datasets based on species and year and ocean
comparison <- left_join(Fishstat, NominalCatch, 
                        by = c("species", "year", "ocean_basin"),
                        suffix = c("_Fishstat", "_NC"))

# Merging datasets based on species and year
Fishstat_groupped <- Fishstat %>%
  group_by(species, year) %>%
  summarise(total_value = sum(total_value, na.rm = TRUE))

NominalCatch_groupped <- NominalCatch %>%
  group_by(species, year) %>%
  summarise(total_value = sum(total_value, na.rm = TRUE))

# Merging datasets based on species and year
comparison_groupped <- dplyr::left_join(Fishstat_groupped, NominalCatch_groupped, 
                                 by = c("species", "year"),
                                 suffix = c("_Fishstat", "_NC"))


# Calculating differences
comparison_groupped$difference <- comparison_groupped$total_value_NC - comparison_groupped$total_value_Fishstat
comparison$difference <- comparison$total_value_NC - comparison$total_value_Fishstat


if (!dir.exists(here("outputs", "charts", "comparison_FS_NC_time_by_species"))) {
  dir.create(here("outputs", "charts", "comparison_FS_NC_time_by_species"), recursive = TRUE)
}

species_list <- unique(FS_NC$species)
ocean_basins <- unique(FS_NC$ocean_basin) 

for(spec in species_list) {

  # General plot for each species
  tmp_data_general <- filter(comparison_groupped, species == spec)
  total_diff_general <- sum(tmp_data_general$difference, na.rm = TRUE)
  higher_general <- ifelse(total_diff_general>0, "Nominal Catch", "Fishstat")
  legend_title_general <- paste("Dataset with Higher Value is ", higher_general, "\nTotal Difference:", round(total_diff_general))

  p_general <- ggplot(tmp_data_general, aes(x = year, y = difference, fill = difference > 0)) +
    geom_bar(stat="identity") +
    scale_fill_manual(values=c("red", "blue"),
                      name=legend_title_general,
                      breaks=c(TRUE, FALSE),
                      labels=c("Nominal Catch", "Fishstat")) +
    labs(title=paste("Difference in Measurement Value for", spec),
         y="Difference (Nominal Catch - Fishstat)",
         x="Measurement Type") +
    theme_minimal() +
    theme(legend.title = element_text(size=10))


  # Save the general plot
  ggsave(filename = here("outputs", "charts", "comparison_FS_NC_time_by_species", paste0(spec, "_general_comparison_plot.png")),
         plot = p_general, width=10, height=7)
  gc()

  if(spec == "SKJ"){
    # Ocean-specific plots
    for(ocean in ocean_basins) {
      tmp_data_ocean <- filter(comparison, species == spec & ocean_basin == ocean)

      if(nrow(tmp_data_ocean) > 0) {
        total_diff_ocean <- sum(tmp_data_ocean$difference, na.rm = TRUE)
        higher_ocean <- ifelse(total_diff_ocean>0, "Nominal Catch", "Fishstat")
        legend_title_ocean <- paste("Dataset with Higher Value is ", higher_ocean, "\nTotal Difference:", round(total_diff_ocean))

        p_ocean <- ggplot(tmp_data_ocean, aes(x = year, y = difference, fill = difference > 0)) +
          geom_bar(stat="identity") +
          scale_fill_manual(values=c("red", "blue"),
                            name=legend_title_ocean,
                            breaks=c(TRUE, FALSE),
                            labels=c("Nominal Catch", "Fishstat")) +
          labs(title=paste("Difference in Measurement Value for", spec, "in", ocean),
               y="Difference (Nominal Catch - Fishstat)",
               x="Measurement Type") +
          facet_wrap(~ ocean_basin) +
          theme_minimal() +
          theme(legend.title = element_text(size=10))


        # Save the ocean-specific plot
        ggsave(filename = here("outputs", "charts", "comparison_FS_NC_time_by_species/SKJ_by_ocean/" , paste0(spec, "_", ocean, "_comparison_plot.png")),
               plot = p_ocean, width=10, height=7)
        gc()
      }
    }
  }
}


# Compute the sum of the difference for each species
species_summary <- comparison %>%
  dplyr::group_by(species) %>%
  dplyr::summarise(total_difference = sum(difference, na.rm = TRUE))

# Count how many species have a higher total value in each dataset
Fishstat_higher <- sum(species_summary$total_difference < 0)
NC_higher <- sum(species_summary$total_difference > 0)


# Filter species with higher Fishstat values
Fishstat_higher_species <- species_summary %>%
  filter(total_difference < 0) %>%
  dplyr::select(species)


# Filter species with higher NominalCatch values
NC_higher_species <- species_summary %>%
  dplyr::filter(total_difference > 0) %>%
  dplyr::select(species)




