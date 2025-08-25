/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
9_1_robustness.do

This do file runs robustness 1 - PSM and Parallel trends
=========================================================================*/

*******************************************
*** Robustness 1: PSM *** 
*******************************************

****************************
*** Common support (CS) ***
****************************

	use "${data}/coded/enut/ENUT_FARC_J.dta", clear
	
	*glo covs "gcaribe retro_pobl_rur pobl_rur dismdo disbogota mercado_cercano distancia_mercado pib_agricola pib_industria pib_servicios pib_total nbicabecera IPM_rur ipm_ledu_p ipm_templeof_p v9 v11 v18 v22 v23 v25 v26"
	
	glo covs1 "nbicabecera v9 v11 v22 ipm_templeof_p "
	glo logs "ln_v9 ln_v11 ln_v22 ln_nbicabecera ln_ipm_templeof_p"
	
	collapse (mean) $covs1 CONFLICT MW, by(MUNICIPIO TIME)
	drop if MUNICIPIO==18756 & TIME==0

		* Logarithm
		foreach i in $covs1 {
			replace `i'=. if TIME==1
			gen ln_`i' = asinh(`i') 
			gen sq_`i' = `i'*`i'
		}
	
	logit CONFLICT $covs1 $logs [pw=F_EXP] // No tienen que dar significativas, lo único importante es ver que no haya nada raro
	
	* A. Running treatment with covars before 2014	
	pscore CONFLICT $covs1 $logs [pw=F_EXP], logit pscore(pscore)
	*predict pscore, pr
	
	psgraph, treated(CONFLICT) pscore(pscore) graphregion(style(none) color(gs16)) legen(order(1 "No conflict" 2 "Conflict") cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) 
		graph export "${sale}/ps1.pdf", replace
		
	* B. Balance test
	teffects psmatch (MW) (CONFLICT $covs1 $logs [pw=F_EXP], logit), atet gen(nn_2) nn(10) osample(hola2)
	
	tebalance density, ///
	legend(order(1 "No conflict" 2 "Conflict") region(lcolor(white)) position(3) ring(0)) ///
	ytitle("Density", size(small)) xtitle("Propensity Score", size(small))  ///
	scheme(plotplainblind)
		graph export "${sale}/ps2.pdf", replace
	
	* C. Distribution graph before Common Support
	twoway (histogram pscore [pw=F_EXP] if CONFLICT==1, color(blue%20) lcolor(none)) ///        
	(histogram pscore [pw=F_EXP] if CONFLICT==0, color(green) fcolor(none)), ///   
	legend(order(1 "Conflict" 2 "No conflict") cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) ///
	graphregion(style(none) color(gs16)) xtitle("Propensity Score")
		graph export "${sale}/ps3.pdf", replace
		
	twoway (histogram pscore [pw=F_EXP] if CONFLICT==1, color(blue%20) lcolor(none)) ///        
	(histogram pscore [pw=F_EXP] if CONFLICT==0, color(green) fcolor(none)), ///   
	legend(order(1 "Conflict" 2 "No conflict") rows(1) position(6) size(small) symxsize(3) region(lcolor(white))) ///
	graphregion(style(none) color(gs16)) xsize(4) xtitle("Propensity Score")
		graph export "${sale}/ps3p.pdf", replace
	
	* D. Common Support
	foreach i of numlist 0 1 {
	sum pscore if CONFLICT==`i'
	gen t_`i'= `= r(max)' 
	gen b_`i'= `= r(min)' 
	}
	gen top = min(t_1,t_0)
	gen bottom = max(b_1,b_0)
	drop if pscore > top 
	drop if pscore < bottom
	*drop t_0 t_1 b_0 b_1 pscore top bottom
	
	twoway (histogram pscore [pw=F_EXP] if CONFLICT==1, color(blue%20) lcolor(none)) ///        
	(histogram pscore if CONFLICT==0, color(green) fcolor(none)), ///   
	legend(order(1 "Conflict" 2 "No conflict") cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) ///
	graphregion(style(none) color(gs16)) xtitle("Propensity Score")
		graph export "${sale}/ps4.pdf", replace
		
	twoway (histogram pscore [pw=F_EXP] if CONFLICT==1, color(blue%20) lcolor(none)) ///        
	(histogram pscore if CONFLICT==0, color(green) fcolor(none)), ///   
	legend(order(1 "Conflict" 2 "No conflict") rows(1) position(6) size(small) symxsize(3) region(lcolor(white))) ///
	graphregion(style(none) color(gs16)) xsize(4) xtitle("Propensity Score")
		graph export "${sale}/ps4p.pdf", replace

		
	keep MUNICIPIO	
	save "${data}/coded/enut/ENUT_FARC_PSM.dta", replace

	merge 1:m MUNICIPIO using "${data}/coded/enut/ENUT_FARC_J.dta"

	keep if _merge==3
	
	save "${data}/coded/enut/ENUT_FARC_PSM.dta", replace

*******************************************
*** Multiple hypothesis correction  *** 
*******************************************

	use "${data}/coded/enut/ENUT_FARC_PSM.dta", clear // clave
	
	* v1 - Intensive OLS (Rwolf)
	qui rwolf2 (reg MWc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg NW1c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg NW2c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg NW3c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg CHc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg CUc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global rw1_MW: di %4.3f `= e(RW)[1,3]'
		global rw1_NW1: di %4.3f `= e(RW)[2,3]'
		global rw1_NW2: di %4.3f `= e(RW)[3,3]'
		global rw1_NW3: di %4.3f `= e(RW)[4,3]'
		global rw1_CH: di %4.3f `= e(RW)[5,3]'
		global rw1_CU: di %4.3f `= e(RW)[6,3]'
		display $rw1_MW
		display $rw1_NW1
		display $rw1_NW2
		display $rw1_NW3
		display $rw1_CH
		display $rw1_CU	
		
	* v1 - Intensive OLS (Rwolf) - Year interaction
	qui rwolf2 (reg MWc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg NW1c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg NW2c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg NW3c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg CHc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg CUc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)), ///
	indepvars(conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020) reps(1000) seed(12345)

		* 2016
		global rw2_MW: di %4.3f `= e(RW)[1,3]'
		global rw2_NW1: di %4.3f `= e(RW)[3,3]'
		global rw2_NW2: di %4.3f `= e(RW)[5,3]'
		global rw2_NW3: di %4.3f `= e(RW)[7,3]'
		global rw2_CH: di %4.3f `= e(RW)[9,3]'
		global rw2_CU: di %4.3f `=  e(RW)[11,3]'
		display $rw2_MW
		display $rw2_NW1
		display $rw2_NW2
		display $rw2_NW3
		display $rw2_CH
		display $rw2_CU
		
		* 2020
		global rw3_MW: di %4.3f `= e(RW)[2,3]'
		global rw3_NW1: di %4.3f `= e(RW)[4,3]'
		global rw3_NW2: di %4.3f `= e(RW)[6,3]'
		global rw3_NW3: di %4.3f `= e(RW)[8,3]'
		global rw3_CH: di %4.3f `= e(RW)[10,3]'
		global rw3_CU: di %4.3f `= e(RW)[12,3]'
		display $rw3_MW
		display $rw3_NW1
		display $rw3_NW2
		display $rw3_NW3
		display $rw3_CH
		display $rw3_CU	
		
	* v2 - Intensive Tobit (Sidak)
	qui wyoung $no_tobit, cmd(tobit OUTCOMEVAR conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls [pw=F_EXP], vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time) cluster(MUNICIPIO) bootstraps(100) seed(12345)

		* Sidak
		global rw4_NW3_s: di %4.3f `= r(table)[1,6]'
		global rw4_MW_s: di %4.3f `= r(table)[2,6]'
		global rw4_CH_s: di %4.3f `= r(table)[3,6]'
		global rw4_CU_s: di %4.3f `= r(table)[4,6]'
		display $rw4_NW3_s
		display $rw4_MW_s
		display $rw4_CH_s
		display $rw4_CU_s
		
	* v2 - Intensive Tobit (Sidak) - Year interaction
	qui wyoung $no_tobit, cmd(tobit OUTCOMEVAR conflict_time2016 conflict_time2020 CONFLICT TIME2016 TIME2020 i.ANNO i.MUNICIPIO $controls [pw=F_EXP], vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time2016 conflict_time2020) cluster(MUNICIPIO) bootstraps(100) seed(12345)
	
		* Sidak

			* 2016
			global rw5_NW3_s: di %4.3f `= r(table)[1,6]'
			global rw5_MW_s: di %4.3f `= r(table)[2,6]'
			global rw5_CH_s: di %4.3f `= r(table)[3,6]'
			global rw5_CU_s: di %4.3f `= r(table)[4,6]'
			display $rw5_NW3_s
			display $rw5_MW_s
			display $rw5_CH_s
			display $rw5_CU_s
			
			* 2020
			global rw6_NW3_s: di %4.3f `= r(table)[5,6]'
			global rw6_MW_s: di %4.3f `= r(table)[6,6]'
			global rw6_CH_s: di %4.3f `= r(table)[7,6]'
			global rw6_CU_s: di %4.3f `= r(table)[8,6]'
			display $rw6_NW3_s
			display $rw6_MW_s
			display $rw6_CH_s
			display $rw6_CU_s
			
	* v3 - Extensive Dummys (Rwolf)
	qui rwolf2 (reg MWd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg NW3d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg CHd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg CUd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
	
		global rw7_MW: di %4.3f `= e(RW)[1,3]'
		global rw7_NW3: di %4.3f `= e(RW)[2,3]'
		global rw7_CH: di %4.3f `= e(RW)[3,3]'
		global rw7_CU: di %4.3f `= e(RW)[4,3]'
		display $rw7_MW
		display $rw7_NW3
		display $rw7_CH
		display $rw7_CU
		
	* v3 - Extensive Dummys (Rwolf) - Year interaction
	qui rwolf2 (reg MWd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg NW3d TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg CHd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)) ///
	(reg CUd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls [pw=F_EXP], cluster(MUNICIPIO)), ///
	indepvars(conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020) reps(1000) seed(12345)
	
		* 2016
		global rw8_MW: di %4.3f `= e(RW)[1,3]'
		global rw8_NW3: di %4.3f `= e(RW)[3,3]'
		global rw8_CH: di %4.3f `= e(RW)[5,3]'
		global rw8_CU: di %4.3f `= e(RW)[7,3]'
		display $rw8_MW
		display $rw8_NW3
		display $rw8_CH
		display $rw8_CU	
		
		* 2020
		global rw9_MW: di %4.3f `= e(RW)[2,3]'
		global rw9_NW3: di %4.3f `= e(RW)[4,3]'
		global rw9_CH: di %4.3f `= e(RW)[6,3]'
		global rw9_CU: di %4.3f `= e(RW)[8,3]'
		display $rw9_MW
		display $rw9_NW3
		display $rw9_CH
		display $rw9_CU	
		
*******************************************
*** Regressions  *** 
*******************************************
		
	file open latex using "${sale}/reg1r_2.txt", write replace text
	file write latex "\begin{tabular}{l c c c c c} \\ \hline \hline" _n
	file write latex "& \multicolumn{2}{c}{\textbf{Extensive margin}} && \multicolumn{2}{c}{\textbf{Intensive margin}} \\ " _n
	file write latex " & \multicolumn{2}{c}{\textit{OLS}} && \multicolumn{2}{c}{\textit{Tobit/OLS}} \\ \cline{2-3} \cline{5-6} " _n
	file write latex "& All & By year && All & By year\\" _n	
	file write latex "& (1) & (2) && (3) & (4) \\ \hline" _n

		foreach i in NW3 MW CH CU {
					
			* v1 - Intensive OLS
			reg `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls [pw=F_EXP], vce(cluster MUNICIPIO)
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
			
			* v1 - Intensive OLS - year interaction
			reg `i'c CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls [pw=F_EXP], vce(cluster MUNICIPIO)
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
			
			* v2 - Intensive Tobit
			tobit `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls [pw=F_EXP], vce(cluster MUNICIPIO) ll(0) ul(24)
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
			
			* v2 - Intensive Tobit - year interaction
			tobit `i'c CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls [pw=F_EXP], vce(cluster MUNICIPIO) ll(0) ul(24)
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
			
			* v3 - Extensive Dummy
			reg `i'd CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls [pw=F_EXP], vce(cluster MUNICIPIO)
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
			
			* v3 - Extensive Dummy - year interaction
			reg `i'd CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls [pw=F_EXP], vce(cluster MUNICIPIO)
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
		
		
	file write latex "\textbf{`lab'} \\" _n
	file write latex " Conflict x Time & ${bc_`i'} &&& ${bb_`i'} &\\" _n
	file write latex "  & (${sec_`i'}) &&& (${seb_`i'}) & \\" _n
	file write latex "  & [${rw7_`i'}] &&& \{${rw4_`i'_s}\} & \\" _n

	file write latex " Conflict x 2016 && ${bj_`i'} &&& ${bg_`i'} \\" _n
	file write latex " && (${sej_`i'}) &&& (${seg_`i'})  \\" _n
	file write latex " && [${rw8_`i'}] &&& \{${rw5_`i'_s}\} \\" _n

	file write latex " Conflict x 2020 && ${bk_`i'} &&& ${bh_`i'}  \\" _n
	file write latex " && (${sek_`i'}) &&& (${seh_`i'})  \\" _n
	file write latex " && [${rw9_`i'}] &&& \{${rw6_`i'_s}\} \\" _n

	file write latex " R-squared & ${r25_`i'} & ${r26_`i'} && ${r23_`i'} & ${r24_`i'} \\" _n

	file write latex "\hline" _n
		}	
		
		foreach i in NW1 NW2 {
					
			* v1 - Intensive OLS
			reg `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls [pw=F_EXP], vce(cluster MUNICIPIO)
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
			
			* v1 - Intensive OLS - year interaction
			reg `i'c CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls [pw=F_EXP], vce(cluster MUNICIPIO)
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

		local lab: variable label `i'
		
		
	file write latex "\textbf{`lab'} \\" _n
	file write latex " Conflict x Time & &&& ${ba_`i'} &\\" _n
	file write latex "  & &&& (${sea_`i'}) & \\" _n
	file write latex "  & &&& [${rw1_`i'}] & \\" _n

	file write latex " Conflict x 2016 && &&& ${be_`i'} \\" _n
	file write latex " && &&& (${see_`i'}) \\" _n
	file write latex " && &&& [${rw2_`i'}] \\" _n

	file write latex " Conflict x 2020 && &&& ${bf_`i'} \\" _n
	file write latex " && &&& (${sef_`i'}) \\" _n
	file write latex " && &&& [${rw3_`i'}] \\" _n

	file write latex " R-squared & & && ${r2_`i'} & ${r22_`i'} \\" _n

	file write latex "\hline" _n
		}	
		
	file write latex " Observations & ${N5_MW} & ${N6_MW} && ${N_MW} & ${N2_MW} \\" _n
	file write latex "Year FE & $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$  \\" _n	
	file write latex "Municipality FE & $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$  \\" _n
	file write latex "Controls & $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$ \\" _n			
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
	
