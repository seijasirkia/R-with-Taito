#Make input and ougdatput folders.
mainDir <- "~/R_spatial_2017"
tiffFolder <- "1_tiff"
gridFolder <- "2_grid"
shapeFolder <- "3_shape"
imageFolder <- "4_image"

setwd(mainDir)

#Make folders for files, do not make, if already exist
if (!dir.exists(file.path(mainDir, tiffFolder))){
    dir.create(file.path(mainDir, tiffFolder))
}

if (!dir.exists(file.path(mainDir, shapeFolder))) {
    dir.create(file.path(mainDir, shapeFolder))
}

if (!dir.exists(file.path(mainDir, imageFolder))) {
  dir.create(file.path(mainDir, imageFolder))
}

if (!dir.exists(file.path(mainDir, gridFolder))) {
  dir.create(file.path(mainDir, gridFolder))
}

cl<-getMPIcluster()

funtorun<-function(mapsheet) {
  # load RSAGA and rgdal libraries
  library(RSAGA)
  library(rgdal)
  
  mainDir <- "~/R_spatial_2017"
  tiffFolder <- "1_tiff"
  gridFolder <- "2_grid"
  shapeFolder <- "3_shape"
  imageFolder <- "4_image"

  #Download the National Land Survey's 10m DEM from Kapsi
  url <- paste("http://kartat.kapsi.fi/files/korkeusmalli/hila_10m/etrs-tm35fin-n2000/V4/V41/",mapsheet,".tif",sep="")
  inputfile <- file.path(mainDir, tiffFolder, basename(url))
  
  if (!file.exists(inputfile)){
    download.file(url, inputfile, mode="wb")
  }
  
  # convert .tif to RSAGA grid fromat
  inputfile <- file.path(tiffFolder, basename(url))
  gridfile <- file.path(gridFolder, mapsheet)
  
  rsaga.import.gdal(inputfile, gridfile)
  
  # Calculate contours with 50m intervals, from 200 to 750m
  shapefile <-file.path(shapeFolder,mapsheet)
  rsaga.contour(gridfile, shapefile, 50, 200, 750, env = rsaga.env())
  
  #Plot contours to a .png file
  shp <- readOGR(shapeFolder,mapsheet)
  pngfilename = paste(mapsheet, ".png", sep="")
  pngfile <-file.path(imageFolder,pngfilename)
  png(filename=pngfile)
  plot(shp)
  dev.off()
}

mapsheets <- c("V4131","V4132","V4133")

system.time(a<-clusterApply(cl,mapsheets,funtorun))
a

stopCluster(cl)

quit()