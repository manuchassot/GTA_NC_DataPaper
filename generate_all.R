# # Install/initialise/restore library backup
# if(!require(renv)){
#   install.packages("renv")
#   suppressPackageStartupMessages(library(renv, quietly = TRUE))
# }

# Run the R scripts 
setwd("./initialisation/")
source("00_CORE.R")
setwd("..")

# Initialise/restore library backup
#renv::init()

# Restore library backup
#renv::restore()

# DOCX
# see YAML params here: https://davidgohel.github.io/officedown/reference/rdocx_document.html
render("rmd/00_ALL.Rmd", 
       output_dir    = "outputs/", 
       output_file   = "GTA_Nominal_Catch_Data_Paper.docx"
)
