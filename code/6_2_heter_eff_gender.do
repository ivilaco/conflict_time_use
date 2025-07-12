/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
7_2_heter_eff_gender.do

This do file runs regression with heterogeneous effects - Gender
=========================================================================*/

	use "${enut}/ENUT_FARC_J.dta", clear // clave

	foreach i in v4 v20 {
		gen `i'_c=`i'*TIME
	}
	
**************************************
*** Mean and SD per group *** 
**************************************

	file open latex using "${output}/m_sd_he_gender.txt", write replace text
	file write latex "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
	file write latex "\begin{tabular}{l c c c c c c c c c c c} \\ \hline \hline" _n
	
	file write latex "& \multicolumn{5}{c}{\textbf{Extensive margin}} && \multicolumn{5}{c}{\textbf{Intensive margin}} \\" _n
	file write latex "& \multicolumn{2}{c}{\textit{Treatment}} && \multicolumn{2}{c}{\textit{Control}} && \multicolumn{2}{c}{\textit{Treatment}} && \multicolumn{2}{c}{\textit{Control}} \\ \cline{2-3} \cline{5-6} \cline{8-9} \cline{11-12} " _n
	file write latex "& Mean & Std. Dev. && Mean & Std. Dev. && Mean & Std. Dev. && Mean & Std. Dev. \\ " _n
	file write latex "& (1) & (2) && (3) & (4) && (5) & (6) && (7) & (8) \\ \hline" _n

	* Gender	
	foreach i in $out {
		
		foreach a of numlist 0/1 {
			
			forvalues n = 0/1 {			
			
				sum `i'd if TIME==0 & CONFLICT==`a' & SEXO==`n', d 
				global m`n'_d`a'_`i': di %10.2f `= r(mean)'
				global sd`n'_d`a'_`i': di %10.2f `= r(sd)'
				
				sum `i'c if TIME==0 & CONFLICT==`a' & SEXO==`n', d 
				global m`n'_c`a'_`i': di %10.2f `= r(mean)'
				global sd`n'_c`a'_`i': di %10.2f `= r(sd)'
				
			}
		}
		
		local lab: variable label `i'
		
		file write latex "`lab' \\" _n
		file write latex "\hspace{3mm} Females & ${m1_d1_`i'} & ${sd1_d1_`i'} && ${m1_d0_`i'} & ${sd1_d0_`i'} && ${m1_c1_`i'} & ${sd1_c1_`i'} && ${m1_c0_`i'} & ${sd1_c0_`i'} \\" _n
		file write latex "\hspace{3mm} Males & ${m0_d1_`i'} & ${sd0_d1_`i'} && ${m0_d0_`i'} & ${sd0_d0_`i'} && ${m0_c1_`i'} & ${sd0_c1_`i'} && ${m0_c0_`i'} & ${sd0_c0_`i'} \\" _n
		file write latex "\\" _n

	}
	
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
	
**************************************
*** Multiple hypothesis correction *** 
**************************************

***** Extensive

	* Women
	qui rwolf2 (reg MWd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if SEXO==1, cluster(MUNICIPIO)) ///
	(reg NW1d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==1, cluster(MUNICIPIO)) ///
	(reg NW2d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==1, cluster(MUNICIPIO)) ///
	(reg NW3d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==1, cluster(MUNICIPIO)) ///
	(reg CHd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==1, cluster(MUNICIPIO)) ///
	(reg CUd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==1, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global a_MW: di %4.3f `= e(RW)[1,3]'
		global a_NW1: di %4.3f `= e(RW)[2,3]'
		global a_NW2: di %4.3f `= e(RW)[3,3]'
		global a_NW3: di %4.3f `= e(RW)[4,3]'
		global a_CH: di %4.3f `= e(RW)[5,3]'
		global a_CU: di %4.3f `= e(RW)[6,3]'
		
	* Men
	qui rwolf2 (reg MWd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if SEXO==0, cluster(MUNICIPIO)) ///
	(reg NW1d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==0, cluster(MUNICIPIO)) ///
	(reg NW2d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==0, cluster(MUNICIPIO)) ///
	(reg NW3d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==0, cluster(MUNICIPIO)) ///
	(reg CHd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==0, cluster(MUNICIPIO)) ///
	(reg CUd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==0, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global b_MW: di %4.3f `= e(RW)[1,3]'
		global b_NW1: di %4.3f `= e(RW)[2,3]'
		global b_NW2: di %4.3f `= e(RW)[3,3]'
		global b_NW3: di %4.3f `= e(RW)[4,3]'
		global b_CH: di %4.3f `= e(RW)[5,3]'
		global b_CU: di %4.3f `= e(RW)[6,3]'

***** Intensive - OLS	
	
	* Women
	qui rwolf2 (reg MWc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if SEXO==1, cluster(MUNICIPIO)) ///
	(reg NW1c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==1, cluster(MUNICIPIO)) ///
	(reg NW2c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==1, cluster(MUNICIPIO)) ///
	(reg NW3c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==1, cluster(MUNICIPIO)) ///
	(reg CHc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==1, cluster(MUNICIPIO)) ///
	(reg CUc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==1, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global d_MW: di %4.3f `= e(RW)[1,3]'
		global d_NW1: di %4.3f `= e(RW)[2,3]'
		global d_NW2: di %4.3f `= e(RW)[3,3]'
		global d_NW3: di %4.3f `= e(RW)[4,3]'
		global d_CH: di %4.3f `= e(RW)[5,3]'
		global d_CU: di %4.3f `= e(RW)[6,3]'
			
	* Men
	qui rwolf2 (reg MWc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if SEXO==0, cluster(MUNICIPIO)) ///
	(reg NW1c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==0, cluster(MUNICIPIO)) ///
	(reg NW2c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==0, cluster(MUNICIPIO)) ///
	(reg NW3c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==0, cluster(MUNICIPIO)) ///
	(reg CHc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==0, cluster(MUNICIPIO)) ///
	(reg CUc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if SEXO==0, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global e_MW: di %4.3f `= e(RW)[1,3]'
		global e_NW1: di %4.3f `= e(RW)[2,3]'
		global e_NW2: di %4.3f `= e(RW)[3,3]'
		global e_NW3: di %4.3f `= e(RW)[4,3]'
		global e_CH: di %4.3f `= e(RW)[5,3]'
		global e_CU: di %4.3f `= e(RW)[6,3]'	
		
***** Intesive - Tobit
	
	* Women
	qui wyoung $ceros, cmd(tobit OUTCOMEVAR conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if SEXO==1, vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time) cluster(MUNICIPIO) bootstraps(100) seed(12345)
		
		* Sidak
		global g_MW: di %4.3f `= r(table)[1,6]'
		global g_NW1: di %4.3f `= r(table)[2,6]'
		global g_NW2: di %4.3f `= r(table)[3,6]'
		global g_NW3: di %4.3f `= r(table)[4,6]'
		global g_CH: di %4.3f `= r(table)[5,6]'
		global g_CU: di %4.3f `= r(table)[6,6]'
		
	* Men
	qui wyoung $ceros, cmd(tobit OUTCOMEVAR conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if SEXO==0, vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time) cluster(MUNICIPIO) bootstraps(100) seed(12345)
		
		* Sidak
		global h_MW: di %4.3f `= r(table)[1,6]'
		global h_NW1: di %4.3f `= r(table)[2,6]'
		global h_NW2: di %4.3f `= r(table)[3,6]'
		global h_NW3: di %4.3f `= r(table)[4,6]'
		global h_CH: di %4.3f `= r(table)[5,6]'
		global h_CU: di %4.3f `= r(table)[6,6]'

**************************************
*** Regressions - Extensive *** 
**************************************

	foreach i in $out {
		
***** Women
	
		reg `i'd CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1, vce(cluster MUNICIPIO)
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
		
***** Men
	
		reg `i'd CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0, vce(cluster MUNICIPIO)
		local b: di %4.3f `= _b[conflict_time]'
		global seb_`i': di %4.3f `= _se[conflict_time]'
		local tb=_b[conflict_time]/_se[conflict_time]
		local pb= 2*ttail(`e(df_r)',abs(`tb'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
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

	}
	
		
**************************************
*** Regressions - Intensive OLS *** 
**************************************

	foreach i in $out {
		
***** Women

		reg `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1, vce(cluster MUNICIPIO)
		local d: di %4.3f `= _b[conflict_time]'
		global sed_`i': di %4.3f `= _se[conflict_time]'
		local td=_b[conflict_time]/_se[conflict_time]
		local pd= 2*ttail(`e(df_r)',abs(`td'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		if `pd'<=0.01 {
			global bd_`i' "`d'\sym{***}"
		}
		
		if `pd'<=0.05 & `pd'>0.01 {
			global bd_`i' "`d'\sym{**}"
		}
		
		if `pd'<=0.1 & `pd'>0.05 {
			global bd_`i' "`d'\sym{*}"
		}

		if `pd'>0.1  {
			global bd_`i' "`d'"
		}
		
***** Men
	
		reg `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0, vce(cluster MUNICIPIO)
		local e: di %4.3f `= _b[conflict_time]'
		global see_`i': di %4.3f `= _se[conflict_time]'
		local te=_b[conflict_time]/_se[conflict_time]
		local pe= 2*ttail(`e(df_r)',abs(`te'))
		global r25_`i': di %4.3f `= e(r2)'
		global N5_`i': di %9.0f `= e(N)'
		
		if `pe'<=0.01 {
			global be_`i' "`e'\sym{***}"
		}
		
		if `pe'<=0.05 & `pe'>0.01 {
			global be_`i' "`e'\sym{**}"
		}
		
		if `pe'<=0.1 & `pe'>0.05 {
			global be_`i' "`e'\sym{*}"
		}

		if `pe'>0.1  {
			global be_`i' "`e'"
		}
	
	}

**************************************
*** Regressions - Intensive Tobit *** 
**************************************

	foreach i in $out {
		
***** Women
	
		tobit `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1, vce(cluster MUNICIPIO) ll(0) ul(24)
		local g: di %4.3f `= _b[conflict_time]'
		global seg_`i': di %4.3f `= _se[conflict_time]'
		local tg=_b[conflict_time]/_se[conflict_time]
		local pg= 2*ttail(`e(df_r)',abs(`tg'))
		global r27_`i': di %4.3f `= e(r2)'
		global N7_`i': di %9.0f `= e(N)'
		
		if `pg'<=0.01 {
			global bg_`i' "`g'\sym{***}"
		}
		
		if `pg'<=0.05 & `pg'>0.01 {
			global bg_`i' "`g'\sym{**}"
		}
		
		if `pg'<=0.1 & `pg'>0.05 {
			global bg_`i' "`g'\sym{*}"
		}

		if `pg'>0.1  {
			global bg_`i' "`g'"
		}
		
***** Men
	
		tobit `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0, vce(cluster MUNICIPIO) ll(0) ul(24)
		local h: di %4.3f `= _b[conflict_time]'
		global seh_`i': di %4.3f `= _se[conflict_time]'
		local th=_b[conflict_time]/_se[conflict_time]
		local ph= 2*ttail(`e(df_r)',abs(`th'))
		global r28_`i': di %4.3f `= e(r2)'
		global N8_`i': di %9.0f `= e(N)'
		
		if `ph'<=0.01 {
			global bh_`i' "`h'\sym{***}"
		}
		
		if `ph'<=0.05 & `ph'>0.01 {
			global bh_`i' "`h'\sym{**}"
		}
		
		if `ph'<=0.1 & `ph'>0.05 {
			global bh_`i' "`h'\sym{*}"
		}

		if `ph'>0.1  {
			global bh_`i' "`h'"
		}
	
	}
	
**************************************
*** Latex table *** 
**************************************

	file open latex using "${output}/reg_he_gender.txt", write replace text
	file write latex "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
	file write latex "\begin{tabular}{l c c c c c} \\ \hline \hline" _n
	file write latex "& \multicolumn{2}{c}{ \textbf{Extensive margin}} && \multicolumn{2}{c}{ \textbf{Intensive margin}} \\" _n
	file write latex "& \multicolumn{2}{c}{\textit{OLS}} && \multicolumn{2}{c}{\textit{Tobit/OLS}} \\ \cline{2-3} \cline{5-6} " _n
	file write latex " & Females & Males && Females & Males \\" _n
	file write latex "& (1) & (2) && (3) & (4) \\ \hline" _n
		
	foreach i in $out {
		
		local lab: variable label `i'c

		* Sleep | Leisure and self care
		if "`i'" == "NW1" | "`i'" == "NW2" {

			file write latex " \textbf{`lab'} & & && ${bd_`i'} & ${be_`i'}  \\" _n
			file write latex " & & && (${sed_`i'}) & (${see_`i'})  \\" _n
			file write latex " & & && [${d_`i'}] & [${e_`i'} \\" _n
			file write latex "\\" _n

			file write latex " R^2 & & && ${r24_`i'} & ${r25_`i'} \\" _n
		}

		* Others
		else {
			
			file write latex " \textbf{`lab'} & ${ba_`i'} & ${bb_`i'} && ${bg_`i'} & ${bh_`i'} \\" _n
			file write latex " & (${sea_`i'}) & (${seb_`i'}) && (${seg_`i'}) & (${seh_`i'}) \\" _n
			file write latex " & [${a_`i'}]& [${b_`i'}] && \{${g_`i'}\} & \{${h_`i'}\} \\" _n
			file write latex "\\" _n

			file write latex " R^2 & ${r2_`i'} & ${r22_`i'} && ${r27_`i'} & ${r28_`i'} \\" _n
		}

		file write latex "\hline" _n
	}
		
	file write latex " Observations & ${N_MW} & ${N2_MW} && ${N4_MW} & ${N5_MW} \\" _n
	file write latex "Year FE  & $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$  \\" _n	
	file write latex "Municipality FE & $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$ \\" _n		
	file write latex "Controls & $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$ \\" _n		
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
	