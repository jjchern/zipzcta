
# Download crosswalk file -------------------------------------------------
# Download date: "2015-11-07 23:43:08 CST"

url = "http://www.udsmapper.org/docs/zip_to_zcta_2015.xlsx"
lcl = "data-raw/zip_to_zcta_2015.xlsx"
if(!file.exists(lcl)) download.file(url, lcl)

# Read the data -----------------------------------------------------------

zipzcta = readxl::read_excel(lcl)

# Variable names -----------------------------------------------

library(dplyr)
library(magrittr)
names(zipzcta) = zipzcta %>% names %>% tolower()
zipzcta %<>%
  mutate(zip = as.integer(zip),
         zcta = as.integer(zcta))

# Save --------------------------------------------------------------------

devtools::use_data(zipzcta, overwrite = TRUE)

