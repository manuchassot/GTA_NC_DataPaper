print("Downloading spatial layers from FAO geoserver...")

# SOURCE: OGC ####
WFS = WFSClient$new(url = "https://www.fao.org/fishery/geoserver/wfs", serviceVersion = "1.0.0", logger = "INFO")

## COUNTRIES ####

# Countries (used by FIRMS to intersect the CWP grids)
COUNTRIES_SF = st_make_valid(WFS$getFeatures("fifao:country_bounds"))

## t-RFMOS ####

# Load the files
CCSBT_SF = WFS$getFeatures("rfb:RFB_CCSBT")
ICCAT_SF = WFS$getFeatures("rfb:RFB_ICCAT")
IATTC_SF = WFS$getFeatures("rfb:RFB_IATTC")
IOTC_SF  = WFS$getFeatures("rfb:RFB_IOTC")
WCPFC_SF = WFS$getFeatures("rfb:RFB_WCPFC")

# Merge the files in one single object
TRFMO    = rbindlist(list(CCSBT_SF, ICCAT_SF, IATTC_SF, IOTC_SF, WCPFC_SF))
TRFMO_SF = st_sf(TRFMO)

continent = WFS$getFeatures("fifao:UN_CONTINENT2")

# Save the spatial layers

get_wfs_data <- function(url= "https://www.fao.org/fishery/geoserver/wfs", 
                         version = "1.0.0", 
                         layer_name, output_dir = "data",logger = "INFO") {
  # create output directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir)
  }
  
  # define file paths
  shapefile_path <- file.path(output_dir, paste0(layer_name, ".shp"))
  
  # check if shapefile already exists
  if (file.exists(shapefile_path)) {
    message(paste0("Shapefile for layer '", layer_name, "' already exists, skipping download."))
    return(sf::st_read(shapefile_path) %>% rename(the_geom = geometry))
  }
  
  cwp_sf <- WFS$getFeatures(layer_name)
  cwp <- as.data.table(cwp_sf)
  if("gml_id.1" %in% colnames(cwp)){
    cwp <- cwp %>% select(-"gml_id.1")
  }
  
  # save data as shapefile
  sf::st_write(cwp, shapefile_path, driver = "ESRI Shapefile")
  
  # return data
  return(cwp)
}

CWP11_ERASED <- get_wfs_data(layer_name = "cwp:cwp-grid-map-1deg_x_1deg_erased")
CWP55_ERASED <- get_wfs_data(layer_name = "cwp:cwp-grid-map-5deg_x_5deg_erased")
CWP1010_ERASED <- get_wfs_data(layer_name = "cwp:cwp-grid-map-10deg_x_10deg_erased")
CWP2020_ERASED <- get_wfs_data(layer_name = "cwp:cwp-grid-map-20deg_x_20deg_erased")
CWP3030_ERASED <- get_wfs_data(layer_name = "cwp:cwp-grid-map-30deg_x_30deg_erased")

# CWP_GRIDS <- rbindlist(list(CWP11, CWP55, CWP1010, CWP2020, CWP3030))
shapefile.fix <- rbindlist(list(CWP11_ERASED, CWP55_ERASED, CWP1010_ERASED, CWP2020_ERASED, CWP3030_ERASED))
rm("CWP11_ERASED", "CWP55_ERASED", "CWP1010_ERASED", "CWP2020_ERASED", "CWP3030_ERASED")
save.image(file =here("inputs/spatial_layers/SpatialLayers.RData"))


save(list = c("COUNTRIES_SF", "CCSBT_SF", "ICCAT_SF", "IATTC_SF", "IOTC_SF", "WCPFC_SF", "TRFMO_SF"), file = "../inputs/spatial_layers/SpatialLayers.RData")

print("Spatial layers downloaded from FAO geoserver and saved as RData!")


