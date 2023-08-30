
install.packages("renv")
renv::restore()
# Libraries
library(officedown)
library(officer)
library(rmarkdown)


# Run the R scripts 
source(here("initialisation/00_CORE.R"))

# DOCX
# see YAML params here: https://davidgohel.github.io/officedown/reference/rdocx_document.html
render("rmd/00_ALL.Rmd", 
       output_dir    = "outputs/", 
       output_file   = "GTA_Nominal_Catch_Data_Paper.docx"
)
