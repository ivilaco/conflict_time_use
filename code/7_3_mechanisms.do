/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
8_3_mechanisms.do

This do file runs mechanism 3 - Night Lights
=========================================================================*/

*******************************************
*** Mechanism 3: Night Lights ***
*******************************************
	
	import delimited "${data}/raw/merged_sum_lights.csv", clear 
	
	* Renaming for simplicity and merging
	forvalues i=1993/2019 {
		cap rename sum_valueharmonized_dn_ntl_`i'_ ntl_`i'
	}
	
	* Adjusting mpio for merging
	tostring mpio_ccdgo dpto_ccdgo, replace
	gen mpio = string(real(mpio_ccdgo), "%03.0f")
	gen dpto = string(real(dpto_ccdgo), "%02.0f")
	gen MUNICIPIO = dpto + mpio
	drop mpio dpto mpio_ccdgo dpto_ccdgo
	destring MUNICIPIO, replace
	
	* Merging with treatment
	merge 1:1 MUNICIPIO using "${data}/coded/FARC.dta"
	keep if _merge == 3
	drop _merge
	
	reshape long ntl_, i(MUNICIPIO) j(ano)

	* Creating time vars
	drop if ano<2005
	gen TIME = (ano>2014)

	gen TIME2015 = (ano == 2015)
	gen TIME2016 = (ano == 2016)
	gen TIME2017 = (ano == 2017)
	gen TIME2018 = (ano == 2018)
	gen TIME2019 = (ano == 2019)

	gen conflict_time = TIME*CONFLICT
	gen conflict_time2015 = CONFLICT*TIME2015
	gen conflict_time2016 = CONFLICT*TIME2016
	gen conflict_time2017 = CONFLICT*TIME2017
	gen conflict_time2018 = CONFLICT*TIME2018
	gen conflict_time2019 = CONFLICT*TIME2019

	* Merging covars
	merge 1:1 MUNICIPIO ano using "${data}/coded/all_covars.dta"
	keep if _merge == 3
	drop _merge
	
	* Keep MUNICIPIOs that appear in all TIME periods  
	bysort MUNICIPIO (TIME): gen count = _N  
	egen max_count = max(count), by(MUNICIPIO)  
	drop if count < max_count  
	drop if max_count < 2
	
	drop max_count count
	
	* Dropping outliers
	sum ntl_, detail
	drop if ntl_ < r(p5) | ntl_ > r(p95)
	
	* Trends and fixed effects
	xtset MUNICIPIO ano
	bys CONFLICT: egen trend_pre = mean(cond(inrange(ano, 2010, 2014), ntl_, .)) // promedio de nightlights para los períodos -4 a -1 
		forvalues i = 2005/2019 {
		gen y`i' = (ano == `i')
		
		foreach e in trend_pre $cov_ddid $ef_ddid {
			gen `e'_y`i' = `e' * y`i'
		}
	}
	
	foreach e in $ef_ddid {
		tab ano if `e' != .
	}
	
		glo ef_ddid "pobl_tot indrural pib_total pib_percapita gini pobreza nbi IPM"

		
	* Saving database for processing
	save "${data}/coded/mecanismo3.dta", replace
	export delimited using "${data}/coded/mecanismo3.csv", replace
	
	* Event analysis
	use "${data}/coded/mecanismo3.dta", clear

		gen zero = (ano == 2013) // Create zero for baseline year. Its 2013 as it corresponds to the year inmediatly before the treament.
		reghdfe ntl_ CONFLICT#y2008 CONFLICT#y2009 CONFLICT#y2010 CONFLICT#y2011 CONFLICT#y2012 zero CONFLICT#y2014 CONFLICT#y2015 CONFLICT#y2016 CONFLICT#y2017 CONFLICT#y2018 CONFLICT#y2019, absorb(MUNICIPIO ano) vce(cluster MUNICIPIO) noomitted

		estimate store coef 
		parmest, norestore	
		replace estimate=. if parm=="o.zero"
		drop if estimate==0
		gen cont=_n
		drop if cont>=13
		replace estimate=0 if estimate==.
		
		foreach c in estimate min95 max95 {
			gen `c'_ = -`c'
			drop `c'
		}
			
		gen tiempo = 0 + _n
		label define tag1 1 "-5" 2 "-4" 3 "-3" 4 "-2" 5 "-1" 6 "0" 7 "1" 8 "2" 9 "3" 10 "4" 11 "5" 12 "6"
		label values tiempo tag1
			
		twoway (scatter estimate_ tiempo, msize(small) mcolor(blue)) ///
				(rcap min95_ max95_ tiempo, lc(gs10) lwidth(thin)), ///
				xtitle("Year", size(small)) ytitle("Coefficient", size(small)) ///
				yline(0, lc(red) lwidth(med)) xline(6, lpattern(dash) lc(gs8)) ///
				xlabel(1(1)12, valuelabel labsize(small)) ///
				ylabel(-250(250)1500, grid labsize(small)) ///
				yscale(range(-250 1500)) ///
				graphregion(color(gs16)) ///
				legend(off)

		graph export "${output}/nightlights_ea.pdf", as(pdf) replace 

