/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
6_regs_main.do

This do file runs the main regressions + controls
=========================================================================*/

	use "${enut}/ENUT_FARC_J.dta", clear // clave

	foreach i in v4 v20 {
		gen `i'_c=`i'*TIME
	}
	
* =====================================================================
* Main regression (EF Municipio y EF Año)

	* v1 - Intensive OLS
	* v2 - Intensive Tobit
	* v3 - Extensive Dummys
* =====================================================================

*******************************************
*** Multiple hypothesis correction  *** 
*******************************************

	* v1 - Intensive OLS (Rwolf)
	qui rwolf2 (reg MWc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls, cluster(MUNICIPIO)) ///
	(reg NW1c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW2c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW3c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CHc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CUc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global rw1_MW: di %4.3f `= e(RW)[1,3]'
		global rw1_NW1: di %4.3f `= e(RW)[2,3]'
		global rw1_NW2: di %4.3f `= e(RW)[3,3]'
		global rw1_NW3: di %4.3f `= e(RW)[4,3]'
		global rw1_CH: di %4.3f `= e(RW)[5,3]'
		global rw1_CU: di %4.3f `= e(RW)[6,3]'

	* v1 - Intensive OLS (Rwolf) - year interaction
	qui rwolf2 (reg MWc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO $controls, cluster(MUNICIPIO)) ///
	(reg NW1c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW2c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW3c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CHc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CUc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)), ///
	indepvars(conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020) reps(1000) seed(12345)

		* 2016
		global rw2_MW: di %4.3f `= e(RW)[1,3]'
		global rw2_NW1: di %4.3f `= e(RW)[3,3]'
		global rw2_NW2: di %4.3f `= e(RW)[5,3]'
		global rw2_NW3: di %4.3f `= e(RW)[7,3]'
		global rw2_CH: di %4.3f `= e(RW)[9,3]'
		global rw2_CU: di %4.3f `=  e(RW)[11,3]'

		* 2020
		global rw3_MW: di %4.3f `= e(RW)[2,3]'
		global rw3_NW1: di %4.3f `= e(RW)[4,3]'
		global rw3_NW2: di %4.3f `= e(RW)[6,3]'
		global rw3_NW3: di %4.3f `= e(RW)[8,3]'
		global rw3_CH: di %4.3f `= e(RW)[10,3]'
		global rw3_CU: di %4.3f `= e(RW)[12,3]'

	* v2 - Intensive Tobit (Sidak)
	qui wyoung $ceros, cmd(tobit OUTCOMEVAR conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time) cluster(MUNICIPIO) bootstraps(100) seed(12345)
		
		* Sidak
		global rw4_MW_s: di %4.3f `= r(table)[1,6]'
		global rw4_NW1_s: di %4.3f `= r(table)[2,6]'
		global rw4_NW2_s: di %4.3f `= r(table)[3,6]'
		global rw4_NW3_s: di %4.3f `= r(table)[4,6]'
		global rw4_CH_s: di %4.3f `= r(table)[5,6]'
		global rw4_CU_s: di %4.3f `= r(table)[6,6]'

	* v2 - Intensive Tobit (Sidak) - year interaction
	qui wyoung $ceros, cmd(tobit OUTCOMEVAR conflict_time2016 conflict_time2020 CONFLICT TIME2016 TIME2020 i.ANNO i.MUNICIPIO $controls, vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time2016 conflict_time2020) cluster(MUNICIPIO) bootstraps(100) seed(12345)
	
		* Sidak

			* 2016
			global rw5_MW_s: di %4.3f `= r(table)[1,6]'
			global rw5_NW1_s: di %4.3f `= r(table)[2,6]'
			global rw5_NW2_s: di %4.3f `= r(table)[3,6]'
			global rw5_NW3_s: di %4.3f `= r(table)[4,6]'
			global rw5_CH_s: di %4.3f `= r(table)[5,6]'
			global rw5_CU_s: di %4.3f `=  r(table)[6,6]'

			* 2020
			global rw6_MW_s: di %4.3f `= r(table)[7,6]'
			global rw6_NW1_s: di %4.3f `= r(table)[8,6]'
			global rw6_NW2_s: di %4.3f `= r(table)[9,6]'
			global rw6_NW3_s: di %4.3f `= r(table)[10,6]'
			global rw6_CH_s: di %4.3f `= r(table)[11,6]'
			global rw6_CU_s: di %4.3f `= r(table)[12,6]'
			
	* v3 - Extensive Dummys (Rwolf)
	qui rwolf2 (reg MWd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls, cluster(MUNICIPIO)) ///
	(reg NW1d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW2d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW3d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CHd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CUd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
	
		global rw7_MW: di %4.3f `= e(RW)[1,3]'
		global rw7_NW1: di %4.3f `= e(RW)[2,3]'
		global rw7_NW2: di %4.3f `= e(RW)[3,3]'
		global rw7_NW3: di %4.3f `= e(RW)[4,3]'
		global rw7_CH: di %4.3f `= e(RW)[5,3]'
		global rw7_CU: di %4.3f `= e(RW)[6,3]'
		
	* v3 - Extensive Dummys (Rwolf) - year interaction
	qui rwolf2 (reg MWd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO $controls, cluster(MUNICIPIO)) ///
	(reg NW1d TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW2d TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW3d TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CHd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CUd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)), ///
	indepvars(conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020) reps(1000) seed(12345)
	
		* 2016
		global rw8_MW: di %4.3f `= e(RW)[1,3]'
		global rw8_NW1: di %4.3f `= e(RW)[3,3]'
		global rw8_NW2: di %4.3f `= e(RW)[5,3]'
		global rw8_NW3: di %4.3f `= e(RW)[7,3]'
		global rw8_CH: di %4.3f `= e(RW)[9,3]'
		global rw8_CU: di %4.3f `=  e(RW)[11,3]'

		* 2020
		global rw9_MW: di %4.3f `= e(RW)[2,3]'
		global rw9_NW1: di %4.3f `= e(RW)[4,3]'
		global rw9_NW2: di %4.3f `= e(RW)[6,3]'
		global rw9_NW3: di %4.3f `= e(RW)[8,3]'
		global rw9_CH: di %4.3f `= e(RW)[10,3]'
		global rw9_CU: di %4.3f `= e(RW)[12,3]'

*******************************************
*** Regressions  *** 
*******************************************

	file open latex using "${sale}/reg1c.txt", write replace text // graf
	file write latex "\begin{tabular}{l c c c c c c c c} \\ \hline \hline" _n
	file write latex "& \multicolumn{2}{c}{\textbf{Extensive margin}} && \multicolumn{5}{c}{\textbf{Intensive margin}} \\ " _n
	file write latex " & \multicolumn{2}{c}{\textit{OLS}} && \multicolumn{2}{c}{\textit{OLS}} && \multicolumn{2}{c}{\textit{Tobit}} \\ \cline{2-3} \cline{5-6} \cline{8-9}" _n
	file write latex "& All & By year && All & By year && All & By year \\" _n	
	file write latex "& (1) & (2) && (3) & (4) && (5) & (6) \\ \hline" _n

		foreach i in $out {
					
			* v1 - Intensive OLS
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
			
			* v1 - Intensive OLS - year interaction
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
			
			* v2 - Intensive Tobit
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
			
			* v2 - Intensive Tobit - year interaction
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
			
			* v3 - Extensive Dummy
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
			
			* v3 - Extensive Dummy - year interaction
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
		
		
	file write latex "\textbf{`lab'} \\" _n
	file write latex " Conflict x Time & ${bc_`i'} &&& ${ba_`i'} &&& ${bb_`i'} &\\" _n
	file write latex "  & (${sec_`i'}) &&& (${sea_`i'}) &&& (${seb_`i'}) & \\" _n
	file write latex "  & [${rw7_`i'}] &&& [${rw1_`i'}] &&& \{${rw4_`i'_s}\} & \\" _n

	file write latex " Conflict x 2016 && ${bj_`i'} &&& ${be_`i'} &&& ${bg_`i'} \\" _n
	file write latex " && (${sej_`i'}) &&& (${see_`i'}) &&& (${seg_`i'})  \\" _n
	file write latex " && [${rw8_`i'}] &&& [${rw2_`i'}] &&& \{${rw5_`i'_s}\} \\" _n

	file write latex " Conflict x 2020 && ${bk_`i'} &&& ${bf_`i'} &&& ${bh_`i'}  \\" _n
	file write latex " && (${sek_`i'}) &&& (${sef_`i'}) &&& (${seh_`i'})  \\" _n
	file write latex " && [${rw9_`i'}] &&& [${rw3_`i'}] &&& \{${rw6_`i'_s}\} \\" _n

	file write latex " R-squared & ${r25_`i'} & ${r26_`i'} && ${r2_`i'} & ${r22_`i'} && ${r23_`i'} & ${r24_`i'}   \\" _n

	file write latex "\hline" _n
		}	
	file write latex " Observations & ${N5_MW} & ${N6_MW} && ${N_MW} & ${N2_MW} && ${N3_MW} & ${N4_MW} \\" _n
	file write latex "Year FE & $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$  && $\checkmark$ & $\checkmark$  \\" _n	
	file write latex "Municipality FE & $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$  \\" _n
	file write latex "Controls & $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$  \\" _n			
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex

