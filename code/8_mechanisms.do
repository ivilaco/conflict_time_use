/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
8_robustness.do

This do file runs robustness checks and mechanisms
=========================================================================*/

*******************************************
*** MECANISMO 1 : Migration patterns ***
*******************************************

	use "${data}/DANE/PANEL_CONFLICTO_Y_VIOLENCIA(2020).dta", clear // Este archivo se debe mandar al DANE******** (5)
	
	keep desplazados_expulsion desplazados_recepcion codmpio ano
	rename codmpio MUNICIPIO
	drop if ano<2010
	merge n:1 MUNICIPIO using "${data}/DANE/FARC.dta"
	keep if _merge==3
	gen TIME = (ano>2014)
	gen TIME2015 = (ano == 2015)
	gen TIME2016 = (ano == 2016)
	gen TIME2017 = (ano == 2017)
	gen TIME2018 = (ano == 2018)
	gen TIME2019 = (ano == 2019)
	drop _merge
	merge 1:1 MUNICIPIO ano using "${entra}/poblacion.dta" // Este archivo se debe mandar al DANE******** (6)
	keep if _merge==3

	gen conflict_time = TIME*CONFLICT
	gen conflict_time2015 = CONFLICT*TIME2015
	gen conflict_time2016 = CONFLICT*TIME2016
	gen conflict_time2017 = CONFLICT*TIME2017
	gen conflict_time2018 = CONFLICT*TIME2018
	gen conflict_time2019 = CONFLICT*TIME2019
	gen prop_desp_recep = (desplazados_recepcion/pobl_tot)*100
	gen prop_desp_expul = (desplazados_expulsion/pobl_tot)*100
	
	gen DPTO = substr(string(MUNICIPIO), 1, length(string(MUNICIPIO)) - 3)
	
	forvalue i = 5/8 {
		replace DPTO = "0`i'" if DPTO == "`i'"
	}
	
	* Regions
	cap drop REGION
	gen REGION = .
	replace REGION = 1 if DPTO == "08" | DPTO == "13" | DPTO == "20" | DPTO == "23" | DPTO == "44" | DPTO == "47" | DPTO == "70"
	replace REGION = 2 if DPTO == "05" | DPTO == "17" | DPTO == "18" | DPTO == "41" | DPTO == "63" | DPTO == "66" | DPTO == "73"
	replace REGION = 3 if DPTO == "15" | DPTO == "25" | DPTO == "50" | DPTO == "54" | DPTO == "68"
	replace REGION = 4 if DPTO == "19" | DPTO == "27" | DPTO == "52" | DPTO == "76"
	
	save "${enut}/mecanismo1.dta", replace
	
	use "${enut}/mecanismo1.dta", clear
	
	* Regresion
	file open latex using "${output}/mig.txt", write replace text
	file write latex "\begin{tabular}{l c c c c} \\ \hline \hline" _n
	file write latex "& \multicolumn{2}{c}{Received} & \multicolumn{2}{c}{Expelled} \\ " _n
	file write latex "& (1) & (2) & (1) & (2) \\ \hline" _n

	foreach i in prop_desp_recep prop_desp_expul {
		
		reg `i' conflict_time i.MUNICIPIO i.ano
		local b: di %4.3f `= _b[conflict_time]'
		global seb_`i': di %4.3f `= _se[conflict_time]'
		local tb=_b[conflict_time]/_se[conflict_time]
		local pb= 2*ttail(`e(df_r)',abs(`tb'))
		global r2_`i': di %4.3f `= e(r2)'
		global N_`i': di %9.0f `= e(N)'
			
			foreach n in b {
			if `p`n''<=0.01 {
				global b`n'_`i' "``n''\sym{***}"
			}
			
			if `p`n''<=0.05 & `p`n''>0.01 {
				global b`n'_`i' "``n''\sym{**}"
			}
			
			if `p`n''<=0.1 & `p`n''>0.05 {
				global b`n'_`i' "``n''\sym{*}"
			}

			if `p`n''>0.1  {
				global b`n'_`i' "``n''"
			}
			}
			
		reg `i' conflict_time2015 conflict_time2016 conflict_time2017 conflict_time2018 conflict_time2019 i.MUNICIPIO i.ano
		local a: di %4.3f `= _b[conflict_time2015]'
		local c: di %4.3f `= _b[conflict_time2016]'
		local d: di %4.3f `= _b[conflict_time2017]'
		local e: di %4.3f `= _b[conflict_time2018]'
		local f: di %4.3f `= _b[conflict_time2019]'
		
		global sea_`i': di %4.3f `= _se[conflict_time2015]'
		global sec_`i': di %4.3f `= _se[conflict_time2016]'
		global sed_`i': di %4.3f `= _se[conflict_time2017]'
		global see_`i': di %4.3f `= _se[conflict_time2018]'
		global sef_`i': di %4.3f `= _se[conflict_time2019]'
		
		local ta=_b[conflict_time2015]/_se[conflict_time2015]
		local tc=_b[conflict_time2016]/_se[conflict_time2016]
		local td=_b[conflict_time2017]/_se[conflict_time2017]
		local te=_b[conflict_time2018]/_se[conflict_time2018]
		local tf=_b[conflict_time2019]/_se[conflict_time2019]
		
		local pa= 2*ttail(`e(df_r)',abs(`ta'))
		local pc= 2*ttail(`e(df_r)',abs(`tc'))
		local pd= 2*ttail(`e(df_r)',abs(`td'))
		local pe= 2*ttail(`e(df_r)',abs(`te'))
		local pf= 2*ttail(`e(df_r)',abs(`tf'))
		
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
			
			foreach n in a c d e f {
			if `p`n''<=0.01 {
				global b`n'_`i' "``n''\sym{***}"
			}
			
			if `p`n''<=0.05 & `p`n''>0.01 {
				global b`n'_`i' "``n''\sym{**}"
			}
			
			if `p`n''<=0.1 & `p`n''>0.05 {
				global b`n'_`i' "``n''\sym{*}"
			}

			if `p`n''>0.1  {
				global b`n'_`i' "``n''"
			}
			}

		sum `i', d 
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(sd)'
			
	}
	
	file write latex " Conflict x Time & ${bb_prop_desp_recep} && ${bb_prop_desp_expul} & \\" _n
	file write latex "  & (${seb_prop_desp_recep}) && (${seb_prop_desp_expul}) & \\" _n

	file write latex " Conflict x 2015 && ${ba_prop_desp_recep} && ${ba_prop_desp_expul} \\" _n
	file write latex "  && (${sea_prop_desp_recep}) && (${sea_prop_desp_expul}) \\" _n

	file write latex " Conflict x 2016 && ${bc_prop_desp_recep} && ${bc_prop_desp_expul} \\" _n
	file write latex "  && (${sec_prop_desp_recep}) && (${sec_prop_desp_expul}) \\" _n
	
	file write latex " Conflict x 2017 && ${bd_prop_desp_recep} && ${bd_prop_desp_expul} \\" _n
	file write latex "  && (${sed_prop_desp_recep}) && (${sed_prop_desp_expul}) \\" _n

	file write latex " Conflict x 2018 && ${be_prop_desp_recep} && ${be_prop_desp_expul} \\" _n
	file write latex "  && (${see_prop_desp_recep}) && (${see_prop_desp_expul}) \\" _n

	file write latex " Conflict x 2019 && ${bf_prop_desp_recep} && ${bf_prop_desp_expul} \\" _n
	file write latex "  && (${sef_prop_desp_recep}) && (${sef_prop_desp_expul}) \\" _n

	file write latex " Observations & ${N_prop_desp_recep} & ${N2_prop_desp_recep} & ${N_prop_desp_expul} & ${N2_prop_desp_recep}\\" _n
	file write latex " R-squared & ${r2_prop_desp_recep} & ${r22_prop_desp_recep} & ${r2_prop_desp_expul} & ${r22_prop_desp_expul} \\" _n
	file write latex "\hline" _n

	file write latex "Mean & ${m1_prop_desp_recep} & ${m1_prop_desp_recep} & ${m1_prop_desp_expul} & ${m1_prop_desp_expul} \\" _n
	file write latex "Standard Deviation & ${p1_prop_desp_recep} & ${p1_prop_desp_recep} & ${p1_prop_desp_expul} & ${p1_prop_desp_expul}  \\" _n		
	file write latex "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
	file write latex "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
	
	reg prop_desp_recep conflict_time i.MUNICIPIO i.ano // i.MUNICIPIO i.ano - después de agregar efectos fijos se vuelve significativo
	reg prop_desp_expul conflict_time i.MUNICIPIO i.ano // i.MUNICIPIO i.ano

*******************************************
*** MECANISMO 2 : Household Composition ***
*******************************************

	use "${enut}/ENUT_FARC_ALL.dta", clear
	
	gen p_hhth = (hhth/hht)*100
	gen p_hhthj = (hhthj/hht)*100
	gen p_hdist = (hdist/hht)*100
		
	collapse (mean) hht* hdist CONFLICT ANNO MUNICIPIO p_hhth p_hhthj p_hdist, by(idhogar TIME)
	gen conflict_time = CONFLICT*TIME
		foreach i in p_hhth p_hhthj hht {
		replace `i'=0 if `i'==.
	}
	
	* Regresion
	file open latex using "${output}/mecanismos1.txt", write replace text
	file write latex "\begin{tabular}{l c c c c c c c c} \\ \hline \hline" _n
	file write latex "& \multicolumn{2}{c}{Total} & \multicolumn{2}{c}{\% of males} & \multicolumn{2}{c}{\% of young males} & \multicolumn{2}{c}{\% of disabled} \\ " _n
	file write latex "& (1) & (2) & (1) & (2) & (1) & (2) & (1) & (2) \\ \hline" _n

	foreach i in p_hhth p_hhthj hht {
		
		* Conflict x time all
		reg `i' conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO, vce(cluster MUNICIPIO)
		local a: di %4.3f `= _b[conflict_time]'
		local b: di %4.3f `= _b[CONFLICT]'
		local c: di %4.3f `= _b[TIME]'
		global sea_`i': di %4.3f `= _se[conflict_time]'
		global seb_`i': di %4.3f `= _se[CONFLICT]'
		global sec_`i': di %4.3f `= _se[TIME]'
		local ta=_b[conflict_time]/_se[conflict_time]
		local tb=_b[CONFLICT]/_se[CONFLICT]
		local tc=_b[TIME]/_se[TIME]
		local pa= 2*ttail(`e(df_r)',abs(`ta'))
		local pb= 2*ttail(`e(df_r)',abs(`tb'))
		local pc= 2*ttail(`e(df_r)',abs(`tc'))
		global r2_`i': di %4.3f `= e(r2)'
		global N_`i': di %9.0f `= e(N)'
			
			foreach n in a b c {
			if `p`n''<=0.01 {
				global b`n'_`i' "``n''\sym{***}"
			}
			
			if `p`n''<=0.05 & `p`n''>0.01 {
				global b`n'_`i' "``n''\sym{**}"
			}
			
			if `p`n''<=0.1 & `p`n''>0.05 {
				global b`n'_`i' "``n''\sym{*}"
			}

			if `p`n''>0.1  {
				global b`n'_`i' "``n''"
			}
			}
			
			
		* Conflict x years
		reg `i' conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO, vce(cluster MUNICIPIO)
		local d: di %4.3f `= _b[conflict_time2016]'
		local e: di %4.3f `= _b[conflict_time2020]'
		global sed_`i': di %4.3f `= _se[conflict_time2016]'
		global see_`i': di %4.3f `= _se[conflict_time2020]'
		local td=_b[conflict_time2016]/_se[conflict_time2016]
		local te=_b[conflict_time2020]/_se[conflict_time2020]
		local pd= 2*ttail(`e(df_r)',abs(`td'))
		local pe= 2*ttail(`e(df_r)',abs(`te'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
			
			foreach n in d e {
			if `p`n''<=0.01 {
				global b`n'_`i' "``n''\sym{***}"
			}
			
			if `p`n''<=0.05 & `p`n''>0.01 {
				global b`n'_`i' "``n''\sym{**}"
			}
			
			if `p`n''<=0.1 & `p`n''>0.05 {
				global b`n'_`i' "``n''\sym{*}"
			}

			if `p`n''>0.1  {
				global b`n'_`i' "``n''"
			}
			}

		sum `i', d 
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(sd)'
			
	}
	
	file write latex " Conflict x Time & ${ba_hht} && ${ba_p_hhth} && ${ba_p_hhthj} && ${ba_p_hdist} & \\" _n
	file write latex "  & (${sea_hht}) && (${sea_p_hhth}) && (${sea_p_hhthj}) && (${sea_p_hdist}) & \\" _n

	file write latex " Conflict x 2016 && ${bd_hht} && ${bd_p_hhth} && ${bd_p_hhthj} && ${bd_p_hdist} \\" _n
	file write latex "  && (${sed_hht}) && (${sed_p_hhth}) && (${sed_p_hhthj}) && (${sed_p_hdist}) \\" _n
	
	file write latex " Conflict x 2020 && ${be_hht} && ${be_p_hhth} && ${be_p_hhthj} && ${be_p_hdist} \\" _n
	file write latex "  && (${see_hht}) && (${see_p_hhth}) && (${see_p_hhthj}) && (${see_p_hdist}) \\" _n
	
	file write latex " Conflict & ${bb_hht} && ${bb_p_hhth} && ${bb_p_hhthj} && ${bb_p_hdist} & \\" _n
	file write latex "  & (${seb_hht}) && (${seb_p_hhth}) && (${seb_p_hhthj}) && (${seb_p_hdist}) & \\" _n

	file write latex " Time & ${bc_hht} && ${bc_p_hhth} && ${bc_p_hhthj} && ${bc_p_hdist} & \\" _n
	file write latex "  & (${sec_hht}) && (${sec_p_hhth}) && (${sec_p_hhthj}) && (${sec_p_hdist}) & \\" _n

	file write latex " Observations & ${N_hht} & ${N2_hht} & ${N_p_hhth} & ${N2_p_hhth} & ${N_p_hhthj} & ${N2_p_hhthj} & ${N_p_hdist} & ${N2_p_hdist} \\" _n
	file write latex " R-squared & ${r2_hht} & ${r22_hht} & ${r2_p_hhth} & ${r22_p_hhth} & ${r2_p_hhthj} & ${r22_p_hhthj} & ${r2_p_hdist} & ${r22_p_hdist} \\" _n
	file write latex "\hline" _n

	file write latex "Mean & ${m1_hht} & ${m1_hht} & ${m1_p_hhth}  & ${m1_p_hhth} & ${m1_p_hhthj} & ${m1_p_hhthj} & ${m1_p_hdist} & ${m1_p_hdist} \\" _n
	file write latex "Standard Deviation & ${p1_hht} & ${p1_hht} & ${p1_p_hhth} & ${p1_p_hhth} & ${p1_p_hhthj} & ${p1_p_hhthj} & ${p1_p_hdist} & ${p1_p_hdist} \\" _n
	file write latex "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$  \\" _n	
	file write latex "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n			
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
	
*******************************************
*** MECANISMO 3 : Night Lights ***
*******************************************

******** COVARS (CEDE PANEL) Not really necessary but ill keep it here until further notice. We are not using this covars in the event analysis.

	foreach i in panel_agricultura_y_tierra_2020 panel_buen_gobierno_2020 panel_carac_generales_2020 panel_conflicto_y_violencia_2020 panel_de_educacion_2020 panel_salud_y_servicios_2020 {
		
		use "${data}/Panel Municipal CEDE/`i'.dta", clear
		drop if ano < 2005
		save "${data}/coded/cede_clean_`i'.dta", replace
	}
	
	use "${data}/coded/cede_clean_panel_agricultura_y_tierra_2020.dta", clear
	
	foreach i in panel_buen_gobierno_2020 panel_carac_generales_2020 panel_conflicto_y_violencia_2020 panel_de_educacion_2020 panel_salud_y_servicios_2020 {
		
		merge 1:1 codmpio ano using "${data}/coded/cede_clean_`i'.dta"
		drop _merge
	
	}
	
	rename codmpio MUNICIPIO
	
	* The ones we are interested in for the doubly DiD
	glo ef_ddid "pobl_tot indrural  pib_total pib_percapita gini pobreza nbi IPM"
	glo cov_ddid "areaoficialkm2 distancia_mercado altura discapital dismdo"
	keep MUNICIPIO ano $cov_ddid $ef_ddid
	
	save "${data}/coded/all_covars.dta", replace
	
******** NIGHT LIGHTS
	
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
	merge 1:1 MUNICIPIO using "${data}/DANE/FARC.dta"
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
	
/******** REGRESION
		
	use "${data}/coded/mecanismo3.dta", clear	
	
	file open latex using "${graf}/ntl_3.txt", write replace text
	file write latex "\begin{tabular}{l c c} \\ \hline \hline" _n
	file write latex "& \multicolumn{2}{c}{Night Light Intensity} \\ " _n
	file write latex "& (1) & (2) \\ \hline" _n
	
	foreach i in ntl_ {
		
		reg `i' conflict_time i.MUNICIPIO i.ano, cluster(MUNICIPIO)
		local b: di %4.3f `= _b[conflict_time]'
		global seb_`i': di %4.3f `= _se[conflict_time]'
		local tb=_b[conflict_time]/_se[conflict_time]
		local pb= 2*ttail(`e(df_r)',abs(`tb'))
		global r2_`i': di %4.3f `= e(r2)'
		global N_`i': di %9.0f `= e(N)'
			
			foreach n in b {
			if `p`n''<=0.01 {
				global b`n'_`i' "``n''\sym{***}"
			}
			
			if `p`n''<=0.05 & `p`n''>0.01 {
				global b`n'_`i' "``n''\sym{**}"
			}
			
			if `p`n''<=0.1 & `p`n''>0.05 {
				global b`n'_`i' "``n''\sym{*}"
			}

			if `p`n''>0.1  {
				global b`n'_`i' "``n''"
			}
			}
			
		reg `i' conflict_time2015 conflict_time2016 conflict_time2017 conflict_time2018 conflict_time2019 i.MUNICIPIO i.ano, cluster(MUNICIPIO)
		local a: di %4.3f `= _b[conflict_time2015]'
		local c: di %4.3f `= _b[conflict_time2016]'
		local d: di %4.3f `= _b[conflict_time2017]'
		local e: di %4.3f `= _b[conflict_time2018]'
		local f: di %4.3f `= _b[conflict_time2019]'
		
		global sea_`i': di %4.3f `= _se[conflict_time2015]'
		global sec_`i': di %4.3f `= _se[conflict_time2016]'
		global sed_`i': di %4.3f `= _se[conflict_time2017]'
		global see_`i': di %4.3f `= _se[conflict_time2018]'
		global sef_`i': di %4.3f `= _se[conflict_time2019]'
		
		local ta=_b[conflict_time2015]/_se[conflict_time2015]
		local tc=_b[conflict_time2016]/_se[conflict_time2016]
		local td=_b[conflict_time2017]/_se[conflict_time2017]
		local te=_b[conflict_time2018]/_se[conflict_time2018]
		local tf=_b[conflict_time2019]/_se[conflict_time2019]
		
		local pa= 2*ttail(`e(df_r)',abs(`ta'))
		local pc= 2*ttail(`e(df_r)',abs(`tc'))
		local pd= 2*ttail(`e(df_r)',abs(`td'))
		local pe= 2*ttail(`e(df_r)',abs(`te'))
		local pf= 2*ttail(`e(df_r)',abs(`tf'))
		
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
			
			foreach n in a c d e f {
			if `p`n''<=0.01 {
				global b`n'_`i' "``n''\sym{***}"
			}
			
			if `p`n''<=0.05 & `p`n''>0.01 {
				global b`n'_`i' "``n''\sym{**}"
			}
			
			if `p`n''<=0.1 & `p`n''>0.05 {
				global b`n'_`i' "``n''\sym{*}"
			}

			if `p`n''>0.1  {
				global b`n'_`i' "``n''"
			}
			}

		sum `i', d 
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(sd)'
			
	}
	
	file write latex " Conflict x Time & ${bb_ntl_} & \\" _n
	file write latex "  & (${seb_ntl_}) & \\" _n

	file write latex " Conflict x 2015 && ${ba_ntl_}\\" _n
	file write latex "  && (${sea_ntl_}) \\" _n

	file write latex " Conflict x 2016 && ${bc_ntl_}\\" _n
	file write latex "  && (${sec_ntl_}) \\" _n
	
	file write latex " Conflict x 2017 && ${bd_ntl_} \\" _n
	file write latex "  && (${sed_ntl_}) \\" _n

	file write latex " Conflict x 2018 && ${be_ntl_} \\" _n
	file write latex "  && (${see_ntl_})\\" _n

	file write latex " Conflict x 2019 && ${bf_ntl_} \\" _n
	file write latex "  && (${sef_ntl_}) \\" _n

	file write latex " Observations & ${N_ntl_} & ${N2_ntl_} \\" _n
	file write latex " R-squared & ${r2_ntl_} & ${r22_ntl_} \\" _n
	file write latex "\hline" _n

	file write latex "Mean & ${m1_ntl_} & ${m1_ntl_} \\" _n
	file write latex "Standard Deviation & ${p1_ntl_} & ${p1_ntl_} \\" _n		
	file write latex "Year FE & $\checkmark$ & $\checkmark$ \\" _n	
	file write latex "Municipality FE & $\checkmark$ & $\checkmark$\\" _n	
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
*/
	
******** EVENT ANALYSIS

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
		xtitle("Year") ytitle("Coefficient") ///
		yline(0, lc(red) lwidth(med)) xline(6, lpattern(dash) lc(gs8)) ///
		xlabel(1(1)12, valuelabel) ///
		ylabel(-500(500)1500, grid) ///
		yscale(range(-500 1500)) ///
		graphregion(color(gs16)) ///
		legend(off)

	graph export "${graf}/nightlights_ea.pdf", as(pdf) replace 


*******************************************
*** CENSUS ***
*******************************************

	use "${data}/coded/censo_depto_total.dta", clear
	
	* Regresion
	file open latex using "${output}/censo.txt", write replace text
	file write latex "\begin{tabular}{l c c c c} \\ \hline \hline" _n
	file write latex "& \multicolumn{2}{c}{Total population} & \multicolumn{2}{c}{Young population} \\ \cline{2-5}" _n
	file write latex "& Five years back & One year back & Five years back & One year back \\ " _n
	file write latex "& (1) & (2) & (3) & (4) \\ \hline" _n

	foreach i in vivia_5 vivia_5y vivia_1 vivia_1y {
		
		reg `i' CONFLICT i.MUNICIPIO
		local b: di %4.3f `= _b[CONFLICT]'
		global seb_`i': di %4.3f `= _se[CONFLICT]'
		local tb=_b[CONFLICT]/_se[CONFLICT]
		local pb= 2*ttail(`e(df_r)',abs(`tb'))
		global r2_`i': di %4.3f `= e(r2)'
		global N_`i': di %9.0f `= e(N)'
			
			foreach n in b {
			if `p`n''<=0.01 {
				global b`n'_`i' "``n''\sym{***}"
			}
			
			if `p`n''<=0.05 & `p`n''>0.01 {
				global b`n'_`i' "``n''\sym{**}"
			}
			
			if `p`n''<=0.1 & `p`n''>0.05 {
				global b`n'_`i' "``n''\sym{*}"
			}

			if `p`n''>0.1  {
				global b`n'_`i' "``n''"
			}
			}

		sum `i', d 
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(sd)'
			
	}
	
	file write latex " Conflict & ${bb_vivia_5} & ${bb_vivia_1} & ${bb_vivia_5y} & ${bb_vivia_1y} \\" _n
	file write latex "  & (${seb_vivia_5}) & (${seb_vivia_1}) & (${seb_vivia_5y}) & (${seb_vivia_1y}) \\" _n

	file write latex " Observations & ${N_vivia_5} & ${N_vivia_1} & ${N_vivia_5y} & ${N_vivia_1y} \\" _n
	file write latex " R-squared & ${r2_vivia_5} & ${r2_vivia_1} & ${r2_vivia_5y} & ${r2_vivia_1y} \\" _n
	file write latex "\hline" _n

	file write latex "Mean & ${m1_vivia_5} & ${m1_vivia_1} & ${m1_vivia_5y} & ${m1_vivia_1y} \\" _n
	file write latex "Standard Deviation & ${p1_vivia_5} & ${p1_vivia_1} & ${p1_vivia_5y} & ${p1_vivia_1y} \\" _n		
	file write latex "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
