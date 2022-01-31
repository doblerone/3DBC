######################################################
## Prepare output data for 3DBC
## Output data = post-processed bias-adjusted RCM data
######################################################
BASEDIR=/lustre/storeB/users/andreasd/KiN_2023_data/3DBC/
cd ${BASEDIR}

#######################################################
## Prepare files
## The values will be overwritten by the 3DBC R-scripts
#######################################################
# Current climate
#################
for var in pr tas tasmin tasmax sfcWind hurs ps rlds rsds
 do mkdir -p ${BASEDIR}/${var}/CurC/app
 cd ${BASEDIR}/${var}/CurC/app
 for model in NORESM_REMO #EC-EARTH_DMI-HIRHAM5 EC-EARTH_CCLM
  do cp /lustre/storeB/users/andreasd/KiN_2023_data/bc_from_NVE/${model}/${var}/hist/* .
 done
 #Rename files
 rename s/_eqm/_3dbc-eqm/ *nc4
done

#################
# Future climate
#################
for var in pr tas tasmin tasmax sfcWind hurs ps rlds rsds
 do mkdir -p ${BASEDIR}/${var}/FutC
 cd ${BASEDIR}/${var}/FutC
 for model in NORESM_REMO # EC-EARTH_DMI-HIRHAM5 EC-EARTH_CCLM
  do cp /lustre/storeB/users/andreasd/KiN_2023_data/bc_from_NVE/${model}/${var}/rcp??/* .
 done
 #Rename files
 rename s/_eqm/_3dbc-eqm/ *nc4
done

cd ${BASEDIR}

for var in pr tas tasmin tasmax sfcWind hurs ps rlds rsds
 #Adjust global attributes
 do /home/andreasd/Scripts/KiN2100/3DBC/app/gitHub/3DBC_v2023/ncatted_${var}.sh
done

