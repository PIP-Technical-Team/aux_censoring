


cd "C:\Users\wb537472\OneDrive - WBG\Documents\Projects\PIP Update\March 2024"


// Load latest coverage data 
import excel "Data/March 2024 PIP Update.xlsx", sheet("Coverage") firstrow clear
drop if year>2022
rename regioncode region_code 
keep year region_code COV COV_LMIC 
sort region_code year

// Censor cases without coverage
keep if COV<50 | ((COV<50 | COV_LMIC < 50 ) & region_code=="WLD")
keep region_code year 
rename year reporting_year

tempfile new 
save `new'


// Load original censoring file
import delimited "aux_censoring.git/regions.csv", clear 

// Merge with new consoring data
merge 1:1 region_code reporting_year using `new'

replace statistic = "all" if statistic==""
drop _merge 

export delimited  "aux_censoring.git/regions.csv", replace 