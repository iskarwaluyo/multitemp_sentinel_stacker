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

setwd("~/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/R/")

resample_stack <- function(reference_layer = 'B02'){
  B01 <<- resample(brick_stack[['B01']], brick_stack[[reference_layer]])
  B02 <<- resample(brick_stack[['B02']], brick_stack[[reference_layer]])
  B03 <<- resample(brick_stack[['B03']], brick_stack[[reference_layer]])
  B04 <<- resample(brick_stack[['B04']], brick_stack[[reference_layer]])
  B05 <<- resample(brick_stack[['B05']], brick_stack[[reference_layer]])
  B06 <<- resample(brick_stack[['B06']], brick_stack[[reference_layer]])
  B07 <<- resample(brick_stack[['B07']], brick_stack[[reference_layer]])
  B08 <<- resample(brick_stack[['B08']], brick_stack[[reference_layer]])
  B8A <<- resample(brick_stack[['B8A']], brick_stack[[reference_layer]])
  B09 <<- resample(brick_stack[['B09']], brick_stack[[reference_layer]])
  B10 <<- resample(brick_stack[['B10']], brick_stack[[reference_layer]])
  B11 <<- resample(brick_stack[['B11']], brick_stack[[reference_layer]])
  B12 <<- resample(brick_stack[['B12']], brick_stack[[reference_layer]])
}

resample_stack('B02')

index_calculator <-  function(index, layer, pal_type, pal_select, rev, scale){
  date <- time_line[layer]
  if(index == 'ndvi'){index_name = 'Normalized Difference Vegetation Index'
    ndvi <<- (B08-B04) / (B08+B04)
  }
  if(index == 'avi'){index_name = 'Advanced Vegetation Index'
    avi <<- B08 * ((1 - B04)*(B08 - B04))^(1/3)
  }
  if(index == 'savi'){index_name = 'Soil Adjusted Vegetation Index'
    savi <<- (B08 - B04) / (B08 + B04 + 0.428) * (1.428)
  }
  if(index == 'bsi'){index_name = 'Barren Soil Index'
    bsi <<- ((B11 + B04) - (B08 + B02)) / ((B11 + B04) + (B08 + B02))
  }
  if(index == 'ndmi'){index_name = 'Normalized Difference Moisture Index'
    ndmi <<- (B08 - B11) / (B08 + B11)
  }
  if(index == 'ndwi'){index_name = 'Normalized Difference Water Index'
    ndwi <<- (B03 - B08) / (B03 + B08)
  }
  if(index == 'ui'){index_name = 'Urbanization Level Index'
    ui <<- (B10 - B08)/(B10 + B08)
  }
  if(index == 'mbi'){index_name = 'Modified Built-Up Index'
    mbi <<- (B11*B04 - (B08*B08))/(B04+B08+B11)
  }
  if(index == 'ndbi'){index_name = 'Normalized Difference Built-Up Index'
    ndbi <<- (B11 - B08)/(B11 + B08)
  }
  if(index == 'baei'){index_name = 'Built up Area Index'
    baei <<- (B04+0.3)/(B03+B12)
  }
  
  comando <<- paste0('plot(', index, '[[', layer, ']], col = ', pal_type, '(', scale, ', palette = "', pal_select, 
                     '", rev =', rev, '), main = "', index_name, '", sub = date)')
  
  eval(parse(text = comando))
  
}

par(mfrow=c(3,3), mai = c(0.2, 0.1, 0.2, 0.1))
index_calculator('ndvi', 13, 'sequential_hcl', 'Terrain', TRUE, 100)
index_calculator('savi', 13, 'sequential_hcl', 'Turku', TRUE, 100)
index_calculator('bsi', 13, 'diverge_hcl', 'Tofino', FALSE, 100)
index_calculator('ndmi', 13, 'diverge_hcl', 'Blue-Red', TRUE, 100)
index_calculator('ndwi', 13, 'diverge_hcl', 'Blue-Red', TRUE, 100)
index_calculator('ui', 13, 'diverge_hcl', 'Lisbon', FALSE, 100)
index_calculator('mbi', 13, 'diverge_hcl', 'Berlin', FALSE, 100)
index_calculator('ndbi', 13, 'diverge_hcl', 'Vik', FALSE, 100)
index_calculator('baei', 13, 'diverge_hcl', 'Cyan-Magenta', FALSE, 100)

par(mfrow=c(1,1))

# other indexes not used in function
#ndvi <<- (B08-B04) / (B08+B04)
#evi <<-  2.5 * ((B08 - B04) / (B08 + 6 * B04 - 7.5 * B02 + 1))
#mndwi <<- (B02-B12)/(B02+B12)
