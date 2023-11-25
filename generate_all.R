# Run the R scripts
setwd("./initialisation/")
source("00_CORE.R")
setwd("..")

# DOCX
# see YAML params here: https://davidgohel.github.io/officedown/reference/rdocx_document.html
render(here("rmd/00_ALL.Rmd"), 
       output_dir    = "outputs/", 
       output_file   = "GTA_Nominal_Catch_Data_Paper.docx"
)
