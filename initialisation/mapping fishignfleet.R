# mapping fishignfleet 


fishstatdataset_filtered <- dplyr::semi_join(fishstatdataset, 
                                             cl_species_level0, by = c("SPECIES.ALPHA_3_CODE" = "code")) %>% 
  dplyr::inner_join(fishingfleet_FS %>% dplyr::select(c(UN_Code, Name_En, ISO3_Code)), by =c ("COUNTRY.UN_CODE" = "UN_Code")) %>% 
  dplyr::rename(country = Name_En, species = SPECIES.ALPHA_3_CODE, year = PERIOD, geographic_identifier = AREA.CODE,
                fishing_fleet = COUNTRY.UN_CODE, measurement_value= VALUE) %>% 
  dplyr::select(-c(STATUS, MEASURE)) %>% 
  dplyr::mutate(measurement_unit = "t")



FS <- fishstatdataset_filtered  %>% dplyr::select(country, ISO3_Code) %>% distinct()
NC <- NC_RAW %>% dplyr::select(fishing_fleet) %>% distinct() %>% dplyr::left_join(cl_country %>% dplyr::select(label, country, code), by = c("fishing_fleet" = "code"))

diff_FS_NC_first <- full_join(FS, NC, by = c("ISO3_Code" = "fishing_fleet")) 
diff_FS_NC_first_na <- diff_FS_NC_first %>% filter(is.na(country.x) | is.na(label)| is.na(ISO3_Code))


unknown_fishing_fleetinNC <- NC %>% filter(is.na(label))

FS2 <- FS  %>% distinct() %>% dplyr::left_join(cl_country %>% dplyr::select(label, country, code), by = c("ISO3_Code" = "code"))
unknown_fishing_fleetinFS <- FS2 %>% filter(is.na(label))



FS_diff_NC <- full_join(FS, NC, by =c ("ISO3_Code" = "fishing_fleet"))





library(readr)
codelist_mapping_FishstatJ_GTA <- read_delim("inputs/mappings/codelist_mapping_FishstatJ_GTA.csv", 
                                             delim = ";", escape_double = FALSE, trim_ws = TRUE)

mapping_FS_NC <- left_join(codelist_mapping_FishstatJ_GTA, NC_RAW_label %>% dplyr::select(label, fishing_fleet) %>% distinct(), by = c("Country_GTA" = "label"))

fwrite(mapping_FS_NC, here("inputs/mappings/mapping_FS_NC.csv"))
