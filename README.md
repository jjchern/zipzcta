<!-- README.md is generated from README.Rmd. Please edit that file -->
About
=====

This package includes a ZIP Code to ZCTA crosswalk table developed by John Snow, Inc. The data is downloaded from [UDS Mapper](http://www.udsmapper.org/zcta-crosswalk.cfm), and it should be able to link ZIP codes to 2010 Census ZCTAs.

Installation
============

``` r
# install.packages("devtools")
devtools::install_github("jjchern/zipzcta")
```

Usage: Zip Codes -\> ZCTAs -\> Counties
=======================================

``` r
# devtools::install_github("jjchern/zipzcta")
# devtools::install_github("jjchern/zcta")

library(dplyr)

# ZIP codes to ZCTAs 
zipzcta::zipzcta 
#> Source: local data frame [41,270 x 5]
#> 
#>      zip       po_name state                             zip_type  zcta
#>    (int)         (chr) (chr)                                (chr) (int)
#> 1  96916        Merizo    GU Post Office or large volume customer 96916
#> 2  96917      Inarajan    GU Post Office or large volume customer 96917
#> 3  96928          Agat    GU Post Office or large volume customer 96928
#> 4  96915    Santa Rita    GU                        ZIP Code area 96915
#> 5  96923      Mangilao    GU Post Office or large volume customer 96913
#> 6  96910       Hagatna    GU                        ZIP Code area 96910
#> 7  96932       Hagatna    GU Post Office or large volume customer 96932
#> 8  96919 Agana Heights    GU Post Office or large volume customer 96910
#> 9  96921     Barrigada    GU Post Office or large volume customer 96921
#> 10 96913     Barrigada    GU                        ZIP Code area 96913
#> ..   ...           ...   ...                                  ...   ...

# ZCTAs to Counties
zctacounty = zcta::zcta_county_rel_10 %>%
  select(zcta5, state, county, geoid, poppt, zpoppct) %>%
  group_by(zcta5) %>%
  slice(which.max(zpoppct)) %>%
  left_join(gaze::county10, by = "geoid") %>%
  select(zcta5, state, usps, county, geoid, name) 
zctacounty
#> Source: local data frame [33,120 x 6]
#> Groups: zcta5 [33120]
#> 
#>    zcta5 state  usps county geoid                  name
#>    (int) (int) (chr)  (int) (int)                 (chr)
#> 1    601    72    PR      1 72001    Adjuntas Municipio
#> 2    602    72    PR      3 72003      Aguada Municipio
#> 3    603    72    PR      5 72005   Aguadilla Municipio
#> 4    606    72    PR     93 72093     Maricao Municipio
#> 5    610    72    PR     11 72011     A~nasco Municipio
#> 6    612    72    PR     13 72013     Arecibo Municipio
#> 7    616    72    PR     13 72013     Arecibo Municipio
#> 8    617    72    PR     17 72017 Barceloneta Municipio
#> 9    622    72    PR     23 72023   Cabo Rojo Municipio
#> 10   623    72    PR     23 72023   Cabo Rojo Municipio
#> ..   ...   ...   ...    ...   ...                   ...

# ZIP codes to ZCTAs to Counties
zipcounty = zipzcta::zipzcta %>% 
  left_join(zctacounty, by = c("zcta" = "zcta5")) %>% 
  select(zip, zcta, state = usps, countygeoid = geoid, countyname = name) %>% 
  arrange(zip)
zipcounty
#> Source: local data frame [41,270 x 5]
#> 
#>      zip  zcta state countygeoid          countyname
#>    (int) (int) (chr)       (int)               (chr)
#> 1    501 11742    NY       36103      Suffolk County
#> 2    544 11742    NY       36103      Suffolk County
#> 3    601   601    PR       72001  Adjuntas Municipio
#> 4    602   602    PR       72003    Aguada Municipio
#> 5    603   603    PR       72005 Aguadilla Municipio
#> 6    604   603    PR       72005 Aguadilla Municipio
#> 7    605   603    PR       72005 Aguadilla Municipio
#> 8    606   606    PR       72093   Maricao Municipio
#> 9    610   610    PR       72011   A~nasco Municipio
#> 10   611   641    PR       72141    Utuado Municipio
#> ..   ...   ...   ...         ...                 ...
```
