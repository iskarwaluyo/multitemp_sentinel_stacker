library(xml2)
library(raster)
library(sf)
library(geojsonio)
library(colorspace)
library(ggplot2)
library(rasterVis)
library(data.table)
library(gridExtra)
library(plyr)
library(summarytools)
library(broom)


# ONLY RUN TO LOAD SAMPLE DATA. 
# load("~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/RDATA/INDEX_CALCULATION.RData")
# load("~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/RDATA/RASTER_STACK.RData")
# load("~/sigdata/archivos2/sigdata/PROYECTOS/CHINAMPAS/DATA/RDATA/INDEX_MELT_DATA.RData")


# UNIVARIATE SUMMARY FUNCTION
raster_stack_univariate <- function(raster_df_melt){
  
  year_univariate <<- raster_df_melt %>%  
    dplyr::group_by(year) %>% 
    descr(value)
  
  month_univariate <<- raster_df_melt %>%  
    dplyr::group_by(month) %>% 
    descr(value)
  
  season_univariate <<- raster_df_melt %>%  
    dplyr::group_by(season) %>% 
    descr(value)
}

raster_stack_univariate(index_melt_df)


# T-TEST FUNCTION
raster_ttest <- function(raster_df_select, month){
  
  g <<- month
  t_results <<- ""
  raster_df_select <- na.omit(raster_df_select)
  
  raster_month_select <<- subset(raster_df_select, raster_df_select$month == g)
  
  rms_split <<- split(raster_month_select, raster_month_select$year)
  m <<- length(rms_split)
  
  if(length(unique(rms_split)) > 1){
    for(i in 1:m){
      j = i+1
      if(j<m){
        
        if (var(rms_split[[i]]$value) == var(rms_split[[j]]$value))
        {
          equal_variance = TRUE
        }
        
        t_results <<- as.data.frame(raster_month_select %>% 
                                      group_by(year) %>% 
                                      do(tidy(t.test(.$value))))
        print(t_results)
      }
      
    }
  }
}

raster_ttest(index_melt_df, '04')
