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

setwd("~/archivos2/sigdata/PROYECTOS/MULTITEMPSTACKER/R/")

index_time_melt <- function(index, rainy_months){
  
  comando <- paste0('index_data <<- eval(',index,')')
  eval(parse(text = comando))

  index_melt_df <<- list()
  index_melt_df <<- as.data.frame(index_data)
  names(index_melt_df) <<- time_line
  index_melt_df <<- melt(as.data.table(index_melt_df), level = 2)
  index_melt_df <<- na.omit(index_melt_df)
  index_melt_df$month <<- format(as.POSIXct(index_melt_df$variable),'%m')
  index_melt_df$year <<- format(as.POSIXct(index_melt_df$variable),'%Y')
  index_melt_df$season <<- ifelse(grepl(paste(rainy_months, collapse="|"), 
                                        index_melt_df$month) == TRUE, 'High precipitation', 'Low precipitation')
  
  index_melt_df <<- as.data.frame(index_melt_df)
  
  if(index == 'ndvi'){index_name = 'Normalized Difference Vegetation Index'}
  if(index == 'avi'){index_name = 'Advanced Vegetation Index'}
  if(index == 'savi'){index_name = 'Soil Adjusted Vegetation Index'}
  if(index == 'bsi'){index_name = 'Barren Soil Index'}
  if(index == 'ndmi'){index_name = 'Normalized Difference Moisture Index'}
  if(index == 'ndwi'){index_name = 'Normalized Difference Water Index'}
  if(index == 'ui'){index_name = 'Urbanization Level Index'}
  if(index == 'mbi'){index_name = 'Modified Built-Up Index'}
  if(index == 'baei'){index_name = 'Built up Area Index'}
  
  year_melt <<-ddply(index_melt_df, .(year), summarize, mean=mean(value))
  year_season_melt <<-ddply(index_melt_df, .(season, year), summarize, mean=mean(value))
  year_month_melt <<-ddply(index_melt_df, .(month, year), summarize, mean=mean(value))
  season_melt <<-ddply(index_melt_df, .(year, season), summarize, mean=mean(value))
  
  signature_plots_month <<- ggplot(data=index_melt_df, aes(x = value, fill=year)) + 
    geom_density(adjust=1.5, alpha=.4) +
    labs(title= paste0("Density Plot ", index_name), subtitle = "Month compare by year",
         y="Density",
         x="Index Score") +
    facet_wrap(vars(month), ncol = 3) + 
    theme(legend.position='right') +
    scale_fill_brewer(palette='Dark2')
  
  signature_plots_year <<- ggplot(data=index_melt_df, aes(x = value, fill=month)) + 
    geom_density(adjust=1.5, alpha=.4) + 
    labs(title= paste0("Density Plot ", index_name), subtitle = "Year compare by month",
         y="Density",
         x="Index Score") +
    facet_wrap(vars(year), ncol = 3) + 
    theme(legend.position='right') +
    scale_fill_brewer(palette='Paired')
  
  signature_plots_month_year <<- ggplot(data=index_melt_df, aes(x=value, fill=year)) + 
    geom_density(adjust=1.5, alpha=.4) + 
    labs(title= paste0(index_name, " Density Plot"), subtitle = "Season compare by year",
         y="Density",
         x="Index Score") +
    theme(legend.position = "none")  +
    scale_fill_brewer(palette = "Set3") +
    facet_wrap(vars(season)) + 
    theme(legend.position="bottom")
  
  signature_plots_season_year <<- ggplot(data=index_melt_df, aes(x=value, fill=season)) + 
    geom_density(adjust=1.5, alpha=.4) + 
    labs(title= paste0("Density plot ", index_name), subtitle = "Year compare by season",
         y="Density",
         x="Index Score") +
    theme(legend.position = "none")  +
    scale_fill_brewer(palette = "Set3") +
    facet_wrap(vars(year)) + 
    theme(legend.position="bottom")
  
}

rainy_months = c('05', '06', '07', '08', '09', '10')

index_time_melt('baei', rainy_months)


year_melt
year_season_melt
year_month_melt
season_melt

signature_plots_month
signature_plots_season_year
signature_plots_month_year
