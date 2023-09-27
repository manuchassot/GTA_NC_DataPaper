print("Loading external libraries...")

# Install/load pacman
if(!require(pacman)){
  install.packages("pacman")
  suppressPackageStartupMessages(library(pacman, quietly = TRUE))
}

# Install/load libraries required for analysis
# Load pacman
if (!requireNamespace("pacman", quietly = TRUE)) {
  install.packages("pacman")
}

# Define the list of required packages
required_packages <- c("tidyverse", "ggpubr", "openxlsx", "data.table", 
                       "ggsci", "colorspace", "sf", "rnaturalearth", 
                       "rnaturalearthdata", "ows4R", "RColorBrewer", 
                       "raster", "rnaturalearth", "cmocean", "magrittr", 
                       "officedown", "officer", "rmarkdown", "renv", 
                       "readr", "here", "flextable", "webshot", "usethis", 
                       "ows4R", "sp", "data.table", "flextable", "readtext", 
                       "sf", "dplyr", "stringr", "tibble", "bookdown", 
                       "knitr", "purrr", "readxl", "base", "remotes", 
                       "utils", "DBI", "odbc", "rlang", "kableExtra", 
                       "readr", "tidyr", "ggplot2", "stats", "RColorBrewer", 
                       "cowplot", "RPostgreSQL", "curl", "officer", "gdata", 
                       "tidyr", "knitr", "tmap")

# Use pacman to load and install if not present
pacman::p_load(char = required_packages)

# set theme for all charts
ggplot2::theme_set(theme_bw())

print("External libraries loaded!")
