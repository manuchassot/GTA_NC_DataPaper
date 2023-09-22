#Charts
## By tRFMO ####
FSJ <- CAPTURE_TO_COMPARE %>% mutate(year = lubridate::year(year))

FSJ_YEAR_OCEAN_BASIN = FSJ[year %in% 1950:2021, .(catch = sum(measurement_value/1000)), keyby = .(year, ocean_basin)]

FSJ_YEAR_OCEAN_BASIN[, ocean_basin := factor(ocean_basin, levels = c("Atlantic Ocean", "Indian Ocean", "Western-Central Pacific Ocean", "Eastern Pacific Ocean", "Other"))]

FSJ_YEAR_OCEAN_BASIN_BARPLOT = 
  ggplot(data = FSJ_YEAR_OCEAN_BASIN, aes(x = year, y = catch, fill = ocean_basin, color = ocean_basin)) + 
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

ggsave(here("outputs/charts/FSJ/FSJ_YEAR_OCEAN_BASIN_BARPLOT.png"), FSJ_YEAR_OCEAN_BASIN_BARPLOT, width = 6, height = 4.5)



## By species group ####
FSJ_YEAR_SPECIES_GROUP = FSJ[year %in% 1950:2021, .(catch = sum(measurement_value/1000)), keyby = .(year, species_group_gta)]

FSJ_YEAR_SPECIES_GROUP[, species_group_gta := factor(species_group_gta, levels = c("Sharks, rays, chimaeras", 
                                                                                "Tunas, bonitos, billfishes"))]
FSJ_YEAR_SPECIES_GROUP_BARPLOT = 
  ggplot(data = FSJ_YEAR_SPECIES_GROUP, aes(x = year, y = catch, fill = species_group_gta, color = species_group_gta)) + 
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

ggsave(here("outputs/charts/FSJ/FSJ_YEAR_SPECIES_GROUP_BARPLOT.png"), FSJ_YEAR_SPECIES_GROUP_BARPLOT, width = 6, height = 4.5)

