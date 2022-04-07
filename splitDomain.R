# Split the domain into N parts with about the same number of non-NA grid points (to save memory in furhter calculations)
# eqm data: 1195x1550=1'852'250 gps with 354'448 non-NA (ca. 19%)
library(ncdf4)

maskfile <- "https://thredds.met.no/thredds/dodsC/metusers/andreasd/Masks/HydrologicalNorwayMaskOnSeNorgeGrid.nc"

nc <- nc_open(maskfile)
nonna <- !is.na(ncvar_get(nc,"mask"))
nc_close(nc)

nonna_percol <- colSums(nonna)

for (N in c(10,17,20))
{
  temp = floor(sum(nonna_percol)/N)
  idy <- round(c(0, which(c(0, diff(cumsum(nonna_percol) %% temp)) < 0)[1:(N-1)]))+1
  cat(idy,sep = ",")
  
  #check
  szy <- diff(c(idy,1551))
  for (i in 1:N)
    print(sum(nonna[,idy[i]:(idy[i]+szy[i]-1)]))
}

