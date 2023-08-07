print("Loading the spatial layers...")

## World borders ####
WORLD_BORDERS_SF = ne_countries(returnclass = "sf")

# SOURCE: OGC ####
WFS = WFSClient$new(url = "https://www.fao.org/fishery/geoserver/wfs", serviceVersion = "1.0.0", logger = "INFO")

## COUNTRIES ####
# Countries (used by FIRMS to intersect the CWP grids)
COUNTRIES_SF = st_make_valid(WFS$getFeatures("fifao:country_bounds"))

## t-RFMOS ####
CCSBT_SF = WFS$getFeatures("rfb:RFB_CCSBT")
ICCAT_SF = WFS$getFeatures("rfb:RFB_ICCAT")
IATTC_SF = WFS$getFeatures("rfb:RFB_IATTC")
IOTC_SF  = WFS$getFeatures("rfb:RFB_IOTC")
WCPFC_SF = WFS$getFeatures("rfb:RFB_WCPFC")
