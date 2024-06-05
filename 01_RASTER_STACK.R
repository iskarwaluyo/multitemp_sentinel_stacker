library(xml2)
library(raster)
library(sf)
library(geojsonio)
library(colorspace)

# CREATE DIRECTORY PATHS
# MAIN ENVIRONMENT DIRECTORY
main_dir <- "~/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/R"
# GIS DATA DIRECTORY
sig_dir <- "~/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/SIG"
# RASTER DATA DIRECTORY
raster_dir <- "~/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/RASTER/"
# DIRECTORY TO STORE RESULTS
results_dir <- "~/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/RESULTS/"

# FUNCTION I: MULTITEMPORAL STACKER
# MAKES STACKS OF SAME BANDWIDTH AND DIFFERENT BANDWIDTHS

multitemporal_stacker <- function(file_dir, roi){

  setwd(sig_dir)
  ROI <<- geojson_sf(paste0(roi,'.geojson'))
  ROI <<- as_Spatial(ROI)
  
  setwd(main_dir)
  
  brick_stack_clipped <<- ''
  brick_stack <<- ''
  bricks <<- ''
  band_names <- c('B01', 'B02', 'B03', 'B04')

  for(j in 1:length(band_names)){
    
  setwd(raster_dir)
  setwd(paste0('./', file_dir, '/'))
  
  dir_list <- ""
  dir_list <- list.files(pattern="", full.names=TRUE)
  files <<- ""
  
  band_name <- band_names[[j]]

  n <- as.numeric(length(dir_list))
  m <<- as.numeric(length(dir_list))
  x <- ""
  y <- ""
  file <- ""
  time_line <<- ""
  
  #if(substr(dir_list[i], 41, 46) == substr(dir_list[i+1], 41, 46))
  
  for(i in 1:n){
    setwd(raster_dir)
    setwd(paste0('./', file_dir, '/'))
    setwd(dir_list[i])
    raster_data <- read_xml("MTD_MSIL1C.xml")
    raster_time <- xml_text(xml_find_all(raster_data, "//PRODUCT_START_TIME"))
    time_line[i] <- lapply(raster_time, substr, 1, 10) 
    time_line <<- unlist(time_line)
    
    setwd(raster_dir)
    setwd(paste0('./', file_dir, '/'))
    x <- paste0(dir_list,"/GRANULE/")  

    setwd(x[i])
    y <- list.files(pattern = "", full.names=TRUE)

    setwd(y)
    setwd("./IMG_DATA")
    
    files <<- list.files(pattern = band_names[[j]], full.names=TRUE)
    bricks[i] <<- lapply(files, brick)
    
  }
  
  brick_stack[j] <<- list(bricks)
  comando <<- paste0(band_names[[j]], " <<- stack(bricks)")
  eval(parse(text = comando))
  
  # SET CRS/PROJECTION
  crs(ROI) <- st_crs(bricks)
  
  # CROP
  comando <<- paste0(band_names[[j]], " <<- crop(",band_name,", ROI)")
  eval(parse(text = comando))
  
  # MASK
  comando <<- paste0(band_names[[j]], " <<- mask(",band_name,", ROI)")
  eval(parse(text = comando))
  
  # RENAME USING DATES
  comando <<- paste0("names(",band_names[[j]], ") <<- time_line")
  eval(parse(text = comando))
  
  }
  
  setwd(sig_dir)
}

multitemporal_stacker("Xochimilco", "ROI")


color_plots <- function(img_number)
{
  par(mfrow = c(1, 2))
  true_color <- stack(B04[[img_number]],B03[[img_number]],B02[[img_number]])
  false_color <- stack(B08[[img_number]],B04[[img_number]],B03[[img_number]])
  
  plotRGB(true_color, r=1,g=2,b=3, stretch = "lin")
  plotRGB(false_color, r=1,g=2,b=3, stretch = "lin")
  par(mfrow = c(1,1))
}


# EXAMPLE

color_plots(1) # RGB PLOTS OF FIRST LAYER OF STACK
color_plots(2) # RGB PLOTS OF SEDOND LAYER OF STACK


save(multitemporal_stacker, color_plots, 
     main_dir, sig_dir, raster_dir, results_dir, 
     file = '~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/RDATA/RASTER_STACK.RData')
