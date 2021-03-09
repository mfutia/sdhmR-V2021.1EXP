################################################################################
## E. Polzer
## HW 5 (M2.5): Build Training Dataset 
################################################################################

# ## PREP::
## Root directory:
path.root <- "C:/Users/epolzer/Documents/sdhmR-V2021.1"
path.dat <- paste(path.root, "/sdhmR-V2021.1EXP/Data/exercise/traindat", sep = "")
path.mod2 <- paste(path.root, "/sdhmR-V2021.1EXP/Data/module02", sep = "")
path.gis <- paste(path.root, "/sdhmR-V2021.1EXP/Data/gis_layers", sep = "")
path.figs <- paste(path.root, "/sdhmR-V2021.1EXP/Figures", sep = "")
path.prj <- paste(path.root, "/sdhmR-V2021.1EXP/R_Code", sep = "")

## Source course CRSs:
setwd(path.prj)
source("prjs4_sdhmR.R") # source course CRSs
ls(pattern = "prj.")

library(raster)
library(sf)
################################################################################
######## START DATA INITIALIZATION::

## Load range-wide data:
#setwd(path.dat)*****
#tru.range <- read.csv("spp106pr_RANG_2.csv")******

## Load presence:absence dataframe:
setwd(path.mod2) # path to data
pres.abs <- get(load("range_pres.psu.RData")) # load presence:absence data

## Examine data structure:
dim(pres.abs) # examine
head(pres.abs, 2) # examine
table(pres.abs$RANG106) # examine frequencies

#setwd(path.mod2)
#range.bufR <- get(load("pied.framesR.RData"))***
#range.bufSF <- get(load("pied.framesSF.RData"))***
#range.bufSP <- get(load("pied.framesSP.RData"))***
range.bufpt <- get(load("pied.framesbufpt.RData"))
range.bufptR # examine cropping raster***
#plot(range.bufptR) # examine raster plot***

#range.indexFNET <- get(load("range.indexFNET.RData"))***
#range.ppsAx <- get(load("range_pres.psu.RData"))***
#p2.sppx <- get(load("range_pres.psu.RData"))***
#p2.modFRx <- get(load("range_pres.psu.RData"))***
#psu.bufptx <- get(load("range_pres.psu.RData"))***

################################################################################

################################################################################
######## START BUILD TOPO DATA 1 LAYER AT A TIME::
## ESRI.img files to raster import:
setwd("C:/Users/epolzer/Documents/sdhmR-V2021.1/sdhmR-V2021.1EXP/Data/exercise/preds")

# Joint import of predictor GIS variables into R: # includes projection!
img.list <- list.files(pattern = ".img$") # list of .img files; $ strips extra
img.list # examine
# loop for extracting data w/raster stack
layers <- {} # initialize (empty) list of raster layers
for (i in 1:length(img.list)) {
  r1 <- crop(raster(img.list[i]), range.bufptR) # crop pred var raster to buffer raster
  names(r1) <- strsplit(img.list[i], "_wgs.img") # assign name to raster
  layers <- c(layers, r1) # add raster to layer of rasters
}
layers

# Individual import:
etpt5 <- raster("etpt_5.img") # import .img w/projection
etpt6 <- raster("etpt_6.img") # import .img w/projection
etptsprin <- raster("etpt_sprin.img") # import .img w/projection
exp1nrm <- raster("exp1nrm.img") # import .img w/projection
exp3nrm <- raster("exp3nrm.img") # import .img w/projection
exp5nrm <- raster("exp5nrm.img") # import .img w/projection
mindyrav <- raster("mind_yr_av.img") # import .img w/projection
pradswdi <- raster("prad_sw_di.img") # import .img w/projection
precwhal <- raster("prec_w_hal.img") # import .img w/projection
precwinte <- raster("prec_winte.img") # import .img w/projection
taveshal <- raster("tave_s_hal.img") # import .img w/projection
tavesprin <- raster("tave_sprin.img") # import .img w/projection
tmaxshal <- raster("tmax_s_hal.img") # import .img w/projection
tmaxsumme <- raster("tmax_summe.img") # import .img w/projection
rough <- raster("rough_1k.img") # import
topos <- raster("topos.img") # import
 
## Compare raster projections; proj4 value returned # only needed if imported variables individually
# Individual comparison:
projection(etpt5) # verify projection
projection(etpt6) 
projection(etptsprin) 
projection(exp1nrm) 
projection(exp3nrm) 
projection(mindyrav)
projection(pradswdi)
projection(precwhal)
projection(precwinte)
projection(taveshal)
projection(tavesprin)
projection(tmaxshal)
projection(tmaxsumme)

## Compare raster resolutions:
## NOT SURE HOW TO PERFORM THIS FOR A LIST!

# Individual resolution comparison:
res(etpt5) # verify resolution
res(etpt6) 
res(etptsprin) 
res(exp1nrm)
res(exp3nrm) 
res(exp5nrm)
res(mindyrav)
res(pradswdi)
res(precwhal)
res(precwinte)
res(taveshal)
res(tavesprin)
res(tmaxshal)
res(tmaxsumme)
################################################################################

################################################################################
######## START EXTRACT FROM 1 DATA LAYER AT A TIME::
## Extract data from rasters:

# Individual extract:
et1 <- extract(etpt5, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(et1) # examine length of vector
length(which(is.na(et1))) # no NAs

et2 <- extract(etpt6, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(et2) # examine length of vector
length(which(is.na(et2))) # no NAs

et3 <- extract(etptsprin, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(et3) # examine length of vector
length(which(is.na(et3))) # no NAs

ex1 <- extract(exp1nrm, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(ex1) # examine length of vector
length(which(is.na(ex1))) # no NAs

ex3 <- extract(exp3nrm, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(ex3) # examine length of vector
length(which(is.na(ex3))) # no NAs

ex5 <- extract(exp5nrm, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(ex5) # examine length of vector
length(which(is.na(ex5))) # no NAs

mi1 <- extract(mindyrav, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(mi1) # examine length of vector
length(which(is.na(mi1))) # no NAs

pd1 <- extract(pradswdi, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(pd1) # examine length of vector
length(which(is.na(pd1))) # no NAs

pe1 <- extract(precwhal, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(pe1) # examine length of vector
length(which(is.na(pe1))) # no NAs

pe2 <- extract(precwinte, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(pe2) # examine length of vector
length(which(is.na(pe2))) # no NAs

ta1 <- extract(taveshal, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(ta1) # examine length of vector
length(which(is.na(ta1))) # no NAs

ta2 <- extract(tavesprin, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(ta2) # examine length of vector
length(which(is.na(ta2))) # no NAs

tm1 <- extract(tmaxshal, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(tm1) # examine length of vector
length(which(is.na(tm1))) # no NAs

tm2 <- extract(tmaxsumme, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(tm2) # examine length of vector
length(which(is.na(tm2))) # no NAs

ro1 <- extract(rough, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(ro1) # examine length of vector
length(which(is.na(ro1))) # no NAs

to1 <- extract(topos, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # basic extract 
length(to1) # examine length of vector
length(which(is.na(to1))) # no NAs

# Joint extract:
pied.tr.joint <- stack(layers) # create a raster stack
pied.tr.joint # examine stack
d1 <- extract(pied.tr.joint, pres.abs[, c("tr.wgs_x", "tr.wgs_y")]) # extract values from raster stack
head(d1, 2) # examine extracted matrix
length(which(is.na(d1)))
################################################################################

## Bind to new training dataframe:

## Individual bind and remove columns:
pied.tr <- cbind(pres.abs, et1, et2, et3, ex1, ex3, ex5, mi1, pd1, pe1, pe2, ta1, ta2, tm1, tm2, ro1, to1)
head(pied.tr, 2) # examine new dataframe
pied.tr.x <- dplyr::select(pied.tr, -c('wgs_xF', 'wgs_yF', 'cell.wgs_x', 'cell.wgs_y')) # remove the wgs_xF and cell.wgs_x columns, since all coords are in tr.wgs_x
head(pied.tr.x, 2)
length(pied.tr.x) # NAs NOT GONE!!! Why not...

## Joint/Stacked bind and remove columns:
pied.tr.joint <- cbind(pres.abs, d1) # bind values to presabs training dataframe
head(pied.tr.joint, 2) # examine new training dataframe
pied.tr.y <- dplyr::select(pied.tr, -c('wgs_xF', 'wgs_yF', 'cell.wgs_x', 'cell.wgs_y')) # remove the wgs_xF and cell.wgs_x columns, since all coords are in tr.wgs_x
head(pied.tr.y, 2) # new training dataframe
length(pied.tr.y) # NAs gone - NO

## Export files if desired:
setwd(path.mod2)
pied.tr.y
save(pied.tr.y, file = "pied.tr.joint.RData") # save .RData - pres/abs plus stacked raster, joint 
write.csv(pied.tr.y, file = "pied.tr.joint.csv", row.names = F) # save .csv - training data, joint
st_write(pied.tr.y, dsn = ".", layer = "pied.tr.joint", driver = "ESRI Shapefile",
         delete_layer = T, delete_dsn = T) #point shapefile in ESRI format

pied.tr.x
save(pied.tr.x, file = "pied.tr.RData") # save .RData - pres/abs plus stacked raster, individual
write.csv(pied.tr.x, file = "pied.tr.csv", row.names = F) # save .csv - training data, individual
st_write(pied.tr.x, dsn = ".", layer = "pied.tr", driver = "ESRI Shapefile",
         delete_layer = T, delete_dsn = T) #point shapefile in ESRI format
################################################################################

## START BUILD TOPO DATA LOOP::
## Load pres.abs data:
setwd(path.mod2)
pres.abs <- get(load("pied.PPsA.RData"))
head(pres.abs, 2) # examine

## Remove NAs from pres.abs data:
pres.abs.x <- dplyr::select(pres.abs, -c('wgs_xF', 'wgs_yF', 'cell.wgs_x', 'cell.wgs_y')) # remove the wgs_xF and cell.wgs_x columns, since all coords are in tr.wgs_x
head(pres.abs.x, 2)

## Load buffer data:
load("pied.framesR.RData") # load buffers: use range.bufptR
range.bufptR # examine cropping raster # line 70 HW4
plot(range.bufptR) # examine raster plot

## Extract topo variables (wgs projection):
setwd("C:/Users/epolzer/Documents/sdhmR-V2021.1/sdhmR-V2021.1EXP/Data/exercise/preds")
topo.list <- list.files(pattern = "img$") # list of .img files
topo.list # examine

## Loop for extracting topo data w/raster stack:
layers <- {} # initialize (empty) list of raster layers
for (i in 1:length(topo.list)) {
  r1 <- crop(raster(topo.list[i]), range.bufptR) # crop pred var raster to buffer
  names(r1) <- strsplit(topo.list[i], "_wgs.img") # assign name to raster
  layers <- c(layers, r1) # add raster to layer of rasters
}
layers # examine raster stack; return is a list of raster layers

## Build the raster stack:
pied.topoDOM <- stack(layers) # create a raster stack
pied.topoDOM # examine stack
head(pied.topoDOM, 2)

## Extract from stack and remove NAs: 
t1 <- extract(pied.topoDOM, pres.abs.x[, c("tr.wgs_x", "tr.wgs_y")]) # extract values from raster stack
head(t1, 2)

## Extract topo data w/out raster stack:
pied.trTOPO <- cbind(pres.abs.x, t1) # bind to training dataframe
head(pied.trTOPO, 2)
pied.trTOPO.x <- dplyr::select(pied.trTOPO, -c()) ##############################
head(pied.trTOPO.x, 2) # examine training data frame

## Write out data files if desired:
setwd(path.mod2)
save(pied.topoDOM, file = "pied.topoDOM.RData") # save .RData
write.csv(pied.trTOPO, file = "pied.trTOPO.csv", row.names = F) # save .csv
save(pied.trTOPO, file = "pied.trTOPO.RData") # save .RData
################################################################################