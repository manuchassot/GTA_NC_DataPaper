# Prevents formatting of numbers using scientific notation
options(scipen = 99999)
require(here)
# Includes defaults and helper functions
source(here("initialisation/90_LIBS.R"))
source(here("initialisation/91_COLOR_LAYOUT.R"))
source(here("initialisation/92_MAP_PACIFIC_PROJECTION_FUNCTION.R"))

# Core charts and tables
# To run the first time so as to get most recent files
# source(here("initialisation/00.1_DOWNLOAD_CODE_LISTS.R"))
# source(here("initialisation/00.2_DOWNLOAD_MAPPINGS.R"))
# source(here("initialisation/00.3_DOWNLOAD_SPATIAL_LAYERS.R"))
source(here("initialisation/01.3_LOAD_CODE_LIST_MAPPINGS.R"))
source(here("initialisation/01.4_LOAD_SPATIAL_LAYERS.R"))
source(here("initialisation/02_LOAD_NC_DATA.R"))

