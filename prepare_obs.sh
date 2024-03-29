#######################################################################
## Prepare reference data for 3DBC
## Reference data = seNorge_2018, KliNoGrid_16.12 and HySN2018v2005ERA5
#######################################################################
#BASEDIR=/lustre/storeB/users/andreasd/KiN_2023_data/3DBC/
BASEDIR=/lustre/storeC-ext/users/kin2100/MET/3DBC/application/CMIP6/work

###############
## Prepare dirs
###############
cd ${BASEDIR}
for var in pr tas sfcWind hurs ps rlds rsds #tasmin and tasmax are included in tas
 do mkdir -p ${var}/Obs
done

##################
## Link/merge data
##################

###################
## Precipitation
###################
cd ${BASEDIR}/pr/Obs/
ln -s /lustre/storeC-ext/users/kin2100/MET/ReferenceData/seNorge2018/seNorge2018_RR_????.nc .

##########################
## Temperature
## incl. min, max and mean
##########################
cd ${BASEDIR}/tas/Obs/
ln -s /lustre/storeC-ext/users/kin2100/MET/ReferenceData/seNorge2018/seNorge2018_????.nc .

#########
## Wind
#########
cd ${BASEDIR}/sfcWind/Obs/
ln -s /lustre/storeC-ext/users/kin2100/MET/ReferenceData/KlinoGrid/* .

#for ((y=1958;y<2015;y++))
# do ncrcat -x -v altitude /lustre/storeA/project/metkl/klinogrid/thredds/KliNoGrid_16.12/FFMRR-Nor/${y}/KliNoGrid_FFMRR-Nor_utm33_sN2_analysis_Nor_${y}??.nc KliNoGrid_FFMRR-Nor_utm33_sN2_analysis_Nor_${y}.nc
#done

#ncrcat -x -v altitude /lustre/storeA/project/metkl/klinogrid/thredds/KliNoGrid_16.12/FFMRR-Nor/2015/KliNoGrid_FFMRR-Nor_utm33_sN2_analysis_Nor_20150?.nc /lustre/storeB/users/andreasd/KiN_2023_data/extra_KliNoGrid_2015-2020/KliNoGrid_FFMRR-Nor_utm33_sN2_analysis_Nor_201501-05.nc

#export SKIP_SAME_TIME=1
#cdo mergetime -invertlat /lustre/storeB/users/andreasd/KiN_2023_data/extra_KliNoGrid_2015-2020/ffm24h06_2015.nc -selvar,windspeed_10m /lustre/storeB/users/andreasd/KiN_2023_data/extra_KliNoGrid_2015-2020/KliNoGrid_FFMRR-Nor_utm33_sN2_analysis_Nor_201501-05.nc KliNoGrid_FFMRR-Nor_utm33_sN2_analysis_Nor_2015.nc

#for ((y=2016;y<2021;y++))
 #do cdo -invertlat /lustre/storeB/users/andreasd/KiN_2023_data/extra_KliNoGrid_2015-2020/ffm24h06_${y}.nc KliNoGrid_FFMRR-Nor_utm33_sN2_analysis_Nor_${y}.nc
#done

#######################
## hurs, ps, rlds, rsds
#######################
for var in hurs ps rlds rsds
 do cd ${BASEDIR}/${var}/Obs/
 ln -s /lustre/storeC-ext/users/kin2100/MET/ReferenceData/HySN2018v2005ERA5/*${var}*nc4 . 
done

