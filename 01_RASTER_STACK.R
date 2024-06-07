# CREATE DIRECTORY PATHS
# MAIN ENVIRONMENT DIRECTORY CONTAINS CODE
main_dir <- "~/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/R"
# GIS DATA DIRECTORY CONTAINS REGION OF INTEREST GEOJSON AND OTHER GIS DATA
sig_dir <- "~/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/SIG"
# RASTER DATA DIRECTORY CONTAINS DIRECTORIES WITH SENTINEL 2A DATA
raster_dir <- "~/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/RASTER/"
# DIRECTORY TO STORE RESULTS EXPORTS RESULTS TO THIS DIRECTORY
results_dir <- "~/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/RESULTS/"

# FUNCTION I: MULTITEMPORAL STACKER
# MAKES STACKS OF SAME BANDWIDTH AND DIFFERENT BANDWIDTHS

multitemporal_stacker <- function(bands, raster_dir, file_dir, roi, cores){
  
  require(future)
  require(future.apply)
  require(raster)
  require(geojsonio)
  require(sf)
  require(xml2)
  
  bricks <- ''
  brick_stack <<- list()

  for(j in 1:length(bands)){
    
  setwd(raster_dir)
  setwd(paste0('./', file_dir, '/'))
  
  dir_list <- ''
  dir_list <- list.files(pattern='', full.names=TRUE)
  files <- ''

  for(i in 1:length(dir_list)){
    time_line <- ''
    setwd(raster_dir)
    setwd(paste0('./', file_dir, '/'))
    setwd(dir_list[i])
    raster_data <- read_xml('MTD_MSIL1C.xml')
    raster_time <- xml_text(xml_find_all(raster_data, '//PRODUCT_START_TIME'))
    time_line[i] <- lapply(raster_time, substr, 1, 10) 

    setwd(raster_dir)
    setwd(paste0('./', file_dir, '/'))
    x <- paste0(dir_list,'/GRANULE/')  

    setwd(x[i])
    y <- list.files(pattern = '', full.names=TRUE)

    setwd(y)
    setwd('./IMG_DATA')
    
    files <- list.files(pattern = bands[[j]], full.names=TRUE)
    bricks[i] <- lapply(files, brick)
    names(bricks[[i]]) <- time_line[[i]]
  }
  
  # SET CRS/PROJECTION
  crs(ROI) <- st_crs(bricks)

  plan(multicore, workers = cores)
  
  bstack <- future_lapply(bricks, crop, ROI, future.seed = T)
  bstack_clip <- future_lapply(bstack, mask, ROI, future.seed = T)

  brick_stack[j] <<- stack(bstack_clip)

  }
  
  names(brick_stack) <<- all_bands
  setwd(sig_dir)
}

all_bands <- c('B01', 'B02', 'B03', 'B04', 'B05', 'B06', 'B07', 'B08', 'B8A', 
               'B09', 'B10', 'B11', 'B12')

setwd(sig_dir)
ROI <- geojson_sf('ROI.geojson')
ROI <- as_Spatial(ROI)

multitemporal_stacker(all_bands, raster_dir, "Xochimilco", ROI, 6)


color_plots <- function(img_number)
{
  par(mfrow = c(1,1))
  par(mfrow = c(1, 2))
  rgb_stack <- stack(brick_stack[['B04']][[img_number]], brick_stack[['B03']][[img_number]], brick_stack[['B02']][[img_number]])
  plotRGB(rgb_stack, r=1,g=2,b=3, stretch = "lin")
  rgb_stack <- stack(brick_stack[['B08']][[img_number]], brick_stack[['B03']][[img_number]], brick_stack[['B02']][[img_number]])
  plotRGB(rgb_stack, r=1,g=2,b=3, stretch = "lin")
  par(mfrow = c(1,1))
}

# EXAMPLE

color_plots(1) # RGB PLOTS OF FIRST LAYER OF STACK
color_plots(2) # RGB PLOTS OF SEDOND LAYER OF STACK
