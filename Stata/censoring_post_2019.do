

cd "C:\Users\wb537472\OneDrive - WBG\Documents\Projects\PIP Update\March 2024"

//Set up global macros
global prod = "server(prod)"

pip, country(all) year(all) povline(2.15) ${prod} clear fillgaps
keep if year>=2019
list country_code year if year>2019
drop if inlist(year,2019,2022)
*drop if year==2020 & inlist(region_code,"ECA","LAC","OHI")
*drop if year==2021 & inlist(region_code,"LAC")
drop if year 

keep region_code region_name country_code country_name reporting_level year welfare_type




export excel using "C:\Users\wb537472\OneDrive - WBG\Documents\Samuel_ETC_Research\Andres\PIP Update SM 2023\aux_censoring.git\censoring_post_2019.xlsx", sheet("censoring_post_2019") firstrow(variables) sheetreplace
