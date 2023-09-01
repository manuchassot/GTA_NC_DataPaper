# Total capture production
if(!file.exists(here("inputs/data/comparison_Fishstat_NC/Capture_Quantity.csv"))){
  
# Define the URL of the file you want to download
file_url <- "https://www.fao.org/fishery/static/Data/Capture_2023.1.1.zip"

# Define the destination folder where you want to save the unzipped file
dest_folder <- "inputs/data/comparison_Fishstat_NC/"

# Create the destination folder if it doesn't exist
if (!file.exists(dest_folder)) {
  dir.create(dest_folder)
}

# Set the working directory to the destination folder
setwd(dest_folder)

# Download the ZIP file from the URL
download.file(file_url, "Capture_2023.1.1.zip")

# Unzip the downloaded file
unzip("Capture_2023.1.1.zip")

# Set the working directory back to the original location
setwd(here::here())
} else {
  fishstatdataset <- read_csv(here("inputs/data/comparison_Fishstat_NC/Capture_Quantity.csv"))
  fishingfleet_FS <- read_csv(here("inputs/data/comparison_Fishstat_NC/CL_FI_COUNTRY_GROUPS.csv"))
  }
