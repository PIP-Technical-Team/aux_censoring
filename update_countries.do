
cd "C:\Users\wb537472\OneDrive - WBG\Documents\Projects\PIP Update\March 2024"

import delimited "aux_censoring.git/countries.csv", clear 

// Keep all pre-COVID censoring unchanged
// keep all COVID-years for all regions for all regions -- FOR NOW

keep if reporting_year>=2019 
drop if reporting_year>2019

export delimited  "aux_censoring.git/regions_202403.csv", replace 