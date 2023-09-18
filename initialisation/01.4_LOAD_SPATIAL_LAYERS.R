print("Loading the spatial layers...")

## World borders ####
WORLD_BORDERS_SF = ne_countries(returnclass = "sf")

## Countries and tRFMO areas
base::load("inputs/spatial_layers/SpatialLayers.RData")

print("Spatial layers loaded!")
