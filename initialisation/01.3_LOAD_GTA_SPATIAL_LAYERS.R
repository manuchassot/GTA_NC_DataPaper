print("Loading the spatial layers...")

## World borders ####
WORLD_BORDERS_SF = ne_countries(returnclass = "sf")

## Countries and tRFMO areas
base::load("../inputs/spatial_layers/SpatialLayers.RData")

# Load NC areas
cl_nc_areas = fread("../inputs/spatial_layers/cl_nc_areas.csv")

NC_AREAS_SF = st_as_sf(cl_nc_areas, wkt = "geom_wkt", crs = st_crs(4326))

# Load CWP 1x1 and 5x5 grids
# SOURCE: OGC ####
WFS = WFSClient$new(url = "https://www.fao.org/fishery/geoserver/wfs", serviceVersion = "1.0.0", logger = "INFO")

## CWP GRIDS ####
# 1x1 grids
CWP11_SF = WFS$getFeatures("cwp:cwp-grid-map-1deg_x_1deg") %>% st_set_crs(4326)
CWP11 = as.data.table(CWP11_SF)
CWP11_ERASED_SF = WFS$getFeatures("cwp:cwp-grid-map-1deg_x_1deg_erased") %>% st_set_crs(4326)
CWP11_ERASED = as.data.table(CWP11_ERASED_SF)

# 5x5 grids
CWP55_SF = WFS$getFeatures("cwp:cwp-grid-map-5deg_x_5deg") %>% st_set_crs(4326)
CWP55 = as.data.table(CWP55_SF)
CWP55_ERASED_SF = WFS$getFeatures("cwp:cwp-grid-map-5deg_x_5deg_erased") %>% st_set_crs(4326)
CWP55_ERASED = as.data.table(CWP55_ERASED_SF)

# Save grids as shapefiles (not versioned)
st_write(CWP11_SF, "../inputs/spatial_layers/CWP11.shp", delete_layer = TRUE)
st_write(CWP11_ERASED_SF, "../inputs/spatial_layers/CWP11_ERASED.shp", delete_layer = TRUE)
st_write(CWP55_SF, "../inputs/spatial_layers/CWP55.shp", delete_layer = TRUE)
st_write(CWP55_ERASED_SF, "../inputs/spatial_layers/CWP55_ERASED.shp", delete_layer = TRUE)

print("Spatial layers loaded!")
