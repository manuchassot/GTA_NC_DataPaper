# Prevents formatting of numbers using scientific notation
options(scipen = 99999)

# Includes defaults and helper functions
source("90_LIBS.R")
source("91_COLOR_LAYOUT.R")
source("92_MAP_PACIFIC_PROJECTION_FUNCTION.R")

# Core charts and tables
#source("01.1_DOWNLOAD_CODE_LISTS.R")
#source("01.2_DOWNLOAD_MAPPINGS.R")
source("01.3_LOAD_CODE_LIST_MAPPINGS.R")
source("01.4_LOAD_SPATIAL_LAYERS.R")
source("02_LOAD_NC_DATA.R")
