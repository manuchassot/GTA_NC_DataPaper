# Prevents formatting of numbers using scientific notation
options(scipen = 99999)

# Load and save library environment
source("90_LIBS.R")

# Includes defaults and helper functions
source("91_COLOR_LAYOUT.R")
source("92_MAP_PACIFIC_PROJECTION_FUNCTION.R")

# Download/load code lists (8 files expected)
if(!length(list.files(path = "../inputs/codelists/", pattern = "csv")) == 8)
  source("00.1_DOWNLOAD_CODE_LISTS.R")
  source("01.1_LOAD_CODE_LISTS.R")

# Download/load mappings (17 files expected)
if(!length(list.files(path = "../inputs/mappings/", pattern = "csv")) == 17)
  source("00.2_DOWNLOAD_MAPPINGS.R")
  source("01.2_LOAD_MAPPINGS.R")

# Download/load spatial layers
if(!file.exists("../inputs/spatial_layers/SpatialLayers.RData"))
  source("00.3_DOWNLOAD_SPATIAL_LAYERS.R")
  source("01.3_LOAD_SPATIAL_LAYERS.R")

# Load tuna RFMO catches
source("02_LOAD_NC_DATA.R")

# Load FAO global capture production database
source("03_LOAD_FSJDATA.R")



