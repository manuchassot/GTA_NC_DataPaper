print("Defining color layout...")

# tRFMOS ####
RFMO_COL = data.table(source_authority = factor(c("CCSBT", "IATTC", "ICCAT", "IOTC", "WCPFC"), ordered = TRUE), 
                      FILL = pal_npg()(5), 
                      OUTLINE = darken(pal_npg()(5), 0.2))

# Ocean basins ####
OCEAN_COL = data.table(ocean_basin = factor(c("Atlantic Ocean", "Indian Ocean", "Western-Central Pacific Ocean", "Eastern Pacific Ocean", "Global"), ordered = TRUE), 
                      FILL = pal_aaas()(5), 
                      OUTLINE = darken(pal_aaas()(5), 0.2))

# GTA Species groups ####
GTA_SPECIES_GROUP_COL = data.table(species_group_gta = factor(c("Billfishes", 
                                                                "Bonitos and mackerels", 
                                                                "Neritic tunas", 
                                                                "Other scombrids", 
                                                                "Rays", 
                                                                "Sharks", 
                                                                "Spanish mackerels", 
                                                                "Temperate tunas", 
                                                                "Tropical tunas"), ordered = TRUE), 
                                   FILL = rev(pal_simpsons()(9)), 
                                   OUTLINE = rev(colorspace::darken(ggsci::pal_simpsons()(9), 0.2))
                                   )

# GTA gear groups ####
GTA_GEAR_GROUPS_COL = data.table(gear_group_gta = factor(c("Handlines and pole and lines", 
                                                           "Longlines", 
                                                           "Surrounding nets", 
                                                           "Other gears"), ordered = TRUE), 
                                 FILL = pal_futurama()(4), 
                                 OUTLINE = colorspace::darken(pal_futurama()(4), 0.2)
)

print("Color layout defined!")