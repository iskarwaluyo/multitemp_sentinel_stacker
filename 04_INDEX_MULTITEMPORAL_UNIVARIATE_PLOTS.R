library(gridExtra)
library(ggdist)
library(plyr)
library(dplyr)
library(broom)
library(gtsummary)
library(ggplot2)
library(summarytools)
library(moments)


index_mean_plotter <-  function(index, time_cat){
  
  melt_select <- paste0(index, '_df_melt')
  
  if(index == 'ndvi'){index_name = 'Normalized Difference Vegetation Index'}
  if(index == 'avi'){index_name = 'Advanced Vegetation Index'}
  if(index == 'bsi'){index_name = 'Barren Soil Index'}
  if(index == 'ndmi'){index_name = 'Normalized Difference Moisture Index'}
  if(index == 'ndwi'){index_name = 'Normalized Difference Water Index'}
  if(index == 'ui'){index_name = 'Urbanization Level Index'}
  if(index == 'mbi'){index_name = 'Modified Built-Up Index'}
  if(index == 'ndbi'){index_name = 'Normalized Difference Built-Up Index'}
  if(index == 'baei'){index_name = 'Built up Area Index'}
  
  comando <<- paste0(index, '_melt_p <<- ggplot(',melt_select,
                     ', aes(x=', time_cat ,', y=value, fill=year)) + 
    geom_violin(draw_quantiles = c(0.25, 0.5, 0.75)) + 
    labs(title = "', index_name, '",
         y="Mean Index Score",
         x="Time category") +
    theme(legend.position="none",
          axis.text = element_text(size = 11, face = "bold"),
          plot.title = element_text(size = 14, face = "bold"),
          plot.subtitle = element_text(size = 11, face = "italic"),
          axis.title = element_text(size = 14, face = "bold"),
          axis.text.x = element_text(angle = 30)) +
    scale_fill_brewer(palette = "Set3") ')
  
  
  eval(parse(text = comando))
  
}

index_mean_plotter('ndvi', 'year')
ndvi_melt_p

index_mean_plotter('ndvi', 'season')
ndvi_melt_p


# BY SEASON 

p1 <- ggplot(ndvi_df_melt, aes(x = season, y = value, fill=year)) + 
  geom_violin() + 
  labs(title="NDVI",
       subtitle="Normalized Difference Vegetation Index",
       y="Mean Index Score",
       x="Year") +
  theme(legend.position = "none")  +
  labs(fill='Outlet size') +
  scale_fill_brewer(palette = "Set3") 

p2 <- ggplot(ndwi_df_melt, aes(x=season, y=value, fill=year)) + 
  geom_violin() + 
  labs(title="NDWI",
       subtitle="Normalized Difference Water Index",
       y="Mean Index Score",
       x="Year") +
  theme(legend.position = "none")  +
  labs(fill='Outlet size') +
  scale_fill_brewer(palette = "Set3")

p3 <- ggplot(bsi_df_melt, aes(x=season, y=value, fill=year)) + 
  geom_violin() + 
  labs(title="BSI",
       subtitle="Bare Soil Index",
       y="Mean Index Score",
       x="Year") +
  theme(legend.position = "none")  +
  labs(fill='Outlet size') +
  scale_fill_brewer(palette = "Set3")

p4 <- ggplot(ndmi_df_melt, aes(x=season, y=value, fill=year)) + 
  geom_violin() + 
  labs(title="NDMI",
       subtitle="Normalized Difference Moisture Index",
       y="Mean Index Score",
       x="Year") +
  theme(legend.position = "none")  +
  labs(fill='Outlet size') +
  scale_fill_brewer(palette = "Set3") 

p5 <- ggplot(ndbi_df_melt, aes(x=season, y=value, fill=year)) + 
  geom_violin() + 
  labs(title="NDBI",
       subtitle="Normalized Difference Built-up Index",
       y="Mean Index Score",
       x="Year") +
  theme(legend.position = "none")  +
  labs(fill='Outlet size') +
  scale_fill_brewer(palette = "Set3") 

p6 <- ggplot(baei_df_melt, aes(x=season, y=value, fill=year)) + 
  geom_violin() + 
  labs(title="BAEI",
       subtitle="Built up Area Extarction Index",
       y="Mean Index Score",
       x="Year") +
  theme(legend.position = "none")  +
  labs(fill='Outlet size') +
  scale_fill_brewer(palette = "Set3") 

grid.arrange(p1, p2, p3, p4, p5, p6, ncol=3)

