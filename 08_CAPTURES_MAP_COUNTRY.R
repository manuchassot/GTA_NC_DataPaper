# nc
NC_country_map <- NC
NC_RAW_GEOM <-  NC_country_map %>% 
  group_by(country_code) %>% summarise(measurement_value = sum(measurement_value)) %>%
  left_join(COUNTRIES_SF %>% 
              dplyr::select(ISO3CD, ISO_3), by = c("country_code" = "ISO3CD"))

NC_RAW_WITHOUT_GEOM <-  sf::st_drop_geometry(NC_RAW_GEOM%>% dplyr::select(-geom) %>% ungroup())

NC_RAW_WITHOUT_GEOM <- NC_RAW_WITHOUT_GEOM %>% filter(is.na(ISO_3))

COUNTRIES_SF_without_geom <- sf::st_drop_geometry(COUNTRIES_SF %>% ungroup() %>%  dplyr::select(-geom))




NC_RAW_country_groupped_geom <- sf::st_make_valid(sf::st_as_sf(NC_RAW_GEOM))

empty_indices <- which(st_is_empty(NC_RAW_country_groupped_geom))

# Print or inspect the problematic indices
print(NC_RAW_country_groupped_geom[empty_indices,])

NC_RAW_country_groupped_geom <- NC_RAW_country_groupped_geom[-empty_indices, ]

# Convert "codes" column to character type if needed
NC_RAW_country_groupped_geom$country_code <- as.character(NC_RAW_country_groupped_geom$country_code)

NC_RAW_country_groupped_geom_filtered <- NC_RAW_country_groupped_geom %>% group_by(country_code, geom) %>% summarise(measurement_value = sum(measurement_value))
NC_RAW_country_groupped_geom_filtered <- NC_RAW_country_groupped_geom %>%
  filter(st_geometry_type(geom) != "GEOMETRYCOLLECTION")

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
ggsave(here("outputs/charts/NC/CAPTURES_BY_COUNTRY_GGMAP.png"), plot = gg, width = 8, height = 6, dpi = 300)

tmap_options(max.categories = 174)



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

tmap_save(tm, filename = here("outputs/charts/NC/CAPTURES_BY_COUNTRY_MAP.png"))




# FSJ
FSJ_country_map <- CAPTURE_TO_COMPARE
FSJ_RAW_GEOM <-  FSJ_country_map %>% 
  group_by(country_code) %>% summarise(measurement_value = sum(measurement_value)) %>%
  left_join(COUNTRIES_SF %>% 
              dplyr::select(ISO3CD, ISO_3), by = c("country_code" = "ISO3CD"))

FSJ_RAW_WITHOUT_GEOM <-  sf::st_drop_geometry(FSJ_RAW_GEOM%>% dplyr::select(-geom) %>% ungroup())

FSJ_RAW_WITHOUT_GEOM <- FSJ_RAW_WITHOUT_GEOM %>% filter(is.na(ISO_3))

COUNTRIES_SF_without_geom <- sf::st_drop_geometry(COUNTRIES_SF %>% ungroup() %>%  dplyr::select(-geom))




FSJ_RAW_country_groupped_geom <- sf::st_make_valid(sf::st_as_sf(FSJ_RAW_GEOM))

empty_indices <- which(st_is_empty(FSJ_RAW_country_groupped_geom))

# Print or inspect the problematic indices
print(FSJ_RAW_country_groupped_geom[empty_indices,])

FSJ_RAW_country_groupped_geom <- FSJ_RAW_country_groupped_geom[-empty_indices, ]

# Convert "codes" column to character type if needed
FSJ_RAW_country_groupped_geom$country_code <- as.character(FSJ_RAW_country_groupped_geom$country_code)

FSJ_RAW_country_groupped_geom_filtered <- FSJ_RAW_country_groupped_geom %>% group_by(country_code, geom) %>% summarise(measurement_value = sum(measurement_value))
FSJ_RAW_country_groupped_geom_filtered <- FSJ_RAW_country_groupped_geom %>%
  filter(st_geometry_type(geom) != "GEOMETRYCOLLECTION")

# Calculate centroids
centroids <- st_centroid(FSJ_RAW_country_groupped_geom_filtered)

# Create pie_data data frame
pie_data <- centroids %>%
  st_coordinates() %>%
  as.data.frame() %>%
  rename(x = X, y = Y) %>%
  mutate(
    country_code = FSJ_RAW_country_groupped_geom_filtered$country_code,
    measurement_value = FSJ_RAW_country_groupped_geom_filtered$measurement_value
  )


library(ggforce)
library(ggplot2)
# Create a ggplot object
gg <- ggplot() +
  geom_sf(data = FSJ_RAW_country_groupped_geom_filtered,
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
ggsave(here("outputs/charts/FSJ/CAPTURES_BY_COUNTRY_GGMAP.png"), plot = gg, width = 8, height = 6, dpi = 300)

tmap_options(max.categories = 174)


library(sf)

# Assuming you have a data frame named FSJ_RAW_country_groupped_geom_filtered with the geometry column named "geometry"

# Convert the multiple polygons into a single polygon for each country
aggregated_data <- FSJ_RAW_country_groupped_geom_filtered %>%
  group_by(country_code) %>%
  summarise(
    total_measurement = sum(measurement_value, na.rm = TRUE),
    combined_geometry = st_combine(st_geometry(geom))
  ) %>%
  mutate(geometry = combined_geometry[which.max(st_area(combined_geometry))]) %>%
  dplyr::select(-combined_geometry)

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

tmap_save(tm, filename = here("outputs/charts/FSJ/CAPTURES_BY_COUNTRY_MAP.png"))


