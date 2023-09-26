print("Loading the code lists for FSJ data...")

# Read the code lists
CL_COUNTRIES = read_csv("../inputs/data/FSJ/CL_FI_COUNTRY_GROUPS.csv") %>% 
  dplyr::select(UN_CODE = UN_Code, COUNTRY_CODE = ISO3_Code, COUNTRY = Name_En) %>% 
  mutate(UN_CODE = as.integer(UN_CODE))
CL_COUNTRIES <- as.data.table(CL_COUNTRIES)

CL_SPECIES = fread("../inputs/data/FSJ/CL_FI_SPECIES_GROUPS.csv", encoding = "UTF-8")[, .(SPECIES_CODE = `3A_Code`, SPECIES = Name_En, SPECIES_SCIENTIFIC = Scientific_Name, ISSCAAP_NAME = ISSCAAP_Group_En)]

CL_AREAS = fread("../inputs/data/FSJ/CL_FI_WATERAREA_GROUPS.csv")[, .(FISHING_GROUND_CODE = Code, FISHING_GROUND = Name_En)]

CL_UNITS = fread("../inputs/data/FSJ/FSJ_UNIT.csv")[, .(MEASUREMENT_CODE = Code, MEASUREMENT_NAME = Name_En)]

print("FSJ code lists loaded!")
