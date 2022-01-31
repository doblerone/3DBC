######################################
## Prepare input data for 3DBC
## Input data = bias-adjusted RCM data
######################################
BASEDIR=/lustre/storeB/users/andreasd/KiN_2023_data/3DBC/
cd ${BASEDIR}

############
## Link data
############
# Current climate
#################
for var in pr tas tasmin tasmax sfcWind hurs ps rlds rsds
 do mkdir -p ${BASEDIR}/${var}/Cur
 cd ${BASEDIR}/${var}/Cur
 ln -s /lustre/storeB/users/andreasd/KiN_2023_data/bc_from_NVE/*/${var}/hist/* .
done

# Future climate
################
cd ${BASEDIR}

for var in pr tas tasmin tasmax sfcWind hurs ps rlds rsds
 do mkdir -p ${BASEDIR}/${var}/Fut
 cd ${BASEDIR}/${var}/Fut
 ln -s /lustre/storeB/users/andreasd/KiN_2023_data/bc_from_NVE/*/${var}/rcp??/* .
done

cd ${BASEDIR}
