######################################
## Prepare input data for 3DBC
## Input data = bias-adjusted RCM data
######################################
BASEDIR=/lustre/storeC-ext/users/kin2100/MET/3DBC/application/CMIP6
cd ${BASEDIR}

################################
## Link data from NVE on ext-PPI
################################
# Current climate
#################
for var in pr tas tasmin tasmax sfcWind hurs ps rlds rsds
 do mkdir -p ${BASEDIR}/${var}/Cur
 cd ${BASEDIR}/${var}/Cur
 for model in cnrm-r1i1p1f2-hclim ecearthveg-r1i1p1f1-hclim noresm-r1i1p1f1-hclim #hadgem-r1i1p1-rca ecearth-r12i1p1-rca hadgem-r1i1p1-remo noresm-r1i1p1-rca cnrm-r1i1p1-aladin mpi-r1i1p1-cclm  cnrm-r1i1p1-racmo  mpi-r2i1p1-remo ecearth-r12i1p1-cclm  ecearth-r3i1p1-hirham  noresm-r1i1p1-remo
  do ln -s /lustre/storeC-ext/users/kin2100/NVE/EQM/CMIP6/${model}/${var}/hist/* .
 done
done

# Future climate
################
cd ${BASEDIR}

for var in pr tas tasmin tasmax sfcWind hurs ps rlds rsds
 do mkdir -p ${BASEDIR}/${var}/Fut
 cd ${BASEDIR}/${var}/Fut
 for model in cnrm-r1i1p1f2-hclim ecearthveg-r1i1p1f1-hclim  noresm-r1i1p1f1-hclim #hadgem-r1i1p1-rca #ecearth-r12i1p1-rca hadgem-r1i1p1-remo noresm-r1i1p1-rca cnrm-r1i1p1-aladin mpi-r1i1p1-cclm  cnrm-r1i1p1-racmo  mpi-r2i1p1-remo ecearth-r12i1p1-cclm  ecearth-r3i1p1-hirham  noresm-r1i1p1-remo
  do ln -s /lustre/storeC-ext/users/kin2100/NVE/EQM/CMIP6/${model}/${var}/ssp370/* .
 done
done


