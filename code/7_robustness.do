/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
7_robustness.do

This do file runs robustness checks
=========================================================================*/

* ----------------------------------------------------------------------
* I. Distinta medida de conflicto
* ----------------------------------------------------------------------

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

* ----------------------------------------------------------------------*
* II. Propensity Score - Sopporte comun 
* ----------------------------------------------------------------------*

* ---------------------------------------------------------*
* II.1 Propensity Score calculation and common support
* ---------------------------------------------------------*

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

* ---------------------------------------------------------*
* II.2 Main results with common support
* ---------------------------------------------------------*

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

