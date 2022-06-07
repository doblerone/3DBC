######################################
## Prepare input data for 3DBC
## Input data = bias-adjusted RCM data
######################################
BASEDIR=/lustre/storeB/users/andreasd/KiN_2023_data/3DBC/
cd ${BASEDIR}

#########################
## Copy data from ext PPI
#########################
# Current climate
#################
for var in pr tas tasmin tasmax sfcWind hurs ps rlds rsds
 do mkdir -p ${BASEDIR}/${var}/Cur
 cd ${BASEDIR}/${var}/Cur
 for model in mpi-r1i1p1-cclm #cnrm-r1i1p1-racmo mpi-r2i1p1-remo ecearth-r12i1p1-cclm  ecearth-r3i1p1-hirham  noresm-r1i1p1-remo
  do rsync -avu /lustre/storeC-ext/users/kin2100/NVE/EQM/${model}/${var}/hist/* .
 done
done

# Future climate
################
cd ${BASEDIR}

for var in pr tas tasmin tasmax sfcWind hurs ps rlds rsds
 do mkdir -p ${BASEDIR}/${var}/Fut
 cd ${BASEDIR}/${var}/Fut
 for model in mpi-r1i1p1-cclm #cnrm-r1i1p1-racmo mpi-r2i1p1-remo ecearth-r12i1p1-cclm  ecearth-r3i1p1-hirham  noresm-r1i1p1-remo
  do rsync -avu /lustre/storeC-ext/users/kin2100/NVE/EQM/${model}/${var}/rcp??/* .
 done
done


