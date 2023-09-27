# ALL SPECIES ####

## BY OCEAN  ####
NC_YEAR_OCEAN_BASIN = NC[year %in% 1950:2021, .(catch = sum(measurement_value/1000)), keyby = .(year, ocean_basin)]

NC_YEAR_OCEAN_BASIN[, ocean_basin := factor(ocean_basin, levels = c("Atlantic Ocean", "Indian Ocean", "Western-Central Pacific Ocean", "Eastern Pacific Ocean"))]

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

## BY SPECIES GROUP ####
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

# BY GEAR GROUP ####
NC_YEAR_GEAR_GROUP = NC[year %in% 1950:2021, .(catch = sum(measurement_value/1000)), keyby = .(year, gear_group_label)]

NC_YEAR_GEAR_GROUP[, gear_group_label := factor(gear_group_label, levels = c("Handlines and pole and lines", 
                                                                                  "Longlines", 
                                                                                  "Surrounding nets", 
                                                                                  "Other gears"))]
NC_YEAR_GEAR_GROUP_BARPLOT = 
  ggplot(data = NC_YEAR_GEAR_GROUP, aes(x = year, y = catch, fill = gear_group_label, color = gear_group_label)) + 
  geom_col() + 
  labs(x = "", y = "Total catch (x1,000 t)") + 
  scale_fill_manual(values = GTA_GEAR_GROUPS_COL$FILL) + 
  scale_color_manual(values = GTA_GEAR_GROUPS_COL$OUTLINE) + 
  scale_y_continuous(labels = function(x) prettyNum(x, big.mark = ",")) + 
  theme(legend.position = "bottom", 
        legend.title = element_blank(), 
        legend.text = element_text(size = 7), 
        legend.key.size = unit(.4, "cm")
  ) 

ggsave("../outputs/charts/NC/NC_YEAR_GEAR_GROUP_BARPLOT.png", NC_YEAR_GEAR_GROUP_BARPLOT, width = 6, height = 4.5)

## TUNAS ####

# Including temperate and tropical (oceanic) tunas

## BY OCEAN  ####
NC_TUNA_YEAR_OCEAN_BASIN = NC[year %in% 1950:2021 & species_group_gta %in% c("Temperate tunas", "Tropical tunas"), .(catch = sum(measurement_value/1000)), keyby = .(year, ocean_basin)]

NC_TUNA_YEAR_OCEAN_BASIN[, ocean_basin := factor(ocean_basin, levels = c("Atlantic Ocean", "Indian Ocean", "Western-Central Pacific Ocean", "Eastern Pacific Ocean"))]

NC_TUNA_YEAR_OCEAN_BASIN_BARPLOT = 
  ggplot(data = NC_TUNA_YEAR_OCEAN_BASIN, aes(x = year, y = catch, fill = ocean_basin, color = ocean_basin)) + 
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

ggsave("../outputs/charts/NC/NC_TUNA_YEAR_OCEAN_BASIN_BARPLOT.png", NC_TUNA_YEAR_OCEAN_BASIN_BARPLOT, width = 6, height = 4.5)

# TROPICAL TUNAS ####

## BY OCEAN  ####
NC_TROP_YEAR_OCEAN_BASIN = NC[year %in% 1950:2021 & species %in% c("BET", "SKJ", "YFT"), .(catch = sum(measurement_value/1000)), keyby = .(year, ocean_basin)]

NC_TROP_YEAR_OCEAN_BASIN[, ocean_basin := factor(ocean_basin, levels = c("Atlantic Ocean", "Indian Ocean", "Western-Central Pacific Ocean", "Eastern Pacific Ocean"))]

NC_TROP_YEAR_OCEAN_BASIN_BARPLOT = 
  ggplot(data = NC_TROP_YEAR_OCEAN_BASIN, aes(x = year, y = catch, fill = ocean_basin, color = ocean_basin)) + 
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

ggsave("../outputs/charts/NC/NC_TROP_YEAR_OCEAN_BASIN_BARPLOT.png", NC_TROP_YEAR_OCEAN_BASIN_BARPLOT, width = 6, height = 4.5)

# TROPICAL TUNAS CAUGHT WITH PURSE SEINE ####

## BY OCEAN  ####
NC_PS_TUNA_YEAR_OCEAN_BASIN = NC[year %in% 1950:2021 & gear_type == "01.1" & species_group_gta %in% c("Temperate tunas", "Tropical tunas"), .(catch = sum(measurement_value/1000)), keyby = .(year, ocean_basin)]

NC_PS_TUNA_YEAR_OCEAN_BASIN[, ocean_basin := factor(ocean_basin, levels = c("Atlantic Ocean", "Indian Ocean", "Western-Central Pacific Ocean", "Eastern Pacific Ocean"))]

NC_PS_TUNA_YEAR_OCEAN_BASIN_BARPLOT = 
  ggplot(data = NC_PS_TUNA_YEAR_OCEAN_BASIN, aes(x = year, y = catch, fill = ocean_basin, color = ocean_basin)) + 
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

ggsave("../outputs/charts/NC/NC_PS_TUNA_YEAR_OCEAN_BASIN_BARPLOT.png", NC_PS_TUNA_YEAR_OCEAN_BASIN_BARPLOT, width = 6, height = 4.5)


# TROPICAL TUNAS CAUGHT WITH PURSE SEINE ####

## BY OCEAN  ####
NC_PS_TROP_YEAR_OCEAN_BASIN = NC[year %in% 1950:2021 & gear_type == "01.1" & species %in% c("BET", "SKJ", "YFT"), .(catch = sum(measurement_value/1000)), keyby = .(year, ocean_basin)]

NC_PS_TROP_YEAR_OCEAN_BASIN[, ocean_basin := factor(ocean_basin, levels = c("Atlantic Ocean", "Indian Ocean", "Western-Central Pacific Ocean", "Eastern Pacific Ocean"))]

NC_PS_TROP_YEAR_OCEAN_BASIN_BARPLOT = 
  ggplot(data = NC_PS_TROP_YEAR_OCEAN_BASIN, aes(x = year, y = catch, fill = ocean_basin, color = ocean_basin)) + 
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

ggsave("../outputs/charts/NC/NC_PS_TROP_YEAR_OCEAN_BASIN_BARPLOT.png", NC_PS_TROP_YEAR_OCEAN_BASIN_BARPLOT, width = 6, height = 4.5)

