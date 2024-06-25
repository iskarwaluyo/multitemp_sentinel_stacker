# Multitemporal Stacker

This is a demo of the code used to create and analyze multitemporal stacks of Sentinel 2A data and corresponding spectral index calculations. This code was published in [Advances in Geospatial Data Science](https://link.springer.com/conference/igisc) presented in the 2023  [IGISc](https://igisc.org/) under the title "Estimating land cover changes using multi-temporal spectral index raster stacks in protected national areas of Xochimilco". This code is open source, but please cite any use of the code. 

Waluyo, I., (2023). Estimating land cover changes using multi-temporal spectral index raster stacks in protected national areas of Xochimilco. Advances in Geospatial Data Science.

The scripts are divided in four parts:

1. 01_RASTER_STACK.R - Searches for all Sentinel2A data in a directory and creates stacks based on the sensing dates for each of the bandwidths included in Sentinel2A data. 
2. 02_INDEX_CALCULATION.R - Calculates vegetation indexes (ndvi, evi, avi, savi), Soil indexes (bsi), Water indexes (ndmi, ndwi) and Built environment indexes (baei, ui, ndbi, mbi).
3. 03_INDEX_MULTITEMPORAL_RASTER_DATA_EXPLORE.R - Creates data.frame of the raster data of each of the multitemporal stacks and visualizations to compare results.
4. 04_INDEX_MULTITEMPORAL_UNIVARIATE_STATISTICS.R - Creates tables that compare the mean index values by month, year and season.
5. 05_DEMO_README.Rmd - Markdown document that demos the functions created in the other 4 R files.

## PART 0: Directory and data setup

### Directory setup

Before running the code, it is recommended to set up a project directory with 3 sub directories as follows, although, the code can be adjusted as the user prefers. 

- Directory 0: Project directory 
- Directory 1: Create a directory named 'RASTER' where user stores all downloaded Sentinel2A files. 
- Directory 2: Create a directory named 'SIG' where user stores shape files of the region of interest (ROI) that are used to clip the raster images
- Directory 3: Create a directory named 'RDATA' where the code will save RData files contaning objects of each step

The first lines of the first script set up these directories as follows:

```{r, eval = FALSE, echo = FALSE}
# DIRECTORY 0: PROJECT DIRECTORY
main_dir <- "CONTAINS R SCRIPTS AND DATA"

# DIRECTORY 1: RASTER DATA DIRECTORY
raster_dir <- "CONTAINS SENTINEL 2A RASTERS"

# DIRECTORY 2: GIS DATA DIRECTORY
sig_dir <- "CONTAINS REGION OF INTEREST VECTOR DATA"

# DIRECTORY TO STORE RESULTS
results_dir <- "CONTAINS SCRIPS RESULTS"
```

Directories can have different names, but be sure to adjust the code to read the files. 

### Data setup

Download and decompress Sentinel 2A data into the 'RASTER' directory. The demo uses 34 Sentinel 2A MSI level 1-C images downloaded from Copernicus Hub from orbit 69 between 2015 and 2023, with a maximum cloud coverage of 10%. 

Download demo raster data: [DEMO_RASTER DATA](https://drive.google.com/file/d/1uv8kcEHGcZCpoQdSaaWPl2B_niraLYks/view?usp=sharing)

Download demo GIS data: [DEMO GIS DATA](https://drive.google.com/file/d/1sDa7dLhdUKk3AytIihkT5dZwX6pB-ieY/view?usp=sharing)

Download demo RData data: [DEMO RDATA](https://drive.google.com/file/d/1hxbWovXeKH0vcjZcxpSC1ozv-l9XWC-R/view?usp=sharing)

For more information about Sentinel 2A level 1-C images: [SENTINEL 2A](https://sentinel.esa.int/web/sentinel/user-guides/sentinel-2-msi/product-types/level-1c)

Create a shape file of the boundaries of your region of interest and save it to the 'SIG' directory. The shape file provided for the demo is for the Ejidos of Xochimilco and San Gregorio Atlapulco in Xochimilco, Mexico City. 

Download sample ROI shape file: [LINK](https://raw.githubusercontent.com/iskarwaluyo/multitemp_sentinel_stacker/main/ROI.geojson)

All R scripts should be placed in the project directory. Remember to configure your directories as explained above. 

