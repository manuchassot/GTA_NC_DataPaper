# # # maps from country for GTA and FS
# NC_RAW_COUNTRY <- NC_RAW
# NC_RAW_COUNTRY$fishing_fleet <- gsub("^EU", "", NC_RAW_COUNTRY$fishing_fleet)
# NC_RAW_COUNTRY$fishing_fleet <- gsub("^UK", "", NC_RAW_COUNTRY$fishing_fleet)
# NC_RAW_COUNTRY$fishing_fleet <- ifelse(NC_RAW_COUNTRY$fishing_fleet == "R", "UKR", NC_RAW_COUNTRY$fishing_fleet)
# 
# NC_RAW_COUNTRY$fishing_fleet <- gsub("^FR", "", NC_RAW_COUNTRY$fishing_fleet)
# NC_RAW_COUNTRY$fishing_fleet <- ifelse(NC_RAW_COUNTRY$fishing_fleet == "A", "FRA", NC_RAW_COUNTRY$fishing_fleet)
# NC_RAW_COUNTRY$fishing_fleet <- ifelse(NC_RAW_COUNTRY$fishing_fleet == "O", "FRO", NC_RAW_COUNTRY$fishing_fleet)
# 
# NC_RAW_GEOM <-  NC_RAW_COUNTRY %>% 
#   group_by(fishing_fleet) %>% summarise(measurement_value = sum(measurement_value)) %>%
#   left_join(COUNTRIES_SF %>% 
#             dplyr::select(ISO3CD, ISO_3), by = c("fishing_fleet" = "ISO3CD"))
# 
# NC_RAW_WITHOUT_GEOM <-  sf::st_drop_geometry(NC_RAW_GEOM%>% dplyr::select(-geom) %>% ungroup())
# 
# t <- NC_RAW_WITHOUT_GEOM %>% filter(is.na(ISO_3))
# 
# COUNTRIES_SF_without_geom <- sf::st_drop_geometry(COUNTRIES_SF %>% ungroup() %>%  dplyr::select(-geom))
# 
# 
# 
# 
# NC_RAW_country_groupped_geom <- sf::st_make_valid(sf::st_as_sf(NC_RAW_GEOM))
# # Assuming your spatial data is in the variable "spatial_data"
# empty_indices <- which(st_is_empty(NC_RAW_country_groupped_geom))
# 
# # Print or inspect the problematic indices
# print(NC_RAW_country_groupped_geom[empty_indices,])
# 
# NC_RAW_country_groupped_geom <- NC_RAW_country_groupped_geom[-empty_indices, ]
# 
# # Convert "codes" column to character type if needed
# NC_RAW_country_groupped_geom$fishing_fleet <- as.character(NC_RAW_country_groupped_geom$fishing_fleet)
# 
# NC_RAW_country_groupped_geom_filtered <- NC_RAW_country_groupped_geom %>%
#   filter(!is.na(geom) & !st_is(geom))
# 
# NC_RAW_country_groupped_geom_filtered <- NC_RAW_country_groupped_geom %>% group_by(fishing_fleet, geom) %>% summarise(measurement_value = sum(measurement_value))
# NC_RAW_country_groupped_geom_filtered <- NC_RAW_country_groupped_geom %>%
#   filter(st_geometry_type(geom) != "GEOMETRYCOLLECTION")
# 
# test <- NC_RAW_country_groupped_geom_filtered %>% filter()
# 
# 
# library(sf)
# library(tmap)
# 
# library(sf)
# library(dplyr)
# 
# # Calculate centroids
# centroids <- st_centroid(NC_RAW_country_groupped_geom_filtered)
# 
# # Create pie_data data frame
# pie_data <- centroids %>%
#   st_coordinates() %>%
#   as.data.frame() %>%
#   rename(x = X, y = Y) %>%
#   mutate(
#     fishing_fleet = NC_RAW_country_groupped_geom_filtered$fishing_fleet,
#     measurement_value = NC_RAW_country_groupped_geom_filtered$measurement_value
#   )
# 
# 
# library(ggforce)
# 
# 
# # Generate centroids
# library(ggplot2)
# # Create a ggplot object
# gg <- ggplot() +
#   geom_sf(data = NC_RAW_country_groupped_geom_filtered,
#           aes(fill = fishing_fleet)) +
#   geom_point(data = pie_data,
#              aes(x = x, y = y, size = measurement_value, fill = fishing_fleet),
#              shape = 21) +
#   scale_fill_viridis_d(option = "plasma") +
#   scale_size_continuous(range = c(1, 10)) +
#   coord_sf() +
#   theme_minimal()+
#   guides(fill = "none")
# 
# 
# gg
# ggsave("output_plot.png", plot = gg, width = 8, height = 6, dpi = 300)
# 
# tmap_options(max.categories = 153)
# 
# 
# 
# library(sf)
# 
# # Assuming you have a data frame named NC_RAW_country_groupped_geom_filtered with the geometry column named "geometry"
# 
# # Convert the multiple polygons into a single polygon for each country
# aggregated_data <- NC_RAW_country_groupped_geom_filtered %>%
#   group_by(fishing_fleet) %>%
#   summarise(
#     total_measurement = sum(measurement_value, na.rm = TRUE),
#     geometry = st_union(st_geometry(geom))
#   )
# 
# 
# # Create tmap plot
# tm <- tm_shape(aggregated_data) +
#   tm_borders() +  # Add country borders
#   tm_symbols(
#     size = "total_measurement",
#     col = "fishing_fleet",
#     shape = 21,
#     alpha = 0.6
#   ) +
#   tm_layout(legend.show = FALSE)  # Remove the legend
# 
# tm



## Same but with country code 

NC_country_map <- NC_country
NC_country_map$country_code <- gsub("^EU", "", NC_country_map$country_code)
NC_country_map$country_code <- gsub("^UK", "", NC_country_map$country_code)
NC_country_map$country_code <- ifelse(NC_country_map$country_code == "R", "UKR", NC_country_map$country_code)

NC_country_map$country_code <- gsub("^FR", "", NC_country_map$country_code)
NC_country_map$country_code <- ifelse(NC_country_map$country_code == "A", "FRA", NC_country_map$country_code)
NC_country_map$country_code <- ifelse(NC_country_map$country_code == "O", "FRO", NC_country_map$country_code)
NC_country_map$country_code <- ifelse(NC_country_map$country_code == "GBRT", "GBR", NC_country_map$country_code)


NC_RAW_GEOM <-  NC_country_map %>% 
  group_by(country_code) %>% summarise(measurement_value = sum(measurement_value)) %>%
  left_join(COUNTRIES_SF %>% 
              dplyr::select(ISO3CD, ISO_3), by = c("country_code" = "ISO3CD"))

NC_RAW_WITHOUT_GEOM <-  sf::st_drop_geometry(NC_RAW_GEOM%>% dplyr::select(-geom) %>% ungroup())

t <- NC_RAW_WITHOUT_GEOM %>% filter(is.na(ISO_3))

COUNTRIES_SF_without_geom <- sf::st_drop_geometry(COUNTRIES_SF %>% ungroup() %>%  dplyr::select(-geom))




NC_RAW_country_groupped_geom <- sf::st_make_valid(sf::st_as_sf(NC_RAW_GEOM))
# Assuming your spatial data is in the variable "spatial_data"
empty_indices <- which(st_is_empty(NC_RAW_country_groupped_geom))

# Print or inspect the problematic indices
print(NC_RAW_country_groupped_geom[empty_indices,])

NC_RAW_country_groupped_geom <- NC_RAW_country_groupped_geom[-empty_indices, ]

# Convert "codes" column to character type if needed
NC_RAW_country_groupped_geom$country_code <- as.character(NC_RAW_country_groupped_geom$country_code)

# NC_RAW_country_groupped_geom_filtered <- NC_RAW_country_groupped_geom %>%
#   dplyr::filter(!is.na(geom) & !st_is(geom))

NC_RAW_country_groupped_geom_filtered <- NC_RAW_country_groupped_geom %>% group_by(country_code, geom) %>% summarise(measurement_value = sum(measurement_value))
NC_RAW_country_groupped_geom_filtered <- NC_RAW_country_groupped_geom %>%
  filter(st_geometry_type(geom) != "GEOMETRYCOLLECTION")



library(sf)
library(tmap)


# Calculate centroids
centroids <- st_centroid(NC_RAW_country_groupped_geom_filtered)

# Create pie_data data frame
pie_data <- centroids %>%
  st_coordinates() %>%
  as.data.frame() %>%
  rename(x = X, y = Y) %>%
  mutate(
    country_code = NC_RAW_country_groupped_geom_filtered$country_code,
    measurement_value = NC_RAW_country_groupped_geom_filtered$measurement_value
  )


library(ggforce)


# Generate centroids
library(ggplot2)
# Create a ggplot object
gg <- ggplot() +
  geom_sf(data = NC_RAW_country_groupped_geom_filtered,
          aes(fill = country_code)) +
  geom_point(data = pie_data,
             aes(x = x, y = y, size = measurement_value, fill = country_code),
             shape = 21) +
  scale_fill_viridis_d(option = "plasma") +
  scale_size_continuous(range = c(1, 10)) +
  coord_sf() +
  theme_minimal()+
  guides(fill = "none")


gg
ggsave(here("outputs/charts/plotsFS_NC/captures_by_countryggplot.png"), plot = gg, width = 8, height = 6, dpi = 300)

tmap_options(max.categories = 153)



library(sf)

# Assuming you have a data frame named NC_RAW_country_groupped_geom_filtered with the geometry column named "geometry"

# Convert the multiple polygons into a single polygon for each country
aggregated_data <- NC_RAW_country_groupped_geom_filtered %>%
  group_by(country_code) %>%
  summarise(
    total_measurement = sum(measurement_value, na.rm = TRUE),
    combined_geometry = st_combine(st_geometry(geom))
  ) %>%
  mutate(geometry = combined_geometry[which.max(st_area(combined_geometry))]) %>%
  dplyr::select(-combined_geometry)

tmap_options(max.categories = 142)
tam_mode = "view"
# Create tmap plot
tm <- tm_shape(aggregated_data) +
  tm_borders() +  # Add country borders
  tm_symbols(
    size = "total_measurement",
    col = "country_code",
    shape = 21,
    alpha = 0.6, scale = 2, shapes.n = 15
  ) +
  tm_layout(legend.show = FALSE)  # Remove the legend
tm

tmap_save(tm, filename = here("outputs/charts/plotsFS_NC/captures_by_country.png"))

