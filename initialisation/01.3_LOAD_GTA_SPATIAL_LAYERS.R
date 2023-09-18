print("Loading the spatial layers...")

## World borders ####
WORLD_BORDERS_SF = ne_countries(returnclass = "sf")

## Countries and tRFMO areas
<<<<<<< HEAD:initialisation/01.4_LOAD_SPATIAL_LAYERS.R
base::load("inputs/spatial_layers/SpatialLayers.RData")
=======
base::load("../inputs/spatial_layers/SpatialLayers.RData")
>>>>>>> 89165a34f78cfb406a7db34d5bc6d97a32f175e0:initialisation/01.3_LOAD_GTA_SPATIAL_LAYERS.R

print("Spatial layers loaded!")
