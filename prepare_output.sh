######################################################
## Prepare output data for 3DBC
## Output data = post-processed bias-adjusted RCM data
######################################################
#BASEDIR=/lustre/storeB/users/andreasd/KiN_2023_data/3DBC/
BASEDIR=/lustre/storeC-ext/users/kin2100/MET/3DBC/application/CMIP6/work
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
 for model in ecearth-r1i1p1f1-racmo ecearthveg-r1i1p1f1-cclm #ecearthveg-r1i1p1f1-hclim cnrm-r1i1p1f2-hclim noresm-r1i1p1f1-hclim #hadgem-r1i1p1-rca ecearth-r12i1p1-rca hadgem-r1i1p1-remo noresm-r1i1p1-rca cnrm-r1i1p1-aladin mpi-r1i1p1-cclm  cnrm-r1i1p1-racmo  mpi-r2i1p1-remo ecearth-r12i1p1-cclm  ecearth-r3i1p1-hirham  noresm-r1i1p1-remo
 do rsync -avu /lustre/storeC-ext/users/kin2100/NVE/EQM/CMIP6/${model}/${var}/hist/* . 
 done
 #Rename files
 #rename s/_eqm/_3dbc-eqm/ *nc4 #ubuntu 
 rename _eqm _3dbc-eqm *nc4 #RedHat & CentOS
done

#################
# Future climate
#################
for var in pr tas tasmin tasmax sfcWind hurs ps rlds rsds
 do mkdir -p ${BASEDIR}/${var}/FutC
 cd ${BASEDIR}/${var}/FutC
 for model in ecearth-r1i1p1f1-racmo ecearthveg-r1i1p1f1-cclm #ecearthveg-r1i1p1f1-hclim cnrm-r1i1p1f2-hclim noresm-r1i1p1f1-hclim #hadgem-r1i1p1-rca ecearth-r12i1p1-rca hadgem-r1i1p1-remo noresm-r1i1p1-rca cnrm-r1i1p1-cclm  aladin mpi-r1i1p1-cclm  cnrm-r1i1p1-racmo  mpi-r2i1p1-remo ecearth-r12i1p1-cclm  ecearth-r3i1p1-hirham  noresm-r1i1p1-remo
 do rsync -avu /lustre/storeC-ext/users/kin2100/NVE/EQM/CMIP6/${model}/${var}/ssp370/* .  
 done
 #Rename files
 #rename s/_eqm/_3dbc-eqm/ *nc4 #ubuntu
 rename _eqm _3dbc-eqm *nc4 #RedHat & CentOS
done

cd ${BASEDIR}

for var in pr tas tasmin tasmax sfcWind hurs ps rlds rsds
 #Adjust global attributes
 #do /home/andreasd/Scripts/KiN2100/3DBC/app/gitHub/3DBC_v2023/ncatted/ncatted_${var}_CMIP5.sh
 do /home/andreasd/Scripts/KiN2100/3DBC/app/gitHub/3DBC_v2023/ncatted/ncatted_${var}_CMIP6.sh
done

