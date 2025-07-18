/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
7_3_heter_eff_edu.do

This do file runs regression with heterogeneous effects - HH Education
=========================================================================*/

	use "${enut}/ENUT_FARC_J.dta", clear // clave

	foreach i in v4 v20 {
		gen `i'_c=`i'*TIME
	}
	
**************************************
*** Mean and SD per group *** 
**************************************

	file open latex using "${sale}/m_sd_he_edu.txt", write replace text
	file write latex "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
	file write latex "\begin{tabular}{l c c c c c c c c c c c} \\ \hline \hline" _n
	
	file write latex "& \multicolumn{5}{c}{\textbf{Extensive margin}} && \multicolumn{5}{c}{\textbf{Intensive margin}} \\" _n
	file write latex "& \multicolumn{2}{c}{\textit{Treatment}} && \multicolumn{2}{c}{\textit{Control}} && \multicolumn{2}{c}{\textit{Treatment}} && \multicolumn{2}{c}{\textit{Control}} \\ \cline{2-3} \cline{5-6} \cline{8-9} \cline{11-12} " _n
	file write latex "& Mean & Std. Dev. && Mean & Std. Dev. && Mean & Std. Dev. && Mean & Std. Dev. \\ " _n
	file write latex "& (1) & (2) && (3) & (4) && (5) & (6) && (7) & (8) \\ \hline" _n

	* Education
	foreach i in $out {
		
		foreach a of numlist 0/1 {
			
			forvalues n = 1/4 {			
			
				sum `i'd if TIME==0 & CONFLICT==`a' & EDU==`n', d 
				global m`n'_d`a'_`i': di %10.2f `= r(mean)'
				global sd`n'_d`a'_`i': di %10.2f `= r(sd)'
				
				sum `i'c if TIME==0 & CONFLICT==`a' & EDU==`n', d 
				global m`n'_c`a'_`i': di %10.2f `= r(mean)'
				global sd`n'_c`a'_`i': di %10.2f `= r(sd)'
				
			}
		}
		
		local lab: variable label `i'
		
		file write latex " `lab' \\" _n
		file write latex "\hspace{3mm} No education & ${m1_d1_`i'} & ${sd1_d1_`i'} && ${m1_d0_`i'} & ${sd1_d0_`i'} && ${m1_c1_`i'} & ${sd1_c1_`i'} && ${m1_c0_`i'} & ${sd1_c0_`i'} \\" _n
		file write latex "\hspace{3mm} Preschool/Elementary & ${m2_d1_`i'} & ${sd2_d1_`i'} && ${m2_d0_`i'} & ${sd2_d0_`i'} && ${m2_c1_`i'} & ${sd2_c1_`i'} && ${m2_c0_`i'} & ${sd2_c0_`i'} \\" _n
		file write latex "\hspace{3mm} Middle/High school & ${m3_d1_`i'} & ${sd3_d1_`i'} && ${m3_d0_`i'} & ${sd3_d0_`i'} && ${m3_c1_`i'} & ${sd3_c1_`i'} && ${m3_c0_`i'} & ${sd3_c0_`i'} \\" _n
		file write latex "\hspace{3mm} Under/Postgraduate & ${m4_d1_`i'} & ${sd4_d1_`i'} && ${m4_d0_`i'} & ${sd4_d0_`i'} && ${m4_c1_`i'} & ${sd4_c1_`i'} && ${m4_c0_`i'} & ${sd4_c0_`i'} \\" _n
		file write latex "\\" _n

	}
	
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex

**************************************
*** Multiple hypothesis correction *** 
**************************************

***** Extensive

	* Education 1
	qui rwolf2 (reg MWd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if EDU==1, cluster(MUNICIPIO)) ///
	(reg NW1d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==1, cluster(MUNICIPIO)) ///
	(reg NW2d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==1, cluster(MUNICIPIO)) ///
	(reg NW3d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==1, cluster(MUNICIPIO)) ///
	(reg CHd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==1, cluster(MUNICIPIO)) ///
	(reg CUd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==1, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global a_MW: di %4.3f `= e(RW)[1,3]'
		global a_NW1: di %4.3f `= e(RW)[2,3]'
		global a_NW2: di %4.3f `= e(RW)[3,3]'
		global a_NW3: di %4.3f `= e(RW)[4,3]'
		global a_CH: di %4.3f `= e(RW)[5,3]'
		global a_CU: di %4.3f `= e(RW)[6,3]'
		
	* Education 2
	qui rwolf2 (reg MWd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if EDU==2, cluster(MUNICIPIO)) ///
	(reg NW1d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==2, cluster(MUNICIPIO)) ///
	(reg NW2d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==2, cluster(MUNICIPIO)) ///
	(reg NW3d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==2, cluster(MUNICIPIO)) ///
	(reg CHd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==2, cluster(MUNICIPIO)) ///
	(reg CUd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==2, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global b_MW: di %4.3f `= e(RW)[1,3]'
		global b_NW1: di %4.3f `= e(RW)[2,3]'
		global b_NW2: di %4.3f `= e(RW)[3,3]'
		global b_NW3: di %4.3f `= e(RW)[4,3]'
		global b_CH: di %4.3f `= e(RW)[5,3]'
		global b_CU: di %4.3f `= e(RW)[6,3]'
		
	* Education 3
	qui rwolf2 (reg MWd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if EDU==3, cluster(MUNICIPIO)) ///
	(reg NW1d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==3, cluster(MUNICIPIO)) ///
	(reg NW2d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==3, cluster(MUNICIPIO)) ///
	(reg NW3d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==3, cluster(MUNICIPIO)) ///
	(reg CHd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==3, cluster(MUNICIPIO)) ///
	(reg CUd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==3, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
			
		global c_MW: di %4.3f `= e(RW)[1,3]'
		global c_NW1: di %4.3f `= e(RW)[2,3]'
		global c_NW2: di %4.3f `= e(RW)[3,3]'
		global c_NW3: di %4.3f `= e(RW)[4,3]'
		global c_CH: di %4.3f `= e(RW)[5,3]'
		global c_CU: di %4.3f `= e(RW)[6,3]'
		
	* Education 4
	qui rwolf2 (reg MWd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if EDU==4, cluster(MUNICIPIO)) ///
	(reg NW1d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==4, cluster(MUNICIPIO)) ///
	(reg NW2d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==4, cluster(MUNICIPIO)) ///
	(reg NW3d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==4, cluster(MUNICIPIO)) ///
	(reg CHd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==4, cluster(MUNICIPIO)) ///
	(reg CUd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==4, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
			
		global k_MW: di %4.3f `= e(RW)[1,3]'
		global k_NW1: di %4.3f `= e(RW)[2,3]'
		global k_NW2: di %4.3f `= e(RW)[3,3]'
		global k_NW3: di %4.3f `= e(RW)[4,3]'
		global k_CH: di %4.3f `= e(RW)[5,3]'
		global k_CU: di %4.3f `= e(RW)[6,3]'

***** Intensive - OLS	
	
	* Education 1
	qui rwolf2 (reg MWc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if EDU==1, cluster(MUNICIPIO)) ///
	(reg NW1c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==1, cluster(MUNICIPIO)) ///
	(reg NW2c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==1, cluster(MUNICIPIO)) ///
	(reg NW3c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==1, cluster(MUNICIPIO)) ///
	(reg CHc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==1, cluster(MUNICIPIO)) ///
	(reg CUc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==1, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global d_MW: di %4.3f `= e(RW)[1,3]'
		global d_NW1: di %4.3f `= e(RW)[2,3]'
		global d_NW2: di %4.3f `= e(RW)[3,3]'
		global d_NW3: di %4.3f `= e(RW)[4,3]'
		global d_CH: di %4.3f `= e(RW)[5,3]'
		global d_CU: di %4.3f `= e(RW)[6,3]'
			
	* Education 2
	qui rwolf2 (reg MWc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if EDU==2, cluster(MUNICIPIO)) ///
	(reg NW1c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==2, cluster(MUNICIPIO)) ///
	(reg NW2c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==2, cluster(MUNICIPIO)) ///
	(reg NW3c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==2, cluster(MUNICIPIO)) ///
	(reg CHc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==2, cluster(MUNICIPIO)) ///
	(reg CUc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==2, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global e_MW: di %4.3f `= e(RW)[1,3]'
		global e_NW1: di %4.3f `= e(RW)[2,3]'
		global e_NW2: di %4.3f `= e(RW)[3,3]'
		global e_NW3: di %4.3f `= e(RW)[4,3]'
		global e_CH: di %4.3f `= e(RW)[5,3]'
		global e_CU: di %4.3f `= e(RW)[6,3]'	
		
	* Education 3
	qui rwolf2 (reg MWc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if EDU==3, cluster(MUNICIPIO)) ///
	(reg NW1c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==3, cluster(MUNICIPIO)) ///
	(reg NW2c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==3, cluster(MUNICIPIO)) ///
	(reg NW3c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==3, cluster(MUNICIPIO)) ///
	(reg CHc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==3, cluster(MUNICIPIO)) ///
	(reg CUc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==3, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
			
		global f_MW: di %4.3f `= e(RW)[1,3]'
		global f_NW1: di %4.3f `= e(RW)[2,3]'
		global f_NW2: di %4.3f `= e(RW)[3,3]'
		global f_NW3: di %4.3f `= e(RW)[4,3]'
		global f_CH: di %4.3f `= e(RW)[5,3]'
		global f_CU: di %4.3f `= e(RW)[6,3]'
		
	* Education 4
	qui rwolf2 (reg MWc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if EDU==4, cluster(MUNICIPIO)) ///
	(reg NW1c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==4, cluster(MUNICIPIO)) ///
	(reg NW2c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==4, cluster(MUNICIPIO)) ///
	(reg NW3c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==4, cluster(MUNICIPIO)) ///
	(reg CHc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==4, cluster(MUNICIPIO)) ///
	(reg CUc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if EDU==4, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
			
		global l_MW: di %4.3f `= e(RW)[1,3]'
		global l_NW1: di %4.3f `= e(RW)[2,3]'
		global l_NW2: di %4.3f `= e(RW)[3,3]'
		global l_NW3: di %4.3f `= e(RW)[4,3]'
		global l_CH: di %4.3f `= e(RW)[5,3]'
		global l_CU: di %4.3f `= e(RW)[6,3]'
		
***** Intesive - Tobit
	
	* Education 1
	qui wyoung $ceros, cmd(tobit OUTCOMEVAR conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if EDU==1, vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time) cluster(MUNICIPIO) bootstraps(100) seed(12345)
		
		* Sidak
		global g_MW: di %4.3f `= r(table)[1,6]'
		global g_NW1: di %4.3f `= r(table)[2,6]'
		global g_NW2: di %4.3f `= r(table)[3,6]'
		global g_NW3: di %4.3f `= r(table)[4,6]'
		global g_CH: di %4.3f `= r(table)[5,6]'
		global g_CU: di %4.3f `= r(table)[6,6]'
		
	* Education 2
	qui wyoung $ceros, cmd(tobit OUTCOMEVAR conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if EDU==2, vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time) cluster(MUNICIPIO) bootstraps(100) seed(12345)
		
		* Sidak
		global h_MW: di %4.3f `= r(table)[1,6]'
		global h_NW1: di %4.3f `= r(table)[2,6]'
		global h_NW2: di %4.3f `= r(table)[3,6]'
		global h_NW3: di %4.3f `= r(table)[4,6]'
		global h_CH: di %4.3f `= r(table)[5,6]'
		global h_CU: di %4.3f `= r(table)[6,6]'
		
	* Education 3
	qui wyoung $ceros, cmd(tobit OUTCOMEVAR conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if EDU==3, vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time) cluster(MUNICIPIO) bootstraps(100) seed(12345)
		
		* Sidak
		global j_MW: di %4.3f `= r(table)[1,6]'
		global j_NW1: di %4.3f `= r(table)[2,6]'
		global j_NW2: di %4.3f `= r(table)[3,6]'
		global j_NW3: di %4.3f `= r(table)[4,6]'
		global j_CH: di %4.3f `= r(table)[5,6]'
		global j_CU: di %4.3f `= r(table)[6,6]'	
		
	* Education 4
	qui wyoung $ceros, cmd(tobit OUTCOMEVAR conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if EDU==4, vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time) cluster(MUNICIPIO) bootstraps(100) seed(12345)
		
		* Sidak
		global m_MW: di %4.3f `= r(table)[1,6]'
		global m_NW1: di %4.3f `= r(table)[2,6]'
		global m_NW2: di %4.3f `= r(table)[3,6]'
		global m_NW3: di %4.3f `= r(table)[4,6]'
		global m_CH: di %4.3f `= r(table)[5,6]'
		global m_CU: di %4.3f `= r(table)[6,6]'	

**************************************
*** Regressions - Extensive *** 
**************************************

	foreach i in $out {
		
***** Education 1
	
		reg `i'd CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==1, vce(cluster MUNICIPIO)
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
		
***** Education 2
	
		reg `i'd CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==2, vce(cluster MUNICIPIO)
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
		
***** Education 3
	
		reg `i'd CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==3, vce(cluster MUNICIPIO)
		local c: di %4.3f `= _b[conflict_time]'
		global sec_`i': di %4.3f `= _se[conflict_time]'
		local tc=_b[conflict_time]/_se[conflict_time]
		local pc= 2*ttail(`e(df_r)',abs(`tc'))
		global r23_`i': di %4.3f `= e(r2)'
		global N3_`i': di %9.0f `= e(N)'
		
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
		
***** Education 4
	
		reg `i'd CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==4, vce(cluster MUNICIPIO)
		local k: di %4.3f `= _b[conflict_time]'
		global sek_`i': di %4.3f `= _se[conflict_time]'
		local tk=_b[conflict_time]/_se[conflict_time]
		local pk= 2*ttail(`e(df_r)',abs(`tk'))
		global r210_`i': di %4.3f `= e(r2)'
		global N10_`i': di %9.0f `= e(N)'
		
		if `pk'<=0.01 {
			global bk_`i' "`k'\sym{***}"
		}
		
		if `pk'<=0.05 & `pk'>0.01 {
			global bk_`i' "`k'\sym{**}"
		}
		
		if `pk'<=0.1 & `pk'>0.05 {
			global bk_`i' "`k'\sym{*}"
		}

		if `pk'>0.1  {
			global bk_`i' "`k'"
		}

	}
	
		
**************************************
*** Regressions - Intensive OLS *** 
**************************************

	foreach i in $out {
		
***** Education 1

		reg `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==1, vce(cluster MUNICIPIO)
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
		
***** Education 2
	
		reg `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==2, vce(cluster MUNICIPIO)
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
		
***** Education 3
	
		reg `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==3, vce(cluster MUNICIPIO)
		local f: di %4.3f `= _b[conflict_time]'
		global sef_`i': di %4.3f `= _se[conflict_time]'
		local tf=_b[conflict_time]/_se[conflict_time]
		local pf= 2*ttail(`e(df_r)',abs(`tf'))
		global r26_`i': di %4.3f `= e(r2)'
		global N6_`i': di %9.0f `= e(N)'
		
		if `pf'<=0.01 {
			global bf_`i' "`f'\sym{***}"
		}
		
		if `pf'<=0.05 & `pf'>0.01 {
			global bf_`i' "`f'\sym{**}"
		}
		
		if `pf'<=0.1 & `pf'>0.05 {
			global bf_`i' "`f'\sym{*}"
		}

		if `pf'>0.1  {
			global bf_`i' "`f'"
		}
		
***** Education 4
	
		reg `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==4, vce(cluster MUNICIPIO)
		local l: di %4.3f `= _b[conflict_time]'
		global sel_`i': di %4.3f `= _se[conflict_time]'
		local tl=_b[conflict_time]/_se[conflict_time]
		local pl= 2*ttail(`e(df_r)',abs(`tl'))
		global r211_`i': di %4.3f `= e(r2)'
		global N11_`i': di %9.0f `= e(N)'
		
		if `pl'<=0.01 {
			global bl_`i' "`l'\sym{***}"
		}
		
		if `pl'<=0.05 & `pl'>0.01 {
			global bl_`i' "`l'\sym{**}"
		}
		
		if `pl'<=0.1 & `pl'>0.05 {
			global bl_`i' "`l'\sym{*}"
		}

		if `pl'>0.1  {
			global bl_`i' "`l'"
		}
	
	}

**************************************
*** Regressions - Intensive Tobit *** 
**************************************

	foreach i in $out {
		
***** Education 1
	
		tobit `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==1, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
***** Education 2
	
		tobit `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==2, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
***** Education 3
	
		tobit `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==3, vce(cluster MUNICIPIO) ll(0) ul(24)
		local j: di %4.3f `= _b[conflict_time]'
		global sej_`i': di %4.3f `= _se[conflict_time]'
		local tj=_b[conflict_time]/_se[conflict_time]
		local pj= 2*ttail(`e(df_r)',abs(`tj'))
		global r29_`i': di %4.3f `= e(r2)'
		global N9_`i': di %9.0f `= e(N)'
		
		if `pj'<=0.01 {
			global bj_`i' "`j'\sym{***}"
		}
		
		if `pj'<=0.05 & `pj'>0.01 {
			global bj_`i' "`j'\sym{**}"
		}
		
		if `pj'<=0.1 & `pj'>0.05 {
			global bj_`i' "`j'\sym{*}"
		}

		if `pj'>0.1  {
			global bj_`i' "`j'"
		}
	
***** Education 4
	
		tobit `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==4, vce(cluster MUNICIPIO) ll(0) ul(24)
		local m: di %4.3f `= _b[conflict_time]'
		global sem_`i': di %4.3f `= _se[conflict_time]'
		local tm=_b[conflict_time]/_se[conflict_time]
		local pm= 2*ttail(`e(df_r)',abs(`tm'))
		global r212_`i': di %4.3f `= e(r2)'
		global N12_`i': di %9.0f `= e(N)'
		
		if `pm'<=0.01 {
			global bm_`i' "`m'\sym{***}"
		}
		
		if `pm'<=0.05 & `pm'>0.01 {
			global bm_`i' "`m'\sym{**}"
		}
		
		if `pm'<=0.1 & `pm'>0.05 {
			global bm_`i' "`m'\sym{*}"
		}

		if `pm'>0.1  {
			global bm_`i' "`m'"
		}
		
	}
	
**************************************
*** Latex table *** 
**************************************

	file open latex using "${sale}/reg_he_edu.txt", write replace text
	file write latex "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
	file write latex "\begin{tabular}{l C{1.5cm} C{2cm} C{2cm} C{2.5cm} c C{1.5cm} C{2cm} C{2cm} C{2.5cm}} \\ \hline \hline" _n
	file write latex "& \multicolumn{4}{c}{ \textbf{Extensive margin}} && \multicolumn{4}{c}{ \textbf{Intensive margin}} \\" _n
	file write latex "& \multicolumn{4}{c}{\textit{OLS}} && \multicolumn{4}{c}{\textit{Tobit/OLS}} \\ \cline{2-5} \cline{7-10} " _n
	file write latex "& No education & Preschool/ Elementary & Middle/ High school & Under/ Postgraduate && No education & Preschool/ Elementary & Middle/ High school & Under/ Postgraduate \\" _n
	file write latex "& (1) & (2) & (3) & (4) && (5) & (6) & (7) & (8) \\ \hline" _n
		
	foreach i in $out {
		
		local lab: variable label `i'c

		* Sleep | Leisure and self care
		if "`i'" == "NW1" | "`i'" == "NW2" {

			file write latex " \textbf{`lab'} & & & & && ${bd_`i'} & ${be_`i'} & ${bf_`i'} & ${bl_`i'}  \\" _n
			file write latex " & & && && (${sed_`i'}) & (${see_`i'}) & (${sef_`i'}) & (${sel_`i'})  \\" _n
			file write latex " & & && && [${d_`i'}] & [${e_`i'}] & [${f_`i'}] & [${l_`i'}] \\" _n
			file write latex "\\" _n

			file write latex " R^2 & & & & && ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r211_`i'} \\" _n
		}

		* Others
		else {
			
			file write latex " \textbf{`lab'} & ${ba_`i'} & ${bb_`i'} & ${bc_`i'} & ${bk_`i'} && ${bg_`i'} & ${bh_`i'} & ${bj_`i'} & ${bm_`i'} \\" _n
			file write latex " & (${sea_`i'}) & (${seb_`i'}) & (${sec_`i'}) & (${sek_`i'}) && (${seg_`i'}) & (${seh_`i'}) & (${sej_`i'}) & (${sem_`i'}) \\" _n
			file write latex " & [${a_`i'}]& [${b_`i'}] & [${c_`i'}] & [${k_`i'}] && \{${g_`i'}\} & \{${h_`i'}\} & \{${j_`i'}\} & \{${m_`i'}\} \\" _n
			file write latex "\\" _n

			file write latex " R^2 & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r210_`i'} && ${r27_`i'} & ${r28_`i'} & ${r29_`i'} & ${r212_`i'} \\" _n
		}

		file write latex "\hline" _n
	}
		
	file write latex " Observations & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N10_MW} && ${N4_MW} & ${N5_MW} & ${N6_MW} & ${N11_MW} \\" _n
	file write latex "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
	file write latex "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$  \\" _n		
	file write latex "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
	