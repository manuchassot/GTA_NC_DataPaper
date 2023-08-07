print("Defining color layout...")

# tRFMPS ####
RFMO_COL = data.table(source_authority = c("CCSBT", "IATTC", "ICCAT", "IOTC", "WCPFC"), 
                      FILL = pal_npg()(5), 
                      OUTLINE = darken(pal_npg()(5), 0.2))

# GTA Species groups ####


print("Color layout defined!")