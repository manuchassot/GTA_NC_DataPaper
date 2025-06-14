# Run the R scripts
# Load and save library environment
source("initialisation/90_LIBS.R")
setwd("./initialisation/")

source("00_CORE.R")
setwd("..")

# DOCX
render(here("rmd/00_ALL.Rmd"), 
       output_dir    = "outputs/", 
       output_file   = "GTA_Nominal_Catch_Data_Paper.docx"
)

rmarkdown::render("Comp_FSJ_GTA.Rmd", 
                  output_format = "bookdown::pdf_document2", output_dir = getwd(), output_file = "Recap_compFSJ_GTA", envir = .GlobalEnv)