print("Loading external libraries...")

# Install/load pacman
if(!require(pacman)){
  install.packages("pacman")
  suppressPackageStartupMessages(library(pacman, quietly = TRUE))
}

# Install/load libraries required for analysis
pacman::p_load("tidyverse",
               "ggpubr", 
               "openxlsx", 
               "data.table", 
               "ggsci", 
               "colorspace", 
               "sf", 
               "rnaturalearth", 
               "rnaturalearthdata", 
               "ows4R", 
               "RColorBrewer", 
               "raster", 
               "rnaturalearth", 
               "cmocean", 
               "magrittr", 
               "officedown", 
               "officer", 
               "rmarkdown", 
               "renv", 
               "readr", 
               "here", 
               "flextable")

# set theme for all charts
ggplot2::theme_set(theme_bw())

print("External libraries loaded!")
