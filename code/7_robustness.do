/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
7_robustness.do

This do file runs robustness checks and mechanisms
=========================================================================*/

*******************************************
*** MECANISMO 1 ***
*******************************************

	use "${entra}/PANEL_CONFLICTO_Y_VIOLENCIA(2020).dta", clear // Este archivo se debe mandar al DANE********
	
	keep desplazados_expulsion desplazados_recepcion codmpio ano
	rename codmpio MUNICIPIO
	drop if ano<2010
	merge n:1 MUNICIPIO using "${entra}/FARC.dta"
	keep if _merge==3
	gen TIME = (ano>2014)
	gen TIME2015 = (ano == 2015)
	gen TIME2016 = (ano == 2016)
	gen TIME2017 = (ano == 2017)
	gen TIME2018 = (ano == 2018)
	gen TIME2019 = (ano == 2019)
	drop _merge
	merge 1:1 MUNICIPIO ano using "${entra}/poblacion.dta" // Este archivo se debe mandar al DANE********
	keep if _merge==3

	gen conflict_time = TIME*CONFLICT
	gen conflict_time2015 = CONFLICT*TIME2015
	gen conflict_time2016 = CONFLICT*TIME2016
	gen conflict_time2017 = CONFLICT*TIME2017
	gen conflict_time2018 = CONFLICT*TIME2018
	gen conflict_time2019 = CONFLICT*TIME2019
	gen prop_desp_recep = (desplazados_recepcion/pobl_tot)*100
	gen prop_desp_expul = (desplazados_expulsion/pobl_tot)*100
	
	sum prop_desp_recep prop_desp_expul
	
	* Regresion
	file open latexm2 using "${output}/mig.txt", write replace text
	file write latexm2 "\begin{tabular}{l c c c c} \\ \hline \hline" _n
	file write latexm2 "& \multicolumn{2}{c}{Received} & \multicolumn{2}{c}{Expelled} \\ " _n
	file write latexm2 "& (1) & (2) & (1) & (2) \\ \hline" _n

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
	
	file write latexm2 " Conflict x Time & ${bb_prop_desp_recep} && ${bb_prop_desp_expul} & \\" _n
	file write latexm2 "  & (${seb_prop_desp_recep}) && (${seb_prop_desp_expul}) & \\" _n

	file write latexm2 " Conflict x 2015 && ${ba_prop_desp_recep} && ${ba_prop_desp_expul} \\" _n
	file write latexm2 "  && (${sea_prop_desp_recep}) && (${sea_prop_desp_expul}) \\" _n

	file write latexm2 " Conflict x 2016 && ${bc_prop_desp_recep} && ${bc_prop_desp_expul} \\" _n
	file write latexm2 "  && (${sec_prop_desp_recep}) && (${sec_prop_desp_expul}) \\" _n
	
	file write latexm2 " Conflict x 2017 && ${bd_prop_desp_recep} && ${bd_prop_desp_expul} \\" _n
	file write latexm2 "  && (${sed_prop_desp_recep}) && (${sed_prop_desp_expul}) \\" _n

	file write latexm2 " Conflict x 2018 && ${be_prop_desp_recep} && ${be_prop_desp_expul} \\" _n
	file write latexm2 "  && (${see_prop_desp_recep}) && (${see_prop_desp_expul}) \\" _n

	file write latexm2 " Conflict x 2019 && ${bf_prop_desp_recep} && ${bf_prop_desp_expul} \\" _n
	file write latexm2 "  && (${sef_prop_desp_recep}) && (${sef_prop_desp_expul}) \\" _n

	file write latexm2 " Observations & ${N_prop_desp_recep} & ${N2_prop_desp_recep} & ${N_prop_desp_expul} & ${N2_prop_desp_recep}\\" _n
	file write latexm2 " R-squared & ${r2_prop_desp_recep} & ${r22_prop_desp_recep} & ${r2_prop_desp_expul} & ${r22_prop_desp_expul} \\" _n
	file write latexm2 "\hline" _n

	file write latexm2 "Mean & ${m1_prop_desp_recep} & ${m1_prop_desp_recep} & ${m1_prop_desp_expul} & ${m1_prop_desp_expul} \\" _n
	file write latexm2 "Standard Deviation & ${p1_prop_desp_recep} & ${p1_prop_desp_recep} & ${p1_prop_desp_expul} & ${p1_prop_desp_expul}  \\" _n		
	file write latexm2 "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
	file write latexm2 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
	file write latexm2 "\hline \hline" _n
	file write latexm2 "\end{tabular}" _n
	file close latexm2
	
	reg prop_desp_recep conflict_time i.MUNICIPIO i.ano // i.MUNICIPIO i.ano - después de agregar efectos fijos se vuelve significativo
	reg prop_desp_expul conflict_time i.MUNICIPIO i.ano // i.MUNICIPIO i.ano

*******************************************
*** MECANISMO 2 ***
*******************************************

	use "${enut}/ENUT_FARC_ALL.dta", clear
	
	gen p_hhth = (hhth/hht)*100
	gen p_hhthj = (hhthj/hht)*100
	gen p_hdist = (hdist/hht)*100
		
	collapse (mean) hht* hdist CONFLICT ANNO MUNICIPIO p_hhth p_hhthj p_hdist, by(idhogar TIME)
	gen conflict_time = CONFLICT*TIME
		foreach i in $mecs {
		*replace `i'=. if CONFLICT==0
		replace `i'=0 if `i'==.
	}
	
	* Regresion
	file open latexm1 using "${output}/mecanismos1.txt", write replace text
	file write latexm1 "\begin{tabular}{l c c c c c c c c} \\ \hline \hline" _n
	file write latexm1 "& \multicolumn{2}{c}{Total} & \multicolumn{2}{c}{\% of males} & \multicolumn{2}{c}{\% of young males} & \multicolumn{2}{c}{\% of disabled} \\ " _n
	file write latexm1 "& (1) & (2) & (1) & (2) & (1) & (2) & (1) & (2) \\ \hline" _n

	foreach i in p_hhth p_hhthj p_hdist hht {
		
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
	
	file write latexm1 " Conflict x Time & ${ba_hht} && ${ba_p_hhth} && ${ba_p_hhthj} && ${ba_p_hdist} & \\" _n
	file write latexm1 "  & (${sea_hht}) && (${sea_p_hhth}) && (${sea_p_hhthj}) && (${sea_p_hdist}) & \\" _n

	file write latexm1 " Conflict x 2016 && ${bd_hht} && ${bd_p_hhth} && ${bd_p_hhthj} && ${bd_p_hdist} \\" _n
	file write latexm1 "  && (${sed_hht}) && (${sed_p_hhth}) && (${sed_p_hhthj}) && (${sed_p_hdist}) \\" _n
	
	file write latexm1 " Conflict x 2020 && ${be_hht} && ${be_p_hhth} && ${be_p_hhthj} && ${be_p_hdist} \\" _n
	file write latexm1 "  && (${see_hht}) && (${see_p_hhth}) && (${see_p_hhthj}) && (${see_p_hdist}) \\" _n
	
	file write latexm1 " Conflict & ${bb_hht} && ${bb_p_hhth} && ${bb_p_hhthj} && ${bb_p_hdist} & \\" _n
	file write latexm1 "  & (${seb_hht}) && (${seb_p_hhth}) && (${seb_p_hhthj}) && (${seb_p_hdist}) & \\" _n

	file write latexm1 " Time & ${bc_hht} && ${bc_p_hhth} && ${bc_p_hhthj} && ${bc_p_hdist} & \\" _n
	file write latexm1 "  & (${sec_hht}) && (${sec_p_hhth}) && (${sec_p_hhthj}) && (${sec_p_hdist}) & \\" _n

	file write latexm1 " Observations & ${N_hht} & ${N2_hht} & ${N_p_hhth} & ${N2_p_hhth} & ${N_p_hhthj} & ${N2_p_hhthj} & ${N_p_hdist} & ${N2_p_hdist} \\" _n
	file write latexm1 " R-squared & ${r2_hht} & ${r22_hht} & ${r2_p_hhth} & ${r22_p_hhth} & ${r2_p_hhthj} & ${r22_p_hhthj} & ${r2_p_hdist} & ${r22_p_hdist} \\" _n
	file write latexm1 "\hline" _n

	file write latexm1 "Mean & ${m1_hht} & ${m1_hht} & ${m1_p_hhth}  & ${m1_p_hhth} & ${m1_p_hhthj} & ${m1_p_hhthj} & ${m1_p_hdist} & ${m1_p_hdist} \\" _n
	file write latexm1 "Standard Deviation & ${p1_hht} & ${p1_hht} & ${p1_p_hhth} & ${p1_p_hhth} & ${p1_p_hhthj} & ${p1_p_hhthj} & ${p1_p_hdist} & ${p1_p_hdist} \\" _n
	file write latexm1 "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$  \\" _n	
	file write latexm1 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n			
	file write latexm1 "\hline \hline" _n
	file write latexm1 "\end{tabular}" _n
	file close latexm1

*******************************************
*** DISTINTA MEDIDA DE CONFLICTO ***
*******************************************

	use "${enut}/ENUT_FARC.dta", clear
	
	file open latex1 using "${sale}/reg1r.txt", write replace text
	file write latex1 "\begin{tabular}{l c c c c c c} \\ \hline \hline" _n
	file write latex1 "& \multicolumn{2}{c}{Extensive margin} & \multicolumn{4}{c}{Intensive margin}  \\ \cline{2-7}" _n
	file write latex1 "& \multicolumn{2}{c}{Dummy} & \multicolumn{2}{c}{OLS} & \multicolumn{2}{c}{Tobit} \\" _n
	file write latex1 "& (1) & (2) & (3) & (4) & (5) & (6) \\ \hline" _n

		foreach i in $out {
					
			* v1 - Básica (OLS)
			reg `i'c CONFLICT1 TIME conflict_time1 i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO)
			local a: di %4.3f `= _b[conflict_time1]'
			global sea_`i': di %4.3f `= _se[conflict_time1]'
			local ta=_b[conflict_time1]/_se[conflict_time1]
			local pa= 2*ttail(`e(df_r)',abs(`ta'))
			global r2_`i': di %4.3f `= e(r2)'
			global N_`i': di %9.0f `= e(N)'
			
			if `pa'<=0.01 {
				global ba_`i' "`a'\sym{***}"
			}
			
			if `pa'<=0.05 & `pa'>0.01 {
				global ba_`i' "`a'\sym{**}"
			}
			
			if `pa'<=0.1 & `pa'>0.05 {
				global ba_`i' "`a'\sym{*}"
			}

			if `pa'>0.1  {
				global ba_`i' "`a'"
			}
			
			* v1 - Interacción por año (OLS)
			reg `i'c CONFLICT1 TIME2016 TIME2020 conflict_time12016 conflict_time12020 i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO)
			local e: di %4.3f `= _b[conflict_time12016]'
			global see_`i': di %4.3f `= _se[conflict_time12016]'	
			local f: di %4.3f `= _b[conflict_time12020]'
			global sef_`i': di %4.3f `= _se[conflict_time12020]'
			local te=_b[conflict_time12016]/_se[conflict_time12016]
			local tf=_b[conflict_time12020]/_se[conflict_time12020]
			local pe= 2*ttail(`e(df_r)',abs(`te'))
			local pf= 2*ttail(`e(df_r)',abs(`tf'))
			global r22_`i': di %4.3f `= e(r2)'
			global N2_`i': di %9.0f `= e(N)'
			
			foreach n in e f {
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
			
			* v2 - Básica (Tobit)
			tobit `i'c CONFLICT1 TIME conflict_time1 i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO) ll(0) ul(24)
			local b: di %4.3f `= _b[conflict_time1]'
			global seb_`i': di %4.3f `= _se[conflict_time1]'
			local tb=_b[conflict_time1]/_se[conflict_time1]
			local pb= 2*ttail(`e(df_r)',abs(`tb'))
			global r23_`i': di %4.3f `= e(r2)'
			global N3_`i': di %9.0f `= e(N)'
			
			if `pb'<=0.01 {
				global bb_`i' "`b'\sym{***}"
			}
			
			if `pb'<=0.05 & `pb'>0.01 {
				global bb_`i' "`b'\sym{**}"
			}
			
			if `pb'<=0.1 & `pb'>0.05 {
				global bb_`i' "`b'\sym{*}"
			}

			if `pb'>0.1  {
				global bb_`i' "`b'"
			}
			
			* v2 - Interacción por año (Tobit)
			tobit `i'c CONFLICT1 TIME2016 TIME2020 conflict_time12016 conflict_time12020 i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO) ll(0) ul(24)
			local g: di %4.3f `= _b[conflict_time12016]'
			global seg_`i': di %4.3f `= _se[conflict_time12016]'	
			local h: di %4.3f `= _b[conflict_time12020]'
			global seh_`i': di %4.3f `= _se[conflict_time12020]'
			local tg=_b[conflict_time12016]/_se[conflict_time12016]
			local th=_b[conflict_time12020]/_se[conflict_time12020]
			local pg= 2*ttail(`e(df_r)',abs(`tg'))
			local ph= 2*ttail(`e(df_r)',abs(`th'))
			global r24_`i': di %4.3f `= e(r2)'
			global N4_`i': di %9.0f `= e(N)'
			
			foreach n in g h {
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
			
			* v3 - Básica (Dummy)
			reg `i'd CONFLICT1 TIME conflict_time1 i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO)
			local c: di %4.3f `= _b[conflict_time1]'
			global sec_`i': di %4.3f `= _se[conflict_time1]'
			local tc=_b[conflict_time1]/_se[conflict_time1]
			local pc= 2*ttail(`e(df_r)',abs(`tc'))
			global r25_`i': di %4.3f `= e(r2)'
			global N5_`i': di %9.0f `= e(N)'
			
			if `pc'<=0.01 {
				global bc_`i' "`c'\sym{***}"
			}
			
			if `pc'<=0.05 & `pc'>0.01 {
				global bc_`i' "`c'\sym{**}"
			}
			
			if `pc'<=0.1 & `pc'>0.05 {
				global bc_`i' "`c'\sym{*}"
			}

			if `pc'>0.1  {
				global bc_`i' "`c'"
			}
			
			* v3 - Interacción por año (Dummy)
			reg `i'd CONFLICT1 TIME2016 TIME2020 conflict_time12016 conflict_time12020 i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO)
			local j: di %4.3f `= _b[conflict_time12016]'
			global sej_`i': di %4.3f `= _se[conflict_time12016]'	
			local k: di %4.3f `= _b[conflict_time12020]'
			global sek_`i': di %4.3f `= _se[conflict_time12020]'
			local tj=_b[conflict_time12016]/_se[conflict_time12016]
			local tk=_b[conflict_time12020]/_se[conflict_time12020]
			local pj= 2*ttail(`e(df_r)',abs(`tj'))
			local pk= 2*ttail(`e(df_r)',abs(`tk'))
			global r26_`i': di %4.3f `= e(r2)'
			global N6_`i': di %9.0f `= e(N)'
			
			foreach n in j k {
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

		local lab: variable label `i'
		
		foreach n in c d {
			foreach a of numlist 0/1 {
				sum `i'`n' if TIME==0 & CONFLICT==`a', d 
				global m`n'`a'_`i': di %10.2f `= r(mean)'
			}
		}
		
	file write latex1 "\textbf{`lab'} \\" _n
	file write latex1 " Conflict x Time & ${bc_`i'} && ${ba_`i'} && ${bb_`i'} & \\" _n
	file write latex1 "  & (${sec_`i'}) && (${sea_`i'}) && (${seb_`i'}) & \\" _n

	file write latex1 " Conflict x 2016 && ${bj_`i'} && ${be_`i'} && ${bg_`i'}  \\" _n
	file write latex1 " && (${sej_`i'}) && (${see_`i'}) && (${seg_`i'})\\" _n

	file write latex1 " Conflict x 2020 && ${bk_`i'} && ${bf_`i'} && ${bh_`i'} \\" _n
	file write latex1 " && (${sek_`i'}) && (${sef_`i'}) && (${seh_`i'}) \\" _n

	file write latex1 " Observations & ${N5_`i'} & ${N6_`i'} & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} \\" _n
	file write latex1 " R-squared & ${r25_`i'} & ${r26_`i'} & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} \\" _n
	file write latex1 " Pre-t. treat. mean & ${md1_`i'} & ${md1_`i'} & ${mc1_`i'} & ${mc1_`i'} & ${mc1_`i'} & ${mc1_`i'} \\" _n
	file write latex1 " Pre-t. cont. mean & ${md0_`i'} & ${md0_`i'} & ${mc0_`i'} & ${mc0_`i'} & ${mc0_`i'} & ${mc0_`i'} \\" _n

	file write latex1 "\hline" _n
		}
	file write latex1 "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$  & $\checkmark$ & $\checkmark$  \\" _n	
	file write latex1 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$  \\" _n
	file write latex1 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$  \\" _n			
	file write latex1 "\hline \hline" _n
	file write latex1 "\end{tabular}" _n
	file close latex1

*******************************************
*** PROPENSITY SCORE - COMMON SUPPORT ***
*******************************************

****************************
*** COMMON SUPPORT ***
****************************

	use "${enut}/ENUT_FARC.dta", clear 
	
	*glo covs "gcaribe retro_pobl_rur pobl_rur dismdo disbogota mercado_cercano distancia_mercado pib_agricola pib_industria pib_servicios pib_total nbicabecera IPM_rur ipm_ledu_p ipm_templeof_p v9 v11 v18 v22 v23 v25 v26"
	
	glo covs1 "nbicabecera v9 v11 v22 ipm_templeof_p "
	glo logs "ln_v9 ln_v11 ln_v22 ln_nbicabecera ln_ipm_templeof_p"
	
	collapse (mean) $covs1 CONFLICT MW, by(MUNICIPIO TIME)
	drop if MUNICIPIO==18756 & TIME==0

		* Logaritmo
		foreach i in $covs1 {
			replace `i'=. if TIME==1
			gen ln_`i' = asinh(`i') 
			gen sq_`i' = `i'*`i'
		}
	
	logit CONFLICT $covs1 $logs // No tienen que dar significativas, lo único importante es ver que no haya nada raro

	* A. Corro el tratamiento con las covariables de antes de 2014	
	pscore CONFLICT $covs1 $logs, logit pscore(pscore)
	psgraph, treated(CONFLICT) pscore(pscore) graphregion(style(none) color(gs16)) legen(order(1 "Control" 2 "Treated") cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) 
		graph export "${sale}/ps1.pdf", replace
		
	* B. Otra prueba de balanceo 
	teffects psmatch (MW) (CONFLICT $covs1 $logs, logit), atet gen(nn_2) nn(10) osample(hola2)
	tebalance density 
		graph export "${sale}/ps2.pdf", replace
	
	* C. Grafico las distribuciones antes de hacer common support
	twoway (histogram pscore if CONFLICT==1, color(blue%20) lcolor(none)) ///        
	(histogram pscore if CONFLICT==0, color(grey%80) fcolor(none)), ///   
	legend(order(1 "Treatment" 2 "Control" ) cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) ///
	graphregion(style(none) color(gs16)) title("Panel A: Before delimiting by common support")
		graph export "${sale}/ps3.pdf", replace
		
	twoway (histogram pscore if CONFLICT==1, color(blue%20) lcolor(none)) ///        
	(histogram pscore if CONFLICT==0, color(grey%80) fcolor(none)), ///   
	legend(order(1 "Treatment" 2 "Control" ) rows(1) position(6) size(small) symxsize(3) region(lcolor(white))) ///
	graphregion(style(none) color(gs16)) xsize(4)
		graph export "${sale}/ps3p.pdf", replace
	
	* D. Sacamos el soporte común
	foreach i of numlist 0 1 {
	sum pscore if CONFLICT==`i'
	gen t_`i'= `= r(max)' 
	gen b_`i'= `= r(min)' 
	}
	gen top = min(t_1,t_0)
	gen bottom = max(b_1,b_0)
	drop if pscore > top 
	drop if pscore < bottom // ¿Cuantas observaciones se van y con cuantas me quedo?
	*drop t_0 t_1 b_0 b_1 pscore top bottom
	
	twoway (histogram pscore if CONFLICT==1, color(blue%20) lcolor(none)) ///        
	(histogram pscore if CONFLICT==0, color(grey%80) fcolor(none)), ///   
	legend(order(1 "Treatment" 2 "Control" ) cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) ///
	graphregion(style(none) color(gs16)) title("Panel B: After delimiting by common support")
		graph export "${sale}/ps4.pdf", replace
		
	twoway (histogram pscore if CONFLICT==1, color(blue%20) lcolor(none)) ///        
	(histogram pscore if CONFLICT==0, color(grey%80) fcolor(none)), ///   
	legend(order(1 "Treatment" 2 "Control" ) rows(1) position(6) size(small) symxsize(3) region(lcolor(white))) ///
	graphregion(style(none) color(gs16)) xsize(4)
		graph export "${sale}/ps4p.pdf", replace

		
	keep MUNICIPIO	
	save "${enut}/ENUT_FARC_PSM.dta", replace

	merge 1:m MUNICIPIO using "${enut}/ENUT_FARC.dta"

	keep if _merge==3
	
	save "${enut}/ENUT_FARC_PSM.dta", replace

****************************
*** NEW RESULTS WITH CS ***
****************************

	use "${enut}/ENUT_FARC_PSM.dta", clear
	
	foreach i in v4 v20 {
		gen `i'_c=`i'*TIME
	}
	
	
	file open latex1 using "${sale}/reg1r_2.txt", write replace text
	file write latex1 "\begin{tabular}{l c c c c c c} \\ \hline \hline" _n
	file write latex1 "& \multicolumn{2}{c}{Extensive margin} & \multicolumn{4}{c}{Intensive margin}  \\ \cline{2-7}" _n
	file write latex1 "& \multicolumn{2}{c}{Dummy} & \multicolumn{2}{c}{OLS} & \multicolumn{2}{c}{Tobit} \\" _n
	file write latex1 "& (1) & (2) & (3) & (4) & (5) & (6) \\ \hline" _n

		foreach i in $out {
					
			* v1 - Básica (OLS)
			reg `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO)
			local a: di %4.3f `= _b[conflict_time]'
			global sea_`i': di %4.3f `= _se[conflict_time]'
			local ta=_b[conflict_time]/_se[conflict_time]
			local pa= 2*ttail(`e(df_r)',abs(`ta'))
			global r2_`i': di %4.3f `= e(r2)'
			global N_`i': di %9.0f `= e(N)'
			
			if `pa'<=0.01 {
				global ba_`i' "`a'\sym{***}"
			}
			
			if `pa'<=0.05 & `pa'>0.01 {
				global ba_`i' "`a'\sym{**}"
			}
			
			if `pa'<=0.1 & `pa'>0.05 {
				global ba_`i' "`a'\sym{*}"
			}

			if `pa'>0.1  {
				global ba_`i' "`a'"
			}
			
			* v1 - Interacción por año (OLS)
			reg `i'c CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO)
			local e: di %4.3f `= _b[conflict_time2016]'
			global see_`i': di %4.3f `= _se[conflict_time2016]'	
			local f: di %4.3f `= _b[conflict_time2020]'
			global sef_`i': di %4.3f `= _se[conflict_time2020]'
			local te=_b[conflict_time2016]/_se[conflict_time2016]
			local tf=_b[conflict_time2020]/_se[conflict_time2020]
			local pe= 2*ttail(`e(df_r)',abs(`te'))
			local pf= 2*ttail(`e(df_r)',abs(`tf'))
			global r22_`i': di %4.3f `= e(r2)'
			global N2_`i': di %9.0f `= e(N)'
			
			foreach n in e f {
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
			
			* v2 - Básica (Tobit)
			tobit `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO) ll(0) ul(24)
			local b: di %4.3f `= _b[conflict_time]'
			global seb_`i': di %4.3f `= _se[conflict_time]'
			local tb=_b[conflict_time]/_se[conflict_time]
			local pb= 2*ttail(`e(df_r)',abs(`tb'))
			global r23_`i': di %4.3f `= e(r2)'
			global N3_`i': di %9.0f `= e(N)'
			
			if `pb'<=0.01 {
				global bb_`i' "`b'\sym{***}"
			}
			
			if `pb'<=0.05 & `pb'>0.01 {
				global bb_`i' "`b'\sym{**}"
			}
			
			if `pb'<=0.1 & `pb'>0.05 {
				global bb_`i' "`b'\sym{*}"
			}

			if `pb'>0.1  {
				global bb_`i' "`b'"
			}
			
			* v2 - Interacción por año (Tobit)
			tobit `i'c CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO) ll(0) ul(24)
			local g: di %4.3f `= _b[conflict_time2016]'
			global seg_`i': di %4.3f `= _se[conflict_time2016]'	
			local h: di %4.3f `= _b[conflict_time2020]'
			global seh_`i': di %4.3f `= _se[conflict_time2020]'
			local tg=_b[conflict_time2016]/_se[conflict_time2016]
			local th=_b[conflict_time2020]/_se[conflict_time2020]
			local pg= 2*ttail(`e(df_r)',abs(`tg'))
			local ph= 2*ttail(`e(df_r)',abs(`th'))
			global r24_`i': di %4.3f `= e(r2)'
			global N4_`i': di %9.0f `= e(N)'
			
			foreach n in g h {
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
			
			* v3 - Básica (Dummy)
			reg `i'd CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO)
			local c: di %4.3f `= _b[conflict_time]'
			global sec_`i': di %4.3f `= _se[conflict_time]'
			local tc=_b[conflict_time]/_se[conflict_time]
			local pc= 2*ttail(`e(df_r)',abs(`tc'))
			global r25_`i': di %4.3f `= e(r2)'
			global N5_`i': di %9.0f `= e(N)'
			
			if `pc'<=0.01 {
				global bc_`i' "`c'\sym{***}"
			}
			
			if `pc'<=0.05 & `pc'>0.01 {
				global bc_`i' "`c'\sym{**}"
			}
			
			if `pc'<=0.1 & `pc'>0.05 {
				global bc_`i' "`c'\sym{*}"
			}

			if `pc'>0.1  {
				global bc_`i' "`c'"
			}
			
			* v3 - Interacción por año (Dummy)
			reg `i'd CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO)
			local j: di %4.3f `= _b[conflict_time2016]'
			global sej_`i': di %4.3f `= _se[conflict_time2016]'	
			local k: di %4.3f `= _b[conflict_time2020]'
			global sek_`i': di %4.3f `= _se[conflict_time2020]'
			local tj=_b[conflict_time2016]/_se[conflict_time2016]
			local tk=_b[conflict_time2020]/_se[conflict_time2020]
			local pj= 2*ttail(`e(df_r)',abs(`tj'))
			local pk= 2*ttail(`e(df_r)',abs(`tk'))
			global r26_`i': di %4.3f `= e(r2)'
			global N6_`i': di %9.0f `= e(N)'
			
			foreach n in j k {
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

		local lab: variable label `i'
		
		foreach n in c d {
			foreach a of numlist 0/1 {
				sum `i'`n' if TIME==0 & CONFLICT==`a', d 
				global m`n'`a'_`i': di %10.2f `= r(mean)'
			}
		}
		
	file write latex1 "\textbf{`lab'} \\" _n
	file write latex1 " Conflict x Time & ${bc_`i'} && ${ba_`i'} && ${bb_`i'} & \\" _n
	file write latex1 "  & (${sec_`i'}) && (${sea_`i'}) && (${seb_`i'}) & \\" _n

	file write latex1 " Conflict x 2016 && ${bj_`i'} && ${be_`i'} && ${bg_`i'}  \\" _n
	file write latex1 " && (${sej_`i'}) && (${see_`i'}) && (${seg_`i'})\\" _n

	file write latex1 " Conflict x 2020 && ${bk_`i'} && ${bf_`i'} && ${bh_`i'} \\" _n
	file write latex1 " && (${sek_`i'}) && (${sef_`i'}) && (${seh_`i'}) \\" _n

	file write latex1 " Observations & ${N5_`i'} & ${N6_`i'} & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} \\" _n
	file write latex1 " R-squared & ${r25_`i'} & ${r26_`i'} & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} \\" _n
	file write latex1 " Pre-t. treat. mean & ${md1_`i'} & ${md1_`i'} & ${mc1_`i'} & ${mc1_`i'} & ${mc1_`i'} & ${mc1_`i'} \\" _n
	file write latex1 " Pre-t. cont. mean & ${md0_`i'} & ${md0_`i'} & ${mc0_`i'} & ${mc0_`i'} & ${mc0_`i'} & ${mc0_`i'} \\" _n

	file write latex1 "\hline" _n
		}
	file write latex1 "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$  & $\checkmark$ & $\checkmark$  \\" _n	
	file write latex1 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$  \\" _n
	file write latex1 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$  \\" _n			
	file write latex1 "\hline \hline" _n
	file write latex1 "\end{tabular}" _n
	file close latex1
	
	
/*******************************************
*** CENSUS ***
*******************************************

	foreach i in 05 08 11 13 15 17 18 19 20 23 25 27 41 44 47 50 52 54 63 66 68 70 73 76 81 85 86 88 91 94 95 97 99 {
	
	use "${data}/raw/CNPV2018_5PER_A2_`i'.DTA", clear
	
	keep u_mpio p_nrohog p_nro_per pa_vivia_5anos pa_vivia_1ano p_edadr u_dpto
	gen unos=1
	gen MUNICIPIO = u_dpto + u_mpio
	destring MUNICIPIO, replace
	
	merge m:1 MUNICIPIO using "$v/FARC.dta"
	
	keep if _merge==3

	drop u_mpio p_nrohog p_nro_per u_dpto
	save "${data}/coded/censo_depto_`i'.dta", replace
	}
	
	use "${data}/coded/censo_depto_05.dta", clear
	foreach i in 08 11 13 15 17 18 19 20 23 25 27 41 44 47 50 52 54 63 66 68 70 73 76 81 85 86 88 91 94 95 97 99 {
		append using "${data}/coded/censo_depto_`i'.dta"
	}
	
	gen vivia_1 = (pa_vivia_1ano==3)
	gen vivia_5 = (pa_vivia_5anos==3)

	gen young=.
	replace young=1 if p_edadr==4 | p_edadr==5 | p_edadr==6
	gen vivia_1y = (pa_vivia_1ano==3)
	gen vivia_5y = (pa_vivia_5anos==3)
	replace vivia_1y=. if young==.
	replace vivia_5y=. if young==.
	
	replace vivia_1=100 if vivia_1==1
	replace vivia_5=100 if vivia_5==1
	drop pa_vivia_1ano pa_vivia_5anos
	save "${data}/coded/censo_depto_total.dta", replace */ // Este archivo se debe mandar al DANE********
	
	use "${data}/coded/censo_depto_total.dta", clear
	
	* Regresion
	file open latexm1 using "${output}/censo.txt", write replace text
	file write latexm1 "\begin{tabular}{l c c c c} \\ \hline \hline" _n
	file write latexm1 "& \multicolumn{2}{c}{Total population} & \multicolumn{2}{c}{Young population} \\ \cline{2-5}" _n
	file write latexm1 "& Five years back & One year back & Five years back & One year back \\ " _n
	file write latexm1 "& (1) & (2) & (3) & (4) \\ \hline" _n

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
	
	file write latexm1 " Conflict & ${bb_vivia_5} & ${bb_vivia_1} & ${bb_vivia_5y} & ${bb_vivia_1y} \\" _n
	file write latexm1 "  & (${seb_vivia_5}) & (${seb_vivia_1}) & (${seb_vivia_5y}) & (${seb_vivia_1y}) \\" _n

	file write latexm1 " Observations & ${N_vivia_5} & ${N_vivia_1} & ${N_vivia_5y} & ${N_vivia_1y} \\" _n
	file write latexm1 " R-squared & ${r2_vivia_5} & ${r2_vivia_1} & ${r2_vivia_5y} & ${r2_vivia_1y} \\" _n
	file write latexm1 "\hline" _n

	file write latexm1 "Mean & ${m1_vivia_5} & ${m1_vivia_1} & ${m1_vivia_5y} & ${m1_vivia_1y} \\" _n
	file write latexm1 "Standard Deviation & ${p1_vivia_5} & ${p1_vivia_1} & ${p1_vivia_5y} & ${p1_vivia_1y} \\" _n		
	file write latexm1 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
	file write latexm1 "\hline \hline" _n
	file write latexm1 "\end{tabular}" _n
	file close latexm1

/*------------------------------------------------------------------------------*
* 4. absdid - Houngbedji
*------------------------------------------------------------------------------*

*ssc install absdid

	use "${enut}/ENUT_FARC.dta", clear
	
	reshape wide $out, i(personid) j(TIME)

	foreach i inb $out {
		gen `i'_dif = 
	}
gen share_Alimentos_dif = share_Alimentos3 - share_Alimentos2
gen share_Salud_dif = share_Salud3 - share_Salud2

foreach i of numlist 0/1 {
	foreach varinteres in share_Alimentos_dif share_Salud_dif {

	absdid `varinteres' [aweight=fexhog_mean] if urbano2==`i' & urbano3==`i', tvar(choque_salud_132) xvar($cov13_l2 $en $cov13_l)
	}
}

