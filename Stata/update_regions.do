
cd "C:\Users\wb537472\OneDrive - WBG\Documents\Projects\PIP Update\May 2024"


// Load latest coverage data 
// import excel "Data/March 2024 PIP Update.xlsx", sheet("Coverage") firstrow clear
use "data/coverage_results_202405.dta", clear 
drop if year>2022 
rename wbregioncode region_code 
keep year region_code COV COV_LMIC 
sort region_code year


// Censor cases without coverage
keep if COV<50 | ((COV<50 | COV_LMIC < 50 ) & region_code=="WLD")
drop if year<1981
keep region_code year 
rename year reporting_year

tempfile new 
save `new'


// Load original censoring file
import delimited "aux_censoring/regions.csv", clear 

// Merge with new consoring data
merge 1:1 region_code reporting_year using `new'
drop if _merge==1

replace statistic = "all" if statistic==""
drop _merge 

export delimited  "aux_censoring/regions.csv", replace 