# multitemp_sentinel_stacker

# OVERVIEW

This is a demo of the code used to create and analyze multitemporal stacks of Sentinel 2A data and corresponding spectral index calculations. This code was published in [Advances in Geospatial Data Science](https://link.springer.com/conference/igisc) presented in the 2023  [IGISc](https://igisc.org/) under the title "Estimating land cover changes using multi-temporal spectral index raster stacks in protected national areas of Xochimilco". This code is open source, but please cite any use of the code. 

Waluyo, I., (2023). Estimating land cover changes using multi-temporal spectral index raster stacks in protected national areas of Xochimilco. Advances in Geospatial Data Science.

The scripts are divided in four parts:

1. 01_RASTER_STACK.R - Searches for all Sentinel2A data in a directory and creates stacks based on the sensing dates for each of the bandwidths included in Sentinel2A data. 
2. 02_INDEX_CALCULATION.R - Calculates vegetation indexes (ndvi, evi, avi, savi), Soil indexes (bsi), Water indexes (ndmi, ndwi) and Built environment indexes (baei, ui, ndbi, mbi).
3. 03_INDEX_MULTITEMPORAL_RASTER_DATA_EXPLORE.R - Creates data.frame of the raster data of each of the multitemporal stacks and visualizations to compare results.
4. 04_INDEX_MULTITEMPORAL_UNIVARIATE_PLOTS.R - Creates violin plots that compare the mean index values by month, year and season. 
5. 05_INDEX_MULTITEMPORAL_UNIVARIATE_STATISTICS.R - Creates tables that compare the mean index values by month, year and season.

# PART 0: Directory and data setup

## Directory setup
