library(xml2)
library(raster)
library(sf)
library(geojsonio)
library(colorspace)
library(ggplot2)
library(rasterVis)
library(data.table)
library(dplyr)

# load("~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/RDATA/RASTER_STACK.RData")

setwd("~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/R/")

# VEGETATION INDEXES
ndvi <<- (B08-B04) / (B08+B04)
#evi <<-  2.5 * ((B08 - B04) / (B08 + 6 * B04 - 7.5 * B02 + 1))
#avi <<- (B08 * (1 - B04)*(B08 - B04))^(1/3)
#savi <<- (B08 - B04) / (B08 + B04 + 0.428) * (1.428)
# SOIL INDEXES
bsi <<- ((B11 + B04) - (B08 + B02)) / ((B11 + B04) + (B08 + B02))
# WATER INDEXES
ndmi <<- (B08 - B11) / (B08 + B11)
# NORMALIZED DIFFERENT WATER INDEX
ndwi <<- (B03 - B08) / (B03 + B08)
# MODIFIED NORMALIZED DIFFERENT WATER INDEX
#mndwi <<- (B02-B12)/(B02+B12)
# BUILT UP AREA EXTRACTION INDEX
ndbi <<- (B11 - B08)/(B11 + B08)
baei <<- (B04+0.3)/(B03+B12)
#ui <<- (B10 - B08)/(B10 + B08)
#mbi <<- (B11*B04 - (B08*B08))/(B04+B08+B11)
  

index_plotter <-  function(index, layer, pal_type, pal_select, rev, scale){
  
  date <- time_line[layer]
    if(index == 'ndvi'){index_name = 'Normalized Difference Vegetation Index'}
    if(index == 'avi'){index_name = 'Advanced Vegetation Index'}
    if(index == 'bsi'){index_name = 'Barren Soil Index'}
    if(index == 'ndmi'){index_name = 'Normalized Difference Moisture Index'}
    if(index == 'ndwi'){index_name = 'Normalized Difference Water Index'}
    if(index == 'ui'){index_name = 'Urbanization Level Index'}
    if(index == 'mbi'){index_name = 'Modified Built-Up Index'}
    if(index == 'ndbi'){index_name = 'Normalized Difference Built-Up Index'}
    if(index == 'baei'){index_name = 'Built up Area Index'}
  
    comando <<- paste0('plot(', index, '[[', layer, ']], col = ', pal_type, '(', scale, ', palette = "', pal_select, 
                      '", rev =', rev, '), main = "', index_name, '", sub = date)')
  
    eval(parse(text = comando))
    
  }

par(mfrow=c(3,3), mai = c(0.2, 0.1, 0.2, 0.1))
index_plotter('ndvi', 13, 'sequential_hcl', 'Terrain', TRUE, 100)
index_plotter('avi', 13, 'sequential_hcl', 'Turku', TRUE, 100)
index_plotter('bsi', 13, 'diverge_hcl', 'Tofino', FALSE, 100)
index_plotter('ndmi', 13, 'diverge_hcl', 'Blue-Red', TRUE, 100)
index_plotter('ndwi', 13, 'diverge_hcl', 'Blue-Red', TRUE, 100)
index_plotter('ui', 13, 'diverge_hcl', 'Lisbon', FALSE, 100)
index_plotter('mbi', 13, 'diverge_hcl', 'Berlin', FALSE, 100)
index_plotter('ndbi', 13, 'diverge_hcl', 'Vik', FALSE, 100)
index_plotter('baei', 13, 'diverge_hcl', 'Purple-Red', FALSE, 100)


save(index_plotter, file = '~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/RDATA/INDEX_SCORES.RData')
