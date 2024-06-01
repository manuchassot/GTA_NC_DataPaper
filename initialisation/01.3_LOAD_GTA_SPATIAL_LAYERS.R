print("Loading the spatial layers...")

## World borders ####
WORLD_BORDERS_SF = ne_countries(returnclass = "sf")

## Countries and tRFMO areas
base::load("../inputs/spatial_layers/SpatialLayers.RData")

# Load NC areas
cl_nc_areas = fread("../inputs/spatial_layers/cl_nc_areas.csv")

NC_AREAS_SF = st_as_sf(cl_nc_areas, wkt = "geom_wkt", crs = st_crs(4326))

print("Spatial layers loaded!")