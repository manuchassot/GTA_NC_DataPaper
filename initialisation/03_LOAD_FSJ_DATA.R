print("Reading FAO catches...")

# Read the catch data
CAPTURE_RAW = fread("../inputs/data/Capture_Quantity.csv")

# Build the full data set with code lists
CAPTURE = CAPTURE_RAW[CL_COUNTRIES, on = c("COUNTRY.UN_CODE" = "UN_CODE"), nomatch = 0][CL_SPECIES, on = c("SPECIES.ALPHA_3_CODE" = "SPECIES_CODE"), nomatch = 0][CL_AREAS, on = c("AREA.CODE" = "FISHING_GROUND_CODE"), nomatch = 0][CL_UNITS, on = c("MEASURE" = "MEASUREMENT_CODE"), nomatch = 0][, COUNTRY.UN_CODE := NULL]



