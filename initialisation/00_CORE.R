# Prevents formatting of numbers using scientific notation
options(scipen = 99999)

# Load and save library environment
source("90_LIBS.R")

# Includes defaults and helper functions
source("91_COLOR_LAYOUT.R")
source("92_MAP_PACIFIC_PROJECTION_FUNCTION.R")

# Download/load GTA code lists (8 files expected)
if(!length(list.files(path = "../inputs/codelists/", pattern = "csv")) >= 8)
  source("00.1_DOWNLOAD_GTA_CODE_LISTS.R")
source("01.1_LOAD_GTA_CODE_LISTS.R")

# Download/load GTA mappings (17 files expected)
if(!length(list.files(path = "../inputs/mappings/", pattern = "csv")) >= 17)
  source("00.2_DOWNLOAD_GTA_MAPPINGS.R")
  source("01.2_LOAD_GTA_MAPPINGS.R")

# Download/load GTA spatial layers
if(!file.exists("../inputs/spatial_layers/SpatialLayers.RData"))
  source("00.3_DOWNLOAD_GTA_SPATIAL_LAYERS.R")
  source("01.3_LOAD_GTA_SPATIAL_LAYERS.R")

# Load tuna RFMO catches
source("02_LOAD_NC_DATA.R")

# Download/load FAO FishstatJ (FSJ) code lists
# Available from here: https://www.fao.org/fishery/statistics-query/en/capture/capture_quantity
if(!file.exists("../inputs/data/FSJ/Capture_Quantity.csv")){
  temp = tempfile(tmpdir = "../inputs/data/FSJ/")
  download.file("https://www.fao.org/fishery/static/Data/Capture_2023.1.1.zip", temp)
  unzip(temp, exdir = "../inputs/data/FSJ/")
  unlink(temp)
}

source("03.1_LOAD_FSJ_CODE_LISTS.R")
source("03.2_LOAD_FSJ_DATA.R")
source("03.3_LOAD_FSJ_MAPPING.R")

# Describe the data
#source("04_RFMO_MAPS.R")
source("05_NC_CHARTS.R")


