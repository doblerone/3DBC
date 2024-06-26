###################################
## Adjust NetCDF header information
###################################
for file in /lustre/storeC-ext/users/kin2100/MET/3DBC/application/CMIP6/work/pr/CurC/app/*nc4
do ncatted -O -a title,global,o,c,"Post-processed bias-adjusted precipitation projection." $file
ncatted -O -a keywords,global,o,c,"Climate, Meteorology, Precipitation projections, historical, Gridded data, Bias-adjustment, Empirical quantile mapping, Post-processed, 3DBC, Norway" $file
ncatted -O -a product_name,global,o,c,"Post-processed bias-adjusted precipitation projections for Norway, 1 km2 spatial resolution" $file
ncatted -O -a bc_method,global,o,c,"EQM + 3DBC; Mehrotra and Sharma 2019: A Resampling Approach for Correcting Systematic Spatiotemporal Biases for Multiple Variables in a Changing Climate, Water Resources Research, 55(1), pp.754-770, doi: 10.1029/2018WR023270" $file
ncatted -O -a bc_method_id,global,o,c,"MET-3DBC" $file
ncatted -O -a creator_name,global,o,c,"Andreas Dobler" $file
ncatted -O -a creator_email,global,o,c,"andreas.dobler@met.no" $file
ncatted -O -a institution,global,o,c,"The Norwegian Meteorological Institute (MET Norway)" $file
ncatted -O -a date_created,global,o,c,"2024-06-26" $file
ncatted -O -h -a history,global,d,c,"" $file
done

for file in /lustre/storeC-ext/users/kin2100/MET/3DBC/application/CMIP6/work/pr/FutC/*nc4
do ncatted -O -a title,global,o,c,"Post-processed bias-adjusted precipitation projection." $file
ncatted -O -a keywords,global,o,c,"Climate, Meteorology, Precipitation projections, ssp370, Gridded data, Bias-adjustment, Empirical quantile mapping, Post-processed, 3DBC, Norway" $file
ncatted -O -a product_name,global,o,c,"Post-processed bias-adjusted precipitation projections for Norway, 1 km2 spatial resolution" $file
ncatted -O -a bc_method,global,o,c,"EQM + 3DBC; Mehrotra and Sharma 2019: A Resampling Approach for Correcting Systematic Spatiotemporal Biases for Multiple Variables in a Changing Climate, Water Resources Research, 55(1), pp.754-770, doi: 10.1029/2018WR023270" $file
ncatted -O -a bc_method_id,global,o,c,"MET-3DBC" $file
ncatted -O -a creator_name,global,o,c,"Andreas Dobler" $file
ncatted -O -a creator_email,global,o,c,"andreas.dobler@met.no" $file
ncatted -O -a institution,global,o,c,"The Norwegian Meteorological Institute (MET Norway)" $file
ncatted -O -a date_created,global,o,c,"2024-06-26" $file
ncatted -O -h -a history,global,d,c,"" $file
done

