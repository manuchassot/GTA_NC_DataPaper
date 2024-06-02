# All species ####

## By tRFMO ####
NC_YEAR_OCEAN_BASIN = NC[year %in% 1950:2021, .(catch = sum(measurement_value/1000)), keyby = .(year, ocean_basin)]

NC_YEAR_OCEAN_BASIN[, ocean_basin := factor(ocean_basin, levels = c("Atlantic Ocean", "Indian Ocean", "Western-Central Pacific Ocean", "Eastern Pacific Ocean", "CCSBT"))]

NC_YEAR_OCEAN_BASIN_BARPLOT = 
  ggplot(data = NC_YEAR_OCEAN_BASIN, aes(x = year, y = catch, fill = ocean_basin, color = ocean_basin)) + 
  geom_col() + 
  labs(x = "", y = "Total catch (x1,000 t)") + 
  scale_fill_manual(values = OCEAN_COL$FILL) + 
  scale_color_manual(values = OCEAN_COL$OUTLINE) + 
  scale_y_continuous(labels = function(x) prettyNum(x, big.mark = ",")) + 
  theme(legend.position = "bottom", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 7), 
        legend.key.size = unit(.4, "cm")
  ) 

ggsave("../outputs/charts/NC/NC_YEAR_OCEAN_BASIN_BARPLOT.png", NC_YEAR_OCEAN_BASIN_BARPLOT, width = 6, height = 4.5)

## By species group ####
NC_YEAR_SPECIES_GROUP = NC[year %in% 1950:2021, .(catch = sum(measurement_value/1000)), keyby = .(year, species_group_gta)]

NC_YEAR_SPECIES_GROUP[, species_group_gta := factor(species_group_gta, levels = c("Billfishes", 
                                                                                  "Bonitos and mackerels", 
                                                                                  "Neritic tunas", 
                                                                                  "Other scombrids", 
                                                                                  "Rays", 
                                                                                  "Sharks", 
                                                                                  "Spanish mackerels", 
                                                                                  "Temperate tunas", 
                                                                                  "Tropical tunas"))]
NC_YEAR_SPECIES_GROUP_BARPLOT = 
ggplot(data = NC_YEAR_SPECIES_GROUP, aes(x = year, y = catch, fill = species_group_gta, color = species_group_gta)) + 
  geom_col() + 
  labs(x = "", y = "Total catch (x1,000 t)") + 
  scale_fill_manual(values = GTA_SPECIES_GROUP_COL$FILL) + 
  scale_color_manual(values = GTA_SPECIES_GROUP_COL$OUTLINE) + 
  scale_y_continuous(labels = function(x) prettyNum(x, big.mark = ",")) + 
  theme(legend.position = "bottom", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 7), 
        legend.key.size = unit(.4, "cm")
        ) 
  
ggsave("../outputs/charts/NC/NC_YEAR_SPECIES_GROUP_BARPLOT.png", NC_YEAR_SPECIES_GROUP_BARPLOT, width = 6, height = 4.5)

