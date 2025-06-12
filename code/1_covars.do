/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
1_covars.do

This do file creates the covariables and additional variables needed for 
the analysis
=========================================================================*/

*******************************************
*** TREATMENT ***
*******************************************

	use "${data}/raw/FARC_presence_pre_ceasefire.dta", clear
	
		rename M_code MUNICIPIO
	
		* Conflict 1 (Santos dos periodos)
		gen CONFLICT = (UR_farc_santos1>0)
		rename UR_farc_santos1 UR_FARC_S
		
		* Conflict 2 (Uribe dos periodos)
		gen CONFLICT1 = (UR_farc_uribe1>0)
		rename UR_farc_uribe1 UR_FARC_U1
		
		* Labelling vars
		keep MUNICIPIO CONFLICT CONFLICT1 UR_FARC_S UR_FARC_U1
		lab define b 1 "Conflict" 0 "No Conflict"
		lab values CONFLICT CONFLICT1 b
	
	save "${data}/coded/FARC.dta", replace // This database must be sent to DANE******** (1)
	
*******************************************
*** COVARIABLES PSM ***
*******************************************

	use "${data}/raw/CEDE/panel_carac_generales_2020.dta", clear
	
	rename codmpio MUNICIPIO
		
		* Saving population data alone
		preserve
			keep MUNICIPIO ano pobl_tot
			save "${data}/coded/poblacion.dta", replace // This database must be sent to DANE******** (2)
		restore
	
	* Merging with treatment and keeping relevant years
	merge m:1 MUNICIPIO using "${data}/coded/FARC.dta" // (1)
	keep if _merge==3
	drop if ano<2005
	
	* Creating TIME dummy
	gen TIME=1 if ano>2014
	replace TIME=0 if ano<2014
	drop if ano>2013
	
	* Selecting covars for PSM and keeping relevant vars
	glob covs_psm "gcaribe retro_pobl_rur pobl_rur dismdo disbogota mercado_cercano distancia_mercado pib_agricola pib_industria pib_servicios pib_total nbicabecera IPM_rur ipm_ledu_p ipm_templeof_p"
	keep $covs_psm MUNICIPIO ano CONFLICT
	
	* Saving covars in a unique database
	local j = 0
	foreach i in $covs_psm {
		local j = `j'+1
		
		preserve
		keep `i' MUNICIPIO ano CONFLICT
		sort MUNICIPIO ano
		gen cont=_n
		drop if missing(`i')
		bys MUNICIPIO : egen ano2=max(ano)
		keep if ano2==ano
		keep `i' MUNICIPIO CONFLICT ano2 ano
			if `j' == 1 {
			tempfile w1
			save `w1', replace
			save "${data}/coded/new_vars.dta", replace
			} 
			else if `j'!=1 {
			merge 1:1 MUNICIPIO using `w1', gen(_merge)
			drop _merge
			save `w1', replace
			save "${data}/coded/new_vars.dta", replace // This database must be sent to DANE******** (3)
			}
		restore
	} 
	
*******************************************
*** CONTROLS ***
*******************************************
	
	* Preparing vars from raw excel file
	foreach i of numlist 9 11 18 20 22 23 25 26 {
		
		import excel "${data}/raw/PSM_covariables.xlsx", sheet("`i'") firstrow clear
		
		* Cleaning database
		rename cod_ent cod_mpio	
		destring cod_mpio v`i' year, replace
		drop if v`i'==.
		keep cod_mpio v`i' year
		drop if year<2005
		rename cod_mpio MUNICIPIO
		drop if year==2014
		
		* Gen TIME dummy
		gen TIME=1 if year>2014
		replace TIME=0 if year<2014	
		
		keep year v`i' MUNICIPIO TIME
		drop if v`i'==.
		
		* Selecting relevant data based on year
		bys MUNICIPIO : egen maximo=max(year) if TIME==0
		bys MUNICIPIO : egen minimo=min(year) if TIME==1
		drop if year!=maximo & TIME==0
		drop if year!=minimo & TIME==1
		drop year maximo minimo
		
	save "${data}/coded/v`i'.dta", replace
	}
	
	* Adding v4 del panel CEDE
	use "${data}/raw/CEDE/panel_carac_generales_2020.dta", clear
	
		keep IPM ano codmpio
		rename (ano codmpio IPM) (year MUNICIPIO v4)
		
		* Keeping years of interest and creating TIME dummt
		drop if year<2005
		drop if year==2014
		gen TIME=1 if year>2014
		replace TIME=0 if year<2014
		keep year v4 MUNICIPIO TIME
		drop if v4==.
		
		* Selecting relevant data based on year
		bys MUNICIPIO : egen maximo=max(year) if TIME==0
		bys MUNICIPIO : egen minimo=min(year) if TIME==1
		drop if year!=maximo & TIME==0
		drop if year!=minimo & TIME==1
		drop year maximo minimo
		
	save "${data}/coded/v4.dta", replace
	
	* Merging variables
	use "${data}/coded/v4.dta", clear
	foreach i of numlist 9 11 18 20 22 23 25 26 {
		merge 1:1 MUNICIPIO TIME using "${data}/coded/v`i'.dta"
		drop _merge
	}
	save "${data}/coded/COVS.dta", replace
	
	* We merge variables with treatment database
	use "${data}/coded/COVS.dta", clear
	
		merge m:1 MUNICIPIO using "${data}/coded/FARC.dta"
		keep if _merge==3
		drop _merge	
	
	save "${data}/coded/FARC_final.dta", replace // This database must be sent to DANE******** (4)

