
if(!require(renv)){
  install.packages("renv")
  require(renv)
  renv::activate()
  renv::init()
}
renv::restore()
# Libraries
library(officedown)
library(officer)
library(rmarkdown)


# Run the R scripts 
source(here("initialisation/00_CORE.R"))

# DOCX
# see YAML params here: https://davidgohel.github.io/officedown/reference/rdocx_document.html
render(here("rmd/00_ALL.Rmd"), 
       output_dir    = here("outputs/"), 
       output_file   = here("GTA_Nominal_Catch_Data_Paper.docx")
)
