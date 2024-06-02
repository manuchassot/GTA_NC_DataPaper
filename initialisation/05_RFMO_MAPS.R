# PACIFIC-CENTERED MAP ####

# Source function used for cleaning the projection on the Pacific
source("92_MAP_PACIFIC_PROJECTION_FUNCTION.R")

# Addition for plotting the Pacific-centred maps
load(url("https://github.com/valentinitnelav/RandomScripts/blob/master/NaturalEarth.RData?raw=true"))

# Do not use the spherical geometryc package
sf::sf_use_s2(FALSE)

# Re-project the spatial layers
WORLD_PAC_SF = fSpatPlan_Convert2PacificRobinson(WORLD_BORDERS_SF)
IATTC_PAC_SF = fSpatPlan_Convert2PacificRobinson(IATTC_SF)
ICCAT_PAC_SF = fSpatPlan_Convert2PacificRobinson(ICCAT_SF)
IOTC_PAC_SF  = fSpatPlan_Convert2PacificRobinson(IOTC_SF)
WCPFC_PAC_SF = fSpatPlan_Convert2PacificRobinson(WCPFC_SF)

TRFMO_MAP_PACIFIC_CENTRED = 
  ggplot(data = WORLD_PAC_SF) + 
  geom_sf(fill = "black", color = "black") + 
  geom_sf(data = IATTC_PAC_SF, fill = RFMO_COL[source_authority == "IATTC", FILL], color = NA) + 
  geom_sf(data = ICCAT_PAC_SF, fill = RFMO_COL[source_authority == "ICCAT", FILL], color = NA) + 
  geom_sf(data = IOTC_PAC_SF, fill = RFMO_COL[source_authority == "IOTC", FILL], color = NA) + 
  geom_sf(data = WCPFC_PAC_SF, fill = RFMO_COL[source_authority == "WCPFC", FILL], color = NA)

ggsave("../outputs/charts/TRFMO_MAP_PACIFIC_CENTRED.png", TRFMO_MAP_PACIFIC_CENTRED, width = 8, height = 4.5)
