# Creating mapping from Fishstat to GTA in order to be able to compare them if needed before comparing countries

cl_country <- read_csv(here("inputs/codelists/cl_fishing_fleet_with_country.csv"))

# NC_RAW_label <- NC_RAW %>% dplyr::inner_join(cl_country %>% dplyr::select(code, label), by = c("fishing_fleet" = "code"))


# FS <- fishstatdataset_filtered  %>% dplyr::select(country, ISO3_Code) %>% distinct()
# NC <- NC_RAW %>% dplyr::select(fishing_fleet) %>% distinct() %>% dplyr::left_join(cl_country %>% dplyr::select(label, country, code), by = c("fishing_fleet" = "code"))
# 
# diff_FS_NC_first <- full_join(FS, NC, by = c("ISO3_Code" = "fishing_fleet")) 
# diff_FS_NC_first_na <- diff_FS_NC_first %>% filter(is.na(country.x) | is.na(label)| is.na(ISO3_Code))


library(readr)
codelist_mapping_FishstatJ_GTA <- read_delim("inputs/mappings/codelist_mapping_FishstatJ_GTA.csv", 
                                             delim = "\t", escape_double = FALSE, 
                                             trim_ws = TRUE)


mapping_FS_NC <- left_join(codelist_mapping_FishstatJ_GTA, cl_country %>%
                             dplyr::select(label, code) %>%
                             distinct(), by = c("Country_GTA" = "label")) %>% 
  mutate(fishing_fleet = ifelse(!is.na(fishing_fleet), fishing_fleet, code)) %>% dplyr::select(-code)


fwrite(mapping_FS_NC, here("inputs/mappings/mapping_FS_NC.csv"))
