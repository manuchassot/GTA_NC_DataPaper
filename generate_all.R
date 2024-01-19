# Run the R scripts
setwd("./initialisation/")
source("00_CORE.R")
setwd("..")

# DOCX
render(here("rmd/00_ALL.Rmd"), 
       output_dir    = "outputs/", 
       output_file   = "GTA_Nominal_Catch_Data_Paper.docx"
)
