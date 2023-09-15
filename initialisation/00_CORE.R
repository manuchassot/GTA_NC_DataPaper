# Prevents formatting of numbers using scientific notation
options(scipen = 99999)

# Load and save library environment
source("90_LIBS.R")

# Includes defaults and helper functions
source("91_COLOR_LAYOUT.R")
source("92_MAP_PACIFIC_PROJECTION_FUNCTION.R")

# Core charts and tables
# To run the first time so as to get most recent files
#source("00.1_DOWNLOAD_CODE_LISTS.R")
#source("00.2_DOWNLOAD_MAPPINGS.R")
#source("00.3_DOWNLOAD_SPATIAL_LAYERS.R")
source("01.3_LOAD_CODE_LIST_MAPPINGS.R")
source("01.4_LOAD_SPATIAL_LAYERS.R")
source("02_LOAD_NC_DATA.R")
