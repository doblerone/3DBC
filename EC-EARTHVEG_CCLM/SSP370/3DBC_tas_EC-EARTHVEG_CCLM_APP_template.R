## An implementation of
## "A Resampling Approach for Correcting Systematic Spatiotemporal Biases for Multiple Variables in a Changing Climate"
## by Mehrotra and Sharma (2019), Water Resources Research, 55(1), pp.754-770, doi: 10.1029/2018WR023270
## Refered to as 3DBC (3-dimensional bias-correction), as it keeps inter-variable, temporal and spatial consistencies from the reference data set.
## Basically a smart combination of quantile-mapping (or any usual bias-correction method) and Schaake Shuffle
###
### Implementation by A. Dobler, summer 2021
### andreas.dobler@met.no

library(ncdf4)

#some print output
print(paste("Processing year",YEAR))
RefYear <- YEAR

if (YEAR > 2020 & YEAR < 2040)
  RefYear <- YEAR - 20
if (YEAR >= 2040)
  RefYear <- YEAR - 80

print(paste("Using annual cycle from",RefYear))

# Split the domain into parts with about the same number of non-NA grid points (to save memory)
# eqm data: 1195x1550=1'852'250 gps with 354'448 non-NA (ca. 19%)
# use split.Domain.R to get the indices (idy)
idy <- c(1,168,222,265,304,347,426,627,791,908,1008,1068,1116,1163,1208,1251,1295,1340,1388,1443)
szy <- diff(c(idy,1551))

print(paste("Splitting domain into",length(idy),"parts (to save memory)"))
print("==========================================")

for (p in 1:length(idy))
{
  #some print output
  print(paste("Started part",p,"on", date()))
  
  #read data
  nc <- nc_open(paste("/lustre/storeC-ext/users/kin2100/MET/3DBC/application/CMIP6/work/tas/Obs/seNorge2018_",RefYear,".nc",sep=""))
  ObsA <- ncvar_get(nc,"tg",start = c(1,idy[p],1), count=c(-1,szy[p],-1)) + 273.15 #convert to K
  nc_close(nc)

  refsimfile <- paste("/lustre/storeC-ext/users/kin2100/MET/3DBC/application/CMIP6/work/tas/Cur/ecearthveg-r1i1p1f1-cclm_hist_eqm-sn2018v2005_rawbc_norway_1km_tas_daily_",RefYear,".nc4",sep="")
  if (RefYear > 2020)
    refsimfile <- paste("/lustre/storeC-ext/users/kin2100/MET/3DBC/application/CMIP6/work/tas/Fut/ecearthveg-r1i1p1f1-cclm_ssp370_eqm-sn2018v2005_rawbc_norway_1km_tas_daily_",RefYear,".nc4",sep="")
  
  nc <- nc_open(refsimfile)
  CurA <- ncvar_get(nc,"tas",start = c(1,idy[p],1), count=c(-1,szy[p],-1))
  nc_close(nc)
  
  #define mask with grid points with values
  ValMask <- which(!is.na(CurA[,,1]) ,arr.ind=T)
  NofPoints <- dim(ValMask)[1]
  
  nc <- nc_open(paste("/lustre/storeC-ext/users/kin2100/MET/3DBC/application/CMIP6/work/tas/Fut/ecearthveg-r1i1p1f1-cclm_ssp370_eqm-sn2018v2005_rawbc_norway_1km_tas_daily_",YEAR,".nc4",sep=""))
  FutA <- ncvar_get(nc,"tas",start = c(1,idy[p],1), count=c(-1,szy[p],-1))
  nc_close(nc)
  
  #reading done
  print(paste0(NofPoints," points read"))
  
  #create arrays for corrected data
  FutCA <- array(NA,dim(FutA))
  
  #loop over grid pointss
  for (i in 1:NofPoints)  
  {
    x <- ValMask[i,1]
    y <- ValMask[i,2]
    
    Obs <- ObsA[x,y,]
    Cur <- CurA[x,y,]
    Fut <- FutA[x,y,]
    
    #2100 non-leap year issue: remove last day from ref
    if(YEAR==2100)
    {
      Obs <- Obs[-366]
      Cur <- Cur[-366]
    }
    
    #number of values
    nod <- length(Obs)
    nodp1 <- nod+1
    
    #Rank data in descending order
    RankO <- nodp1 -  rank(Obs, ties.method = "first")
    RankC <- nodp1 -  rank(Cur, ties.method = "first")
    RankF <- nodp1 -  rank(Fut, ties.method = "first")
    
    #Cummulative probabilty
    ProbO <- 1-RankO/nodp1
    ProbC <- 1-RankC/nodp1
    ProbF <- 1-RankF/nodp1
    
    #Gaussian transformation
    GaussO <- qnorm(ProbO)
    GaussC <- qnorm(ProbC)
    GaussF <- qnorm(ProbF)
    
    #Calculate lag-one autocorrelations
    rO <- acf(GaussO,plot=F,lag.max=1)$acf[2]
    rC <- acf(GaussC,plot=F,lag.max=1)$acf[2]
    rF <- acf(GaussF,plot=F,lag.max=1)$acf[2]
    
    #Remove rO from GaussO
    GaussOR <- GaussO/sqrt(1-rO*rO)
    GaussOR[2:nod] <- (GaussO[2:nod]-rO*GaussO[1:(nod-1)])/sqrt(1-rO*rO) #from 2nd time step
    
    #Calculate corrected autocorrelation
    rN <- ((1+rF) / (1+rC) * (1+rO) - (1-rF) / (1-rC) * (1-rO) ) / ((1+rF) / (1+rC) * (1+rO) + (1-rF) / (1-rC) * (1-rO) ) 
    
    #Add rN to GaussOR. Note: Gauss for current climate equals GaussO!
    GaussFC <- sqrt(1-rN*rN) %*% t(GaussOR)
    for (t in 2:nod)
      GaussFC[,t] <- rN*GaussFC[,t-1] + sqrt(1-rN*rN) %*% t(GaussOR[t]) #from 2nd time step
    
    ##Rank and reorder values
    RankFC <- nodp1 -  rank(GaussFC,ties.method = "first")
    FutCA[x,y,] <- sort(Fut,decreasing = TRUE)[RankFC]
  }
  #That's all :-)
  
  #Write to NetCDF
  nc <- nc_open(paste("/lustre/storeC-ext/users/kin2100/MET/3DBC/application/CMIP6/work/tas/FutC/ecearthveg-r1i1p1f1-cclm_ssp370_3dbc-eqm-sn2018v2005_rawbc_norway_1km_tas_daily_",YEAR,".nc4",sep=""),write=TRUE)
  ncvar_put(nc,"tas",FutCA,start = c(1,idy[p],1), count=c(-1,szy[p],-1))
  nc_close(nc)
  
  rm(Obs,CurA,FutA,FutCA,ValMask)
  gc(full=TRUE)               
  
}

print("==========================================")
print(paste("Year",YEAR,"done."))

rm(list = ls(all.names = TRUE)) #clear environment
gc()                            #free up memrory and report the memory usage.

print("==========================================")
print("Recompression")
ifile <- paste0("/lustre/storeC-ext/users/kin2100/MET/3DBC/application/CMIP6/work/tas/FutC/ecearthveg-r1i1p1f1-cclm_ssp370_3dbc-eqm-sn2018v2005_rawbc_norway_1km_tas_daily_",YEAR,".nc4")
ifile_tmp <- paste0(ifile,"_tmp")
system(paste("mv",ifile,ifile_tmp))
system(paste("nccopy -d 1 -s", ifile_tmp,ifile))
system(paste("rm",ifile_tmp))
print("Done.")

