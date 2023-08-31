
//Set up global macros
global prod = "server(qa)"
pip, country(all) year(all) povline(2.15) ${prod} clear fillgaps
keep if year>=2019
list country_code year if year>2019
drop if year==2019
drop if year==2020 & inlist(region_code,"ECA","LAC","OHI")
drop if year==2021 & inlist(region_code,"LAC")

keep region_code region_name country_code country_name reporting_level year welfare_type

export excel using "C:\Users\wb537472\OneDrive - WBG\Documents\Samuel_ETC_Research\Andres\PIP Update SM 2023\aux_censoring.git\censoring_post_2019.xlsx", sheet("censoring_post_2019") firstrow(variables) sheetreplace






cd "C:\Users\wb537472\OneDrive - WBG\Documents\Samuel_ETC_Research\Andres\PIP Update AM2023\aux_censoring"

// Update file for censoring regions 
* See this file shared by Andres on 24th August, 2023 --> https://app.clickup.com/37469623/v/dc/13qfdq-1071/13qfdq-1051

clear all 
set obs 9 
gen region_code = "EAP" in 1
gen year = 2020 in 1 
replace region_code = "ECA" in 2 
replace year = 2020 in 2 
replace region_code = "LAC" in 3 
replace year = 2021 in 3 
replace region_code = "SAS" in 4
replace year = 2021 in 4 
replace region_code = "MNA" in 5 
replace year = 2018 in 5 
replace region_code = "OHI" in 6 
replace year = 2020 in 6 
replace region_code = "SSA" in 7 
replace year = 2019 in 7 
replace region_code = "WLD" in 8 
replace year = 2019 in 8
replace region_code = "SAS" in 9   
replace year = 2020 in 9 

rename year reporting_year

br 


save "last_lineup_year", replace 

*Load previous censoring file 
import delimited "_archived/regions.csv", clear
set obs 31 
replace region_code="SSA" if region_code=="" 
replace statistic="all" if statistic=="" 
replace reporting_year =2020 in 30
replace reporting_year=2021 in 31

merge 1:1 region_code reporting_year using "last_lineup_year", keep(1) nogen

br if region_code=="SSA"


/*
br if _merge==3
br if region_code=="ECA"
br if region_code=="EAP"

*/

export delimited using "regions.csv", replace



// Update file for censoring countries


pip, clear fillgaps
keep country_code country_name region_code 
duplicates drop  

tempfile pip 
save `pip'

import delimited "_archived/countries.csv", clear 
gen type = "survey" if survey_acronym!=""

merge m:1 country_code using `pip'

drop if region_code=="SAS" & inlist(reporting_year,2021,2020) & survey_acronym==""
drop if region_code=="EAP" & inlist(reporting_year,2020) & survey_acronym==""

preserve 
	keep if survey_acronym==""
	sort country_code reporting_year

	tempfile df 
	save `df'
restore 

keep if type == "survey"

append using `df'

br if country_code=="CHN"

br if region_code=="LAC"
br if region_code=="EAP"

replace reporting_year=2021 if country_code=="CHN"
replace reporting_level="national" if country_code=="CHN"
replace welfare_type="consumption" if country_code=="CHN"
replace statistic = "all" if country_code=="CHN"
expand 3 if country_code=="CHN"
bysort country_code: gen dup = _n if country_code=="CHN"
replace reporting_level="urban" if country_code=="CHN"&dup==2
replace reporting_level="rural" if country_code=="CHN"&dup==3
drop dup

gsort -type country_code 
drop region_code _merge type country_name
drop if reporting_year==.

export delimited using "countries.csv", replace


// Censor distributional statistics from the lineup estimates

import delimited "countries.csv", clear 


use "C:\Users\wb537472\OneDrive - WBG\Documents\Samuel_ETC_Research\Andres\PIP Update AM2023\PIP_20230626_2017_01_02_TEST_lineup20230831.dta", clear



// Check if censoring is well done. 
use "C:\Users\wb537472\OneDrive - WBG\Documents\Samuel_ETC_Research\Andres\PIP Update AM2023\PIP_20230626_2017_01_02_TEST_lineup20230831.dta", clear

levelsof region_code, local(levels)
foreach l of local levels {
    display "`l'"
 tab year if year>2018 & region_code=="`l'" & year!=2022
 }


use "C:\Users\wb537472\OneDrive - WBG\Documents\Samuel_ETC_Research\Andres\PIP Update AM2023\PIP_20230626_2017_01_02_TEST_aggregate20230831.dta", clear

levelsof region_code, local(levels)
foreach l of local levels {
    display "`l'"
 tab year if year>2018 & region_code=="`l'" & year!=2022
 }


 import delimited "region.cvs", clear 

