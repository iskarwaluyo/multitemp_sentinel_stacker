library(xml2)
library(raster)
library(sf)
library(geojsonio)
library(colorspace)

# CREATE DIRECTORY PATHS
# MAIN ENVIRONMENT DIRECTORY
main_dir <- "~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/R"
# GIS DATA DIRECTORY
sig_dir <- "~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/SIG/"
# RASTER DATA DIRECTORY
raster_dir <- "~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/RASTER/"
# DIRECTORY TO STORE RESULTS
results_dir <- "~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/RESULTS/"

# FUNCTION I: MULTITEMPORAL STACKER
# MAKES STACKS OF SAME BANDWIDTH AND DIFFERENT BANDWIDTHS

multitemporal_stacker <- function(band, file_dir, roi){

  setwd(sig_dir)
  ROI <<- geojson_sf(paste0(roi,'.geojson'))
  ROI <<- as_Spatial(ROI)
  
  setwd(main_dir)
  
  raster_stack <- ""
  brick_stack <- ""
  
  setwd(raster_dir)
  setwd(paste0('./', file_dir, '/'))
  
  dir_list <- ""
  dir_list <- list.files(pattern="", full.names=TRUE)
  files <- ""
  band_name <- band

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
    
    file_i <<- list.files(pattern = band, full.names=TRUE)
    
    brick_stack[i] <- lapply(file_i, brick)
    # raster_stack[i] <<- lapply(file_i, readGDAL)
  }
  
  comando <<- paste0(band_name, " <<- stack(brick_stack)")
  eval(parse(text = comando))
  
  # SET CRS/PROJECTION
  crs(ROI) <- st_crs(brick_stack)
  
  # CROP
  comando <<- paste0(band_name, " <<- crop(",band_name,", ROI)")
  eval(parse(text = comando))
  
  # MASK
   comando <<- paste0(band_name, " <<- mask(",band_name,", ROI)")
   eval(parse(text = comando))
  
  # RENAME USING DATES
  comando <<- paste0("names(",band_name, ") <<- time_line")
  eval(parse(text = comando))

}

# COMPOSITE COLOR PLOTS
color_plot_singles <- function(img_number)
{
  true_color <- stack(B04[[img_number]],B03[[img_number]],B02[[img_number]])
  false_color <- stack(B08[[img_number]],B04[[img_number]],B03[[img_number]])
  
  plotRGB(true_color,
          r=1,g=2,b=3, 
          stretch = "lin")
  
  plotRGB(false_color,
          r=1,g=2,b=3, 
          stretch = "lin")
}

save(multitemporal_stacker, color_plot_singles, 
     main_dir, sig_dir, raster_dir, results_dir, 
     file = '~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/RDATA/RASTER_STACK.RData')
