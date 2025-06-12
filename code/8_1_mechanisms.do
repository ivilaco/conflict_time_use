/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
8_1_mechanisms.do

This do file runs mechanism 1 - Migration patterns
=========================================================================*/

*******************************************
*** Mechanism 1: Migration patterns *** 
*******************************************

	use "${data}/raw/CEDE/panel_conflicto_y_violencia_2020.dta", clear 
	
	keep desplazados_expulsion desplazados_recepcion codmpio ano
	rename codmpio MUNICIPIO
	drop if ano<2010
	
	* Merging with treatment
	merge n:1 MUNICIPIO using "${data}/coded/FARC.dta"
	keep if _merge==3
	
	* Creating TIME dummies
	gen TIME = (ano>2014)
	gen TIME2015 = (ano == 2015)
	gen TIME2016 = (ano == 2016)
	gen TIME2017 = (ano == 2017)
	gen TIME2018 = (ano == 2018)
	gen TIME2019 = (ano == 2019)
	drop _merge
	
	* Merging with population data
	merge 1:1 MUNICIPIO ano using "${data}/coded/poblacion.dta"
	keep if _merge==3

	* Creating interaction between TIME dummies and treatment
	gen conflict_time = TIME*CONFLICT
	gen conflict_time2015 = CONFLICT*TIME2015
	gen conflict_time2016 = CONFLICT*TIME2016
	gen conflict_time2017 = CONFLICT*TIME2017
	gen conflict_time2018 = CONFLICT*TIME2018
	gen conflict_time2019 = CONFLICT*TIME2019
	
	* Creating proportion of people desplazados and expulsados
	gen prop_desp_recep = (desplazados_recepcion/pobl_tot)*100
	gen prop_desp_expul = (desplazados_expulsion/pobl_tot)*100
	
	* Gen DPTO code
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
	
	save "${data}/coded/mecanismo1.dta", replace
	
	* Regression
	use "${data}/coded/mecanismo1.dta", clear
	
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
	file write latex "Std. Dev. & ${p1_prop_desp_recep} & ${p1_prop_desp_recep} & ${p1_prop_desp_expul} & ${p1_prop_desp_expul}  \\" _n		
	file write latex "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
	file write latex "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
