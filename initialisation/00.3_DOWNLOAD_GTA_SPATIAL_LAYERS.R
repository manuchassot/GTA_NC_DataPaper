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

# Save the spatial layers
save(list = c("COUNTRIES_SF", "CCSBT_SF", "ICCAT_SF", "IATTC_SF", "IOTC_SF", "WCPFC_SF", "TRFMO_SF"), file = "../inputs/spatial_layers/SpatialLayers.RData")

print("Spatial layers downloaded from FAO geoserver and saved as RData!")
