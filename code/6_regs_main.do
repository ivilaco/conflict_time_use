/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
6_regs_main.do

This do file cruns the main regressions + controls
=========================================================================*/

	use "${enut}/ENUT_FARC_J.dta", clear
	
******************* TESTS
	
	* v2 - Básica (Tobit)
	rwolf $ceros, indepvar(conflict_time) method(tobit) controls(CONFLICT TIME i.ANNO i.MUNICIPIO $controls) vce(cluster MUNICIPIO) reps(3000) ll(0) ul(24)

	* v3 - Interacción por año (Dummy)
	rwolf2 (reg MWd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO $controls, cluster(MUNICIPIO)) ///
	(reg NW1d TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW2d TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW3d TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CHd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CUd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)), ///
	indepvars(conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020) reps(3000)

******************* TESTS

	foreach i in v4 v20 {
		gen `i'_c=`i'*TIME
	}
	
* ----------------------------------------------------------------------
* VI.1 Regresion principal (EF Municipio y EF Año)

	* v1 - Básica
	* v2 - Tobit
	* v3 - Dummys

* ----------------------------------------------------------------------

	file open latex1 using "${sale}/reg1c.txt", write replace text
	file write latex1 "\begin{tabular}{l c c c c c c} \\ \hline \hline" _n
	file write latex1 "& \multicolumn{2}{c}{Extensive margin} & \multicolumn{4}{c}{Intensive margin} \\ \cline{2-7}" _n
	file write latex1 " & \multicolumn{2}{c}{Dummy} & \multicolumn{2}{c}{OLS} & \multicolumn{2}{c}{Tobit} \\" _n
	file write latex1 "& (1) & (2) & (3) & (4) & (5) & (6) \\ \hline" _n

	* v1 - Básica (OLS) Modelo 1
	rwolf2 (reg MWc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls, cluster(MUNICIPIO)) ///
	(reg NW1c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW2c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW3c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CHc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CUc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(3000)
		
		scalar rw1_MW = e(RW)[3,1]
		scalar rw1_NW1 = e(RW)[3,2] 
		scalar rw1_NW2 = e(RW)[3,3]   
		scalar rw1_NW3 = e(RW)[3,4]   
		scalar rw1_CH = e(RW)[3,5]   
		scalar rw1_CU = e(RW)[3,6]   

		global rw1_MW = rw1_MW
		global rw1_NW1 = rw1_NW1
		global rw1_NW2 = rw1_NW2
		global rw1_NW3 = rw1_NW3
		global rw1_CH = rw1_CH
		global rw1_CU = rw1_CU	

	* v1 - Interacción por año (OLS) Modelo 2 y 3
	rwolf2 (reg MWc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO $controls, cluster(MUNICIPIO)) ///
	(reg NW1c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW2c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW3c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CHc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CUc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)), ///
	indepvars(conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020) reps(3000)

		* 2016
		scalar rw2_MW = e(RW)[3,1]
		scalar rw2_NW1 = e(RW)[3,3] 
		scalar rw2_NW2 = e(RW)[3,5]   
		scalar rw2_NW3 = e(RW)[3,7]   
		scalar rw2_CH = e(RW)[3,9]   
		scalar rw2_CU = e(RW)[3,11]   

		global rw2_MW = rw2_MW
		global rw2_NW1 = rw2_NW1
		global rw2_NW2 = rw2_NW2
		global rw2_NW3 = rw2_NW3
		global rw2_CH = rw2_CH
		global rw2_CU = rw2_CU

		* 2020
		scalar rw3_MW = e(RW)[3,2]
		scalar rw3_NW1 = e(RW)[3,4] 
		scalar rw3_NW2 = e(RW)[3,6]   
		scalar rw3_NW3 = e(RW)[3,8]   
		scalar rw3_CH = e(RW)[3,10]   
		scalar rw3_CU = e(RW)[3,12]   

		global rw3_MW = rw3_MW
		global rw3_NW1 = rw3_NW1
		global rw3_NW2 = rw3_NW2
		global rw3_NW3 = rw3_NW3
		global rw3_CH = rw3_CH
		global rw3_CU = rw3_CU
		
	* v2 - Básica (Tobit) Modelo 4		
	rwolf2 (tobit MWc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls, cluster(MUNICIPIO) ll(0) ul(24)) ///
	(tobit NW1c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO) ll(0) ul(24)) ///
	(tobit NW2c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO) ll(0) ul(24)) ///
	(tobit NW3c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO) ll(0) ul(24)) ///
	(tobit CHc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO) ll(0) ul(24)) ///
	(tobit CUc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO) ll(0) ul(24)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(3000)
	
		scalar rw4_MW = e(RW)[3,1]
		scalar rw4_NW1 = e(RW)[3,2] 
		scalar rw4_NW2 = e(RW)[3,3]   
		scalar rw4_NW3 = e(RW)[3,4]   
		scalar rw4_CH = e(RW)[3,5]   
		scalar rw4_CU = e(RW)[3,6]   

		global rw4_MW = rw4_MW
		global rw4_NW1 = rw4_NW1
		global rw4_NW2 = rw4_NW2
		global rw4_NW3 = rw4_NW3
		global rw4_CH = rw4_CH
		global rw4_CU = rw4_CU	
		
	* v2 - Interacción por año (Tobit) Modelo 5 y 6
	rwolf2 (tobit MWc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO $controls, cluster(MUNICIPIO) ll(0) ul(24)) ///
	(tobit NW1c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO) ll(0) ul(24)) ///
	(tobit NW2c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO) ll(0) ul(24)) ///
	(tobit NW3c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO) ll(0) ul(24)) ///
	(tobit CHc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO) ll(0) ul(24)) ///
	(tobit CUc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO) ll(0) ul(24)), ///
	indepvars(conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020) reps(3000)
	
		* 2016
		scalar rw5_MW = e(RW)[3,1]
		scalar rw5_NW1 = e(RW)[3,3] 
		scalar rw5_NW2 = e(RW)[3,5]   
		scalar rw5_NW3 = e(RW)[3,7]   
		scalar rw5_CH = e(RW)[3,9]   
		scalar rw5_CU = e(RW)[3,11]   

		global rw5_MW = rw5_MW
		global rw5_NW1 = rw5_NW1
		global rw5_NW2 = rw5_NW2
		global rw5_NW3 = rw5_NW3
		global rw5_CH = rw5_CH
		global rw5_CU = rw5_CU

		* 2020
		scalar rw6_MW = e(RW)[3,2]
		scalar rw6_NW1 = e(RW)[3,4] 
		scalar rw6_NW2 = e(RW)[3,6]   
		scalar rw6_NW3 = e(RW)[3,8]   
		scalar rw6_CH = e(RW)[3,10]   
		scalar rw6_CU = e(RW)[3,12]   

		global rw6_MW = rw6_MW
		global rw6_NW1 = rw6_NW1
		global rw6_NW2 = rw6_NW2
		global rw6_NW3 = rw6_NW3
		global rw6_CH = rw6_CH
		global rw6_CU = rw6_CU
		
	* v3 - Básica (Dummy) Modelo 7
	rwolf2 (reg MWd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls, cluster(MUNICIPIO)) ///
	(reg NW1d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW2d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg NW3d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CHd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)) ///
	(reg CUd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000)
	
		scalar rw7_MW = e(RW)[3,1]
		scalar rw7_NW1 = e(RW)[3,2] 
		scalar rw7_NW2 = e(RW)[3,3]   
		scalar rw7_NW3 = e(RW)[3,4]   
		scalar rw7_CH = e(RW)[3,5]   
		scalar rw7_CU = e(RW)[3,6]   

		global rw7_MW = rw7_MW
		global rw7_NW1 = rw7_NW1
		global rw7_NW2 = rw7_NW2
		global rw7_NW3 = rw7_NW3
		global rw7_CH = rw7_CH
		global rw7_CU = rw7_CU	
		
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
	file write latex1 " Conflict x Time & ${bc_`i'} && ${ba_`i'} && ${bb_`i'} &\\" _n
	file write latex1 "  & (${sec_`i'}) && (${sea_`i'}) && (${seb_`i'}) & \\" _n

	file write latex1 " Conflict x 2016 && ${bj_`i'} && ${be_`i'} && ${bg_`i'}  \\" _n
	file write latex1 " && (${sej_`i'}) && (${see_`i'}) && (${seg_`i'})  \\" _n

	file write latex1 " Conflict x 2020 && ${bk_`i'} && ${bf_`i'} && ${bh_`i'}  \\" _n
	file write latex1 " && (${sek_`i'}) && (${sef_`i'}) && (${seh_`i'})  \\" _n

	file write latex1 " R-squared & ${r25_`i'} & ${r26_`i'} & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'}   \\" _n
	file write latex1 " Pre-t. treat. mean & ${md1_`i'} & ${md1_`i'} & ${mc1_`i'} & ${mc1_`i'} & ${mc1_`i'} & ${mc1_`i'} \\" _n
	file write latex1 " Pre-t. cont. mean & ${md0_`i'} & ${md0_`i'} & ${mc0_`i'} & ${mc0_`i'} & ${mc0_`i'} & ${mc0_`i'} \\" _n

	file write latex1 "\hline" _n
		}
		
	file write latex1 " Observations & ${N5_MW} & ${N6_MW} & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N4_MW} \\" _n
	file write latex1 "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$  & $\checkmark$ & $\checkmark$  \\" _n	
	file write latex1 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$  \\" _n
	file write latex1 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$  \\" _n			
	file write latex1 "\hline \hline" _n
	file write latex1 "\end{tabular}" _n
	file close latex1

