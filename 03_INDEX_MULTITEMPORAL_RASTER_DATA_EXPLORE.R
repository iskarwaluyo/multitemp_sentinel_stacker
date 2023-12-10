library(xml2)
library(raster)
library(sf)
library(geojsonio)
library(colorspace)
library(ggplot2)
library(rasterVis)
library(data.table)

# ONLY RUN TO LOAD SAMPLE DATA. 
# load("~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/RDATA/INDEX_CALCULATION.RData")
# load("~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/RDATA/RASTER_STACK.RData")

setwd("~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/R/")


# RASTER TO DATA FRAME WITH MONTH AND YEAR FACTORS ('DUMMY VARIABLES')
index_time_melt <- function(index){
  
  comando <<- paste0(index, "_df <<- as.data.frame(",index,")")
  eval(parse(text = comando))
  
  comando <<- paste0("names(",index,"_df) <<- time_line")
  eval(parse(text = comando))
  
  comando <<- paste0(index, "_df_melt <<- melt(",index,"_df, level = 2)")
  eval(parse(text = comando))
  
  #comando <<- paste0(index, "_df_melt <<- na.omit(",index,"_df_melt)")
  #eval(parse(text = comando))
  
  comando <<- paste0(index, "_df_melt$month <<- format(as.POSIXct(",index,"_df_melt$variable),'%m')")
  eval(parse(text = comando))
  
  comando <<- paste0(index, "_df_melt$year <<- format(as.POSIXct(",index,"_df_melt$variable),'%Y')")
  eval(parse(text = comando))

}

index_season_melt <- function(index, low, high){
  
  comando <<- paste0(index, "_df_melt$season <<- ifelse("
                     ,index,"_df_melt[,3] == '01' | "
                     ,index,"_df_melt[,3] == '02' | "
                     ,index,"_df_melt[,3] == '03' | "
                     ,index,"_df_melt[,3] == '04' | "
                     ,index,"_df_melt[,3] == '11' | "
                     ,index,"_df_melt[,3] == '12', ", low,",", high,")")
  eval(parse(text = comando))
  
}

index_signature_grids <- function(index, include_season){
  
  # PLOTTING INDEX RESULTS
  comando <<- paste0(index,"_signature_plots_month <<- ggplot(data=",index,"_df_melt, aes(x = value, fill=year)) + 
  geom_density(adjust=1.5, alpha=.4) + 
  facet_wrap(vars(month), ncol = 3) + 
  theme(legend.position='right') +
  scale_fill_brewer(palette='Dark2')")
  eval(parse(text = comando))
  
  comando <<- paste0(index,"_signature_plots_year <<- ggplot(data=",index,"_df_melt, aes(x = value, fill=month)) + 
  geom_density(adjust=1.5, alpha=.4) + 
  facet_wrap(vars(year), ncol = 3) + 
  theme(legend.position='right') +
  scale_fill_brewer(palette='Paired')")
  eval(parse(text = comando))
  
if(include_season == TRUE){
  comando <<- paste0(index,"_signature_plots_season <<- ggplot(data=",index,"_df_melt, aes(x = value, fill=year)) + 
  geom_density(adjust=1.5, alpha=.4) + 
  facet_wrap(vars(season), ncol = 3) + 
  theme(legend.position='right') +
  scale_fill_brewer(palette='Accent')")
  eval(parse(text = comando))
}

}

# index_signature_grids('baei', FALSE)


index_month_compare <- function(index_melt_select, y, title){
  x <- index_melt_select
  index_select <<- subset(x, x$month == y)
  ggplot(data=index_select, aes(x=value, fill=year)) + 
  geom_density(adjust=1.5, alpha=.4) + 
    labs(title=title,
         y="Density",
         x="Index Score") +
    theme(legend.position = "none")  +
    scale_fill_brewer(palette = "Set3") +
   facet_wrap(vars(year)) + 
  theme(legend.position="bottom")
}


index_month_year <- function(index_melt_select, plot_title){
  x <- index_melt_select
  index_select <<- subset(x)
  ggplot(data=index_select, aes(x=value, fill=year)) + 
    geom_density(adjust=1.5, alpha=.4) + 
    labs(title=plot_title, subtitle = "Month compare by year",
         y="Density",
         x="Index Score") +
    theme(legend.position = "none")  +
    scale_fill_brewer(palette = "Set3") +
    facet_wrap(vars(month)) + 
    theme(legend.position="bottom")
}

# index_month_year(baei_df_melt, "BAEI")

# ONLY WORKS IF SEASON = TRUE AND SEASON PARAMETERS ARE DESIGNED

index_season_year <- function(index_melt_select, plot_title){
  x <- index_melt_select
  index_select <<- subset(x)
  ggplot(data=index_select, aes(x=value, fill=year)) + 
    geom_density(adjust=1.5, alpha=.4) + 
    labs(title=plot_title, subtitle = "Season compare by year",
         y="Density",
         x="Index Score") +
    theme(legend.position = "none") +
    scale_fill_brewer(palette = "Set3") + 
    facet_wrap(vars(season)) + 
    theme(legend.position="bottom")
}

# index_season_year(baei_df_melt, "BAEI")

save(index_time_melt, index_season_melt, index_signature_grids, 
     index_month_compare, index_month_year, index_season_year, 
     file = '~/sigdata/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/DATA/RDATA/INDEX_MELT.RData')


dfs <- ls()[sapply(mget(ls(), .GlobalEnv), is.data.frame)]
rm(dfs)
