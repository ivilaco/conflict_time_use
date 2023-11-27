/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
6_regs_main.do

This do file cruns the main regressions + controls
=========================================================================*/

	use "${enut}/ENUT_FARC.dta", clear

* ----------------------------------------------------------------------
* VI.1 Regresion principal (EF Municipio y EF Año)
* ----------------------------------------------------------------------

	file open latex1 using "${sale}/reg1c.txt", write replace text
	file write latex1 "\begin{tabular}{l c c c c c c} \\ \hline \hline" _n
	file write latex1 "& \multicolumn{2}{c}{Extensive margin} & \multicolumn{4}{c}{Intensive margin} \\ \cline{2-7}" _n
	file write latex1 " & \multicolumn{2}{c}{Dummy} & \multicolumn{2}{c}{OLS} & \multicolumn{2}{c}{Tobit} \\" _n
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
	file write latex1 " Conflict x Time & ${bc_`i'} && ${ba_`i'} && ${bb_`i'} &\\" _n
	file write latex1 "  & (${sec_`i'}) && (${sea_`i'}) && (${seb_`i'}) & \\" _n

	file write latex1 " Conflict x 2016 && ${bj_`i'} && ${be_`i'} && ${bg_`i'}  \\" _n
	file write latex1 " && (${sej_`i'}) && (${see_`i'}) && (${seg_`i'})  \\" _n

	file write latex1 " Conflict x 2020 && ${bk_`i'} && ${bf_`i'} && ${bh_`i'}  \\" _n
	file write latex1 " && (${sek_`i'}) && (${sef_`i'}) && (${seh_`i'})  \\" _n

	file write latex1 " Observations & ${N5_`i'} & ${N6_`i'} & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} \\" _n
	file write latex1 " R-squared & ${r25_`i'} & ${r26_`i'} & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'}   \\" _n
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
		
* =====================================================================
* VII. Efectos heterogeneos

	* v1 - Básica
	* v2 - Tobit
	* v3 - Dummys
* =====================================================================

*tab EDAD, m 
*tab2xl EDAD using "${sale}/tabedad1.xls", col(1) row(1) replace

	gen dummyedad=.
	replace dummyedad=0 if EDAD<19
	replace dummyedad=1 if EDAD>=19 & EDAD<=23
	replace dummyedad=2 if EDAD>23

*tab dummyedad, m 
*tab2xl dummyedad using "${sale}/tabrangos1.xls", col(1) row(1) replace

* ---------------------------------------------------------------------
* VII.1 Grupos de edad
* ---------------------------------------------------------------------
	
*********************** v1 - OLS
	
file open latex3 using "${sale}/reg2c_v1.txt", write replace text
file write latex3 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex3 "\begin{tabular}{l c c c c c c} \\ \hline \hline" _n
file write latex3 "& \multicolumn{2}{c}{14-19 years} & \multicolumn{2}{c}{20-23 years} & \multicolumn{2}{c}{24-28 years} \\" _n
file write latex3 "& (1) & (2) & (3) & (4) & (5) & (6) \\ \hline" _n

	foreach i in $ceros {
		
		*** EDAD 1
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if dummyedad==0, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if dummyedad==0, vce(cluster MUNICIPIO)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** EDAD 2
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if dummyedad==1, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if dummyedad==1, vce(cluster MUNICIPIO)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
		
		*** EDAD 3
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if dummyedad==2, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if dummyedad==2, vce(cluster MUNICIPIO)
		local u: di %4.3f `= _b[conflict_time2016]'
		global seu_`i': di %4.3f `= _se[conflict_time2016]'	
		local v: di %4.3f `= _b[conflict_time2020]'
		global sev_`i': di %4.3f `= _se[conflict_time2020]'
		local tu=_b[conflict_time2016]/_se[conflict_time2016]
		local tv=_b[conflict_time2020]/_se[conflict_time2020]
		local pu= 2*ttail(`e(df_r)',abs(`tu'))
		local pv= 2*ttail(`e(df_r)',abs(`tv'))
		global r26_`i': di %4.3f `= e(r2)'
		global N6_`i': di %9.0f `= e(N)'
		
		foreach n in u v {
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
	
		foreach n of numlist 0/2 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & dummyedad==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex3 "\textbf{`lab'} \\" _n
file write latex3 " Conflict x Time & ${ba_`i'} && ${bc_`i'} && ${be_`i'} & \\" _n
file write latex3 "  & (${sea_`i'})&& (${sec_`i'}) && (${see_`i'})& \\" _n

file write latex3 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} && ${bu_`i'} \\" _n
file write latex3 " && (${sey_`i'})&& (${sex_`i'}) && (${seu_`i'})\\" _n

file write latex3 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} && ${bv_`i'} \\" _n
file write latex3 " && (${sez_`i'})&& (${sew_`i'}) && (${sev_`i'})\\" _n

file write latex3 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} & ${N5_`i'} & ${N6_`i'} \\" _n
file write latex3 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'}  \\" _n
file write latex3 " Pre-t. treat. mean & ${m10_`i'} & ${m10_`i'} & ${m11_`i'} & ${m11_`i'} & ${m12_`i'} & ${m12_`i'}  \\" _n
file write latex3 " Pre-t. cont. mean & ${m00_`i'} & ${m00_`i'} & ${m01_`i'} & ${m01_`i'} & ${m02_`i'} & ${m02_`i'}  \\" _n

file write latex3 "\hline" _n
	}
file write latex3 "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex3 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex3 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex3 "\hline \hline" _n
file write latex3 "\end{tabular}" _n
file close latex3

*********************** v2 - Tobit

file open latex4 using "${sale}/reg2c_v2.txt", write replace text
file write latex4 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex4 "\begin{tabular}{l c c c c c c} \\ \hline \hline" _n
file write latex4 "& \multicolumn{2}{c}{14-19 years} & \multicolumn{2}{c}{20-23 years} & \multicolumn{2}{c}{24-28 years} \\" _n
file write latex4 "& (1) & (2) & (3) & (4) & (5) & (6) \\ \hline" _n

	foreach i in $ceros {
		
		*** EDAD 1
		* v2 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if dummyedad==0, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if dummyedad==0, vce(cluster MUNICIPIO) ll(0) ul(24)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** EDAD 2
		* v2 - Básica 
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if dummyedad==1, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if dummyedad==1, vce(cluster MUNICIPIO) ll(0) ul(24)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
		
		*** EDAD 3
		* v2 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if dummyedad==2, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año (OLS)
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if dummyedad==2, vce(cluster MUNICIPIO) ll(0) ul(24)
		local u: di %4.3f `= _b[conflict_time2016]'
		global seu_`i': di %4.3f `= _se[conflict_time2016]'	
		local v: di %4.3f `= _b[conflict_time2020]'
		global sev_`i': di %4.3f `= _se[conflict_time2020]'
		local tu=_b[conflict_time2016]/_se[conflict_time2016]
		local tv=_b[conflict_time2020]/_se[conflict_time2020]
		local pu= 2*ttail(`e(df_r)',abs(`tu'))
		local pv= 2*ttail(`e(df_r)',abs(`tv'))
		global r26_`i': di %4.3f `= e(r2)'
		global N6_`i': di %9.0f `= e(N)'
		
		foreach n in u v {
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
	
		foreach n of numlist 0/2 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & dummyedad==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex4 "\textbf{`lab'} \\" _n
file write latex4 " Conflict x Time & ${ba_`i'} && ${bc_`i'} && ${be_`i'} & \\" _n
file write latex4 "  & (${sea_`i'})&& (${sec_`i'}) && (${see_`i'})& \\" _n

file write latex4 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} && ${bu_`i'} \\" _n
file write latex4 " && (${sey_`i'})&& (${sex_`i'}) && (${seu_`i'})\\" _n

file write latex4 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} && ${bv_`i'} \\" _n
file write latex4 " && (${sez_`i'})&& (${sew_`i'}) && (${sev_`i'})\\" _n

file write latex4 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} & ${N5_`i'} & ${N6_`i'} \\" _n
file write latex4 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'}  \\" _n
file write latex4 " Pre-t. treat. mean & ${m10_`i'} & ${m10_`i'} & ${m11_`i'} & ${m11_`i'} & ${m12_`i'} & ${m12_`i'}  \\" _n
file write latex4 " Pre-t. cont. mean & ${m00_`i'} & ${m00_`i'} & ${m01_`i'} & ${m01_`i'} & ${m02_`i'} & ${m02_`i'}  \\" _n

file write latex4 "\hline" _n
	}
file write latex4 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex4 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex4 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex4 "\hline \hline" _n
file write latex4 "\end{tabular}" _n
file close latex4

*********************** v3 - Dummys

file open latex5 using "${sale}/reg2c_v3.txt", write replace text
file write latex5 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex5 "\begin{tabular}{l c c c c c c} \\ \hline \hline" _n
file write latex5 "& \multicolumn{2}{c}{14-19 years} & \multicolumn{2}{c}{20-23 years} & \multicolumn{2}{c}{24-28 years} \\" _n
file write latex5 "& (1) & (2) & (3) & (4) & (5) & (6) \\ \hline" _n

	foreach i in $dummys {
		
		*** EDAD 1
		* v3 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if dummyedad==0, vce(cluster MUNICIPIO)
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
		
		* v3 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if dummyedad==0, vce(cluster MUNICIPIO)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** EDAD 2
		* v3 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if dummyedad==1, vce(cluster MUNICIPIO)
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
		
		* v3 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if dummyedad==1, vce(cluster MUNICIPIO)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
		
		*** EDAD 3
		* v3 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if dummyedad==2, vce(cluster MUNICIPIO)
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
		
		* v3 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if dummyedad==2, vce(cluster MUNICIPIO)
		local u: di %4.3f `= _b[conflict_time2016]'
		global seu_`i': di %4.3f `= _se[conflict_time2016]'	
		local v: di %4.3f `= _b[conflict_time2020]'
		global sev_`i': di %4.3f `= _se[conflict_time2020]'
		local tu=_b[conflict_time2016]/_se[conflict_time2016]
		local tv=_b[conflict_time2020]/_se[conflict_time2020]
		local pu= 2*ttail(`e(df_r)',abs(`tu'))
		local pv= 2*ttail(`e(df_r)',abs(`tv'))
		global r26_`i': di %4.3f `= e(r2)'
		global N6_`i': di %9.0f `= e(N)'
		
		foreach n in u v {
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
	
		foreach n of numlist 0/2 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & dummyedad==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex5 "\textbf{`lab'} \\" _n
file write latex5 " Conflict x Time & ${ba_`i'} && ${bc_`i'} && ${be_`i'} & \\" _n
file write latex5 "  & (${sea_`i'})&& (${sec_`i'}) && (${see_`i'})& \\" _n

file write latex5 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} && ${bu_`i'} \\" _n
file write latex5 " && (${sey_`i'})&& (${sex_`i'}) && (${seu_`i'})\\" _n

file write latex5 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} && ${bv_`i'} \\" _n
file write latex5 " && (${sez_`i'})&& (${sew_`i'}) && (${sev_`i'})\\" _n

file write latex5 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} & ${N5_`i'} & ${N6_`i'} \\" _n
file write latex5 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'}  \\" _n
file write latex5 " Pre-t. treat. mean & ${m10_`i'} & ${m10_`i'} & ${m11_`i'} & ${m11_`i'} & ${m12_`i'} & ${m12_`i'}  \\" _n
file write latex5 " Pre-t. cont. mean & ${m00_`i'} & ${m00_`i'} & ${m01_`i'} & ${m01_`i'} & ${m02_`i'} & ${m02_`i'}  \\" _n

file write latex5 "\hline" _n
	}
file write latex5 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex5 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex5 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex5 "\hline \hline" _n
file write latex5 "\end{tabular}" _n
file close latex5
	
* ------------------------------------------------------
* VII.2 Genero
* ------------------------------------------------------

*********************** v1 - OLS
	
file open latex6 using "${sale}/reg3c_v1.txt", write replace text
file write latex6 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex6 "\begin{tabular}{l c c c c} \\ \hline \hline" _n
file write latex6 "& \multicolumn{2}{c}{Females} & \multicolumn{2}{c}{Males}\\" _n
file write latex6 "& (1) & (2) & (3) & (4) \\ \hline" _n

	foreach i in $ceros {
		
		*** Females
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==1, vce(cluster MUNICIPIO)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** Males
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==0, vce(cluster MUNICIPIO)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
	
		foreach n of numlist 0/1 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & SEXO==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}

	
file write latex6 "\textbf{`lab'} \\" _n
file write latex6 " Conflict x Time & ${ba_`i'} && ${bc_`i'} & \\" _n
file write latex6 "  & (${sea_`i'})&& (${sec_`i'}) & \\" _n

file write latex6 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} \\" _n
file write latex6 " && (${sey_`i'}) && (${sex_`i'}) \\" _n

file write latex6 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} \\" _n
file write latex6 " && (${sez_`i'})&& (${sew_`i'}) \\" _n

file write latex6 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} \\" _n
file write latex6 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} \\" _n
file write latex6 " Pre-t. treat. mean & ${m11_`i'} & ${m11_`i'} & ${m10_`i'} & ${m10_`i'} \\" _n
file write latex6 " Pre-t. cont. mean & ${m01_`i'} & ${m01_`i'} & ${m00_`i'} & ${m00_`i'}  \\" _n

file write latex6 "\hline" _n
	}
file write latex6 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex6 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex6 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex6 "\hline \hline" _n
file write latex6 "\end{tabular}" _n
file close latex6

*********************** v2 - Tobit

file open latex7 using "${sale}/reg3c_v2.txt", write replace text
file write latex7 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex7 "\begin{tabular}{l c c c c} \\ \hline \hline" _n
file write latex7 "& \multicolumn{2}{c}{Females} & \multicolumn{2}{c}{Males}\\" _n
file write latex7 "& (1) & (2) & (3) & (4) \\ \hline" _n

	foreach i in $ceros {
		
		*** Females
		* v2 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==1, vce(cluster MUNICIPIO) ll(0) ul(24)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** Males
		* v2 - Básica 
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==0, vce(cluster MUNICIPIO) ll(0) ul(24)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
	
		foreach n of numlist 0/1 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & SEXO==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex7 "\textbf{`lab'} \\" _n
file write latex7 " Conflict x Time & ${ba_`i'} && ${bc_`i'} & \\" _n
file write latex7 "  & (${sea_`i'})&& (${sec_`i'}) & \\" _n

file write latex7 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} \\" _n
file write latex7 " && (${sey_`i'}) && (${sex_`i'}) \\" _n

file write latex7 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} \\" _n
file write latex7 " && (${sez_`i'})&& (${sew_`i'}) \\" _n

file write latex7 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} \\" _n
file write latex7 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} \\" _n
file write latex7 " Pre-t. treat. mean & ${m11_`i'} & ${m11_`i'} & ${m10_`i'} & ${m10_`i'} \\" _n
file write latex7 " Pre-t. cont. mean & ${m01_`i'} & ${m01_`i'} & ${m00_`i'} & ${m00_`i'}  \\" _n

file write latex7 "\hline" _n
	}
file write latex7 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex7 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex7 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex7 "\hline \hline" _n
file write latex7 "\end{tabular}" _n
file close latex7

*********************** v3 - Dummys

file open latex8 using "${sale}/reg3c_v3.txt", write replace text
file write latex8 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex8 "\begin{tabular}{l c c c c} \\ \hline \hline" _n
file write latex8 "& \multicolumn{2}{c}{Females} & \multicolumn{2}{c}{Males}\\" _n
file write latex8 "& (1) & (2) & (3) & (4) \\ \hline" _n

	foreach i in $dummys {
		
		*** Females
		* v3 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1, vce(cluster MUNICIPIO)
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
		
		* v3 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==1, vce(cluster MUNICIPIO)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** Males
		* v3 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0, vce(cluster MUNICIPIO)
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
		
		* v3 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==0, vce(cluster MUNICIPIO)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
	
		foreach n of numlist 0/1 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & SEXO==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex8 "\textbf{`lab'} \\" _n
file write latex8 " Conflict x Time & ${ba_`i'} && ${bc_`i'} & \\" _n
file write latex8 "  & (${sea_`i'})&& (${sec_`i'}) & \\" _n

file write latex8 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} \\" _n
file write latex8 " && (${sey_`i'}) && (${sex_`i'}) \\" _n

file write latex8 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} \\" _n
file write latex8 " && (${sez_`i'})&& (${sew_`i'}) \\" _n

file write latex8 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} \\" _n
file write latex8 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} \\" _n
file write latex8 " Pre-t. treat. mean & ${m11_`i'} & ${m11_`i'} & ${m10_`i'} & ${m10_`i'} \\" _n
file write latex8 " Pre-t. cont. mean & ${m01_`i'} & ${m01_`i'} & ${m00_`i'} & ${m00_`i'}  \\" _n

file write latex8 "\hline" _n
	}
file write latex8 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex8 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex8 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex8 "\hline \hline" _n
file write latex8 "\end{tabular}" _n
file close latex8

/* ---------------------------------------------------------------------
* VII.2.5 Grupos de edad + género
* ---------------------------------------------------------------------
	
*********************** v1 - OLS
	
file open latex3 using "${sale}/reg4c_v1.txt", write replace text
file write latex3 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex3 "\begin{tabular}{l c c c c c c c c c c c c} \\ \hline \hline" _n
file write latex3 "& \multicolumn{6}{c}{Female} & \multicolumn{6}{c}{Male} \\ \cline{2-13}" _n
file write latex3 "& \multicolumn{2}{c}{14-19 years} & \multicolumn{2}{c}{20-23 years} & \multicolumn{2}{c}{24-28 years} & \multicolumn{2}{c}{14-19 years} & \multicolumn{2}{c}{20-23 years} & \multicolumn{2}{c}{24-28 years}  \\" _n
file write latex3 "& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) & (10) & (11) & (12) \\ \hline" _n

	foreach i in $ceros {
		
		********** MUJERES
		*** EDAD 1
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==0, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==0, vce(cluster MUNICIPIO)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** EDAD 2
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==1, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==1, vce(cluster MUNICIPIO)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
		
		*** EDAD 3
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==2, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==2, vce(cluster MUNICIPIO)
		local u: di %4.3f `= _b[conflict_time2016]'
		global seu_`i': di %4.3f `= _se[conflict_time2016]'	
		local v: di %4.3f `= _b[conflict_time2020]'
		global sev_`i': di %4.3f `= _se[conflict_time2020]'
		local tu=_b[conflict_time2016]/_se[conflict_time2016]
		local tv=_b[conflict_time2020]/_se[conflict_time2020]
		local pu= 2*ttail(`e(df_r)',abs(`tu'))
		local pv= 2*ttail(`e(df_r)',abs(`tv'))
		global r26_`i': di %4.3f `= e(r2)'
		global N6_`i': di %9.0f `= e(N)'
		
		foreach n in u v {
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
		
		********** HOMBRES
		*** EDAD 1
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==0, vce(cluster MUNICIPIO)
		local f: di %4.3f `= _b[conflict_time]'
		global sef_`i': di %4.3f `= _se[conflict_time]'
		local tf=_b[conflict_time]/_se[conflict_time]
		local pf= 2*ttail(`e(df_r)',abs(`tf'))
		global r27_`i': di %4.3f `= e(r2)'
		global N7_`i': di %9.0f `= e(N)'
		
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==0, vce(cluster MUNICIPIO)
		local j: di %4.3f `= _b[conflict_time2016]'
		global sej_`i': di %4.3f `= _se[conflict_time2016]'	
		local m: di %4.3f `= _b[conflict_time2020]'
		global sem_`i': di %4.3f `= _se[conflict_time2020]'
		local tj=_b[conflict_time2016]/_se[conflict_time2016]
		local tm=_b[conflict_time2020]/_se[conflict_time2020]
		local pj= 2*ttail(`e(df_r)',abs(`tj'))
		local pm= 2*ttail(`e(df_r)',abs(`tm'))
		global r28_`i': di %4.3f `= e(r2)'
		global N8_`i': di %9.0f `= e(N)'
		
		foreach n in j m {
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
		
		*** EDAD 2
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0 &dummyedad==1, vce(cluster MUNICIPIO)
		local g: di %4.3f `= _b[conflict_time]'
		global seg_`i': di %4.3f `= _se[conflict_time]'
		local tg=_b[conflict_time]/_se[conflict_time]
		local pg= 2*ttail(`e(df_r)',abs(`tg'))
		global r29_`i': di %4.3f `= e(r2)'
		global N9_`i': di %9.0f `= e(N)'
		
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==1, vce(cluster MUNICIPIO)
		local k: di %4.3f `= _b[conflict_time2016]'
		global sek_`i': di %4.3f `= _se[conflict_time2016]'	
		local o: di %4.3f `= _b[conflict_time2020]'
		global seo_`i': di %4.3f `= _se[conflict_time2020]'
		local tk=_b[conflict_time2016]/_se[conflict_time2016]
		local to=_b[conflict_time2020]/_se[conflict_time2020]
		local pk= 2*ttail(`e(df_r)',abs(`tk'))
		local po= 2*ttail(`e(df_r)',abs(`to'))
		global r210_`i': di %4.3f `= e(r2)'
		global N10_`i': di %9.0f `= e(N)'
		
		foreach n in k o {
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
		
		*** EDAD 3
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==2, vce(cluster MUNICIPIO)
		local h: di %4.3f `= _b[conflict_time]'
		global seh_`i': di %4.3f `= _se[conflict_time]'
		local th=_b[conflict_time]/_se[conflict_time]
		local ph= 2*ttail(`e(df_r)',abs(`th'))
		global r211_`i': di %4.3f `= e(r2)'
		global N11_`i': di %9.0f `= e(N)'
		
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==2, vce(cluster MUNICIPIO)
		local l: di %4.3f `= _b[conflict_time2016]'
		global sel_`i': di %4.3f `= _se[conflict_time2016]'	
		local p: di %4.3f `= _b[conflict_time2020]'
		global sep_`i': di %4.3f `= _se[conflict_time2020]'
		local tl=_b[conflict_time2016]/_se[conflict_time2016]
		local tp=_b[conflict_time2020]/_se[conflict_time2020]
		local pl= 2*ttail(`e(df_r)',abs(`tl'))
		local pp= 2*ttail(`e(df_r)',abs(`tp'))
		global r212_`i': di %4.3f `= e(r2)'
		global N12_`i': di %9.0f `= e(N)'
		
		foreach n in l p {
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
	
file write latex3 "\textbf{`lab'} \\" _n
file write latex3 " Conflict x Time & ${ba_`i'} && ${bc_`i'} && ${be_`i'} && ${bf_`i'} && ${bg_`i'} && ${bh_`i'} & \\" _n
file write latex3 "  & (${sea_`i'})&& (${sec_`i'}) && (${see_`i'})&& (${sef_`i'})&& (${seg_`i'}) && (${seh_`i'})& \\" _n

file write latex3 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} && ${bu_`i'} && ${bj_`i'} && ${bk_`i'} && ${bl_`i'} \\" _n
file write latex3 " && (${sey_`i'})&& (${sex_`i'}) && (${seu_`i'}) && (${sej_`i'})&& (${sek_`i'}) && (${sel_`i'})\\" _n

file write latex3 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} && ${bv_`i'} && ${bm_`i'} && ${bo_`i'} && ${bp_`i'} \\" _n
file write latex3 " && (${sez_`i'})&& (${sew_`i'}) && (${sev_`i'}) && (${sem_`i'})&& (${seo_`i'}) && (${sep_`i'})\\" _n

file write latex3 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} & ${N5_`i'} & ${N6_`i'} & ${N7_`i'} & ${N8_`i'} & ${N9_`i'} & ${N10_`i'} & ${N11_`i'} & ${N12_`i'} \\" _n
file write latex3 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'} & ${r29_`i'} & ${r210_`i'} & ${r211_`i'} & ${r212_`i'} \\" _n
file write latex3 "\hline" _n
	}
file write latex3 "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex3 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex3 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex3 "\hline \hline" _n
file write latex3 "\end{tabular}" _n
file close latex3

*********************** v2 - Tobit

file open latex4 using "${sale}/reg4c_v2.txt", write replace text
file write latex4 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex4 "\begin{tabular}{l c c c c c c c c c c c c} \\ \hline \hline" _n
file write latex4 "& \multicolumn{6}{c}{Female} & \multicolumn{6}{c}{Male} \\ \cline{2-13}" _n
file write latex4 "& \multicolumn{2}{c}{14-19 years} & \multicolumn{2}{c}{20-23 years} & \multicolumn{2}{c}{24-28 years} & \multicolumn{2}{c}{14-19 years} & \multicolumn{2}{c}{20-23 years} & \multicolumn{2}{c}{24-28 years}  \\" _n
file write latex4 "& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) & (10) & (11) & (12) \\ \hline" _n

	foreach i in $ceros {

		********** MUJERES
		*** EDAD 1
		* v2 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==0, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==0, vce(cluster MUNICIPIO) ll(0) ul(24)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** EDAD 2
		* v2 - Básica 
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==1, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==1, vce(cluster MUNICIPIO) ll(0) ul(24)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
		
		*** EDAD 3
		* v2 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==2, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año (OLS)
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==2, vce(cluster MUNICIPIO) ll(0) ul(24)
		local u: di %4.3f `= _b[conflict_time2016]'
		global seu_`i': di %4.3f `= _se[conflict_time2016]'	
		local v: di %4.3f `= _b[conflict_time2020]'
		global sev_`i': di %4.3f `= _se[conflict_time2020]'
		local tu=_b[conflict_time2016]/_se[conflict_time2016]
		local tv=_b[conflict_time2020]/_se[conflict_time2020]
		local pu= 2*ttail(`e(df_r)',abs(`tu'))
		local pv= 2*ttail(`e(df_r)',abs(`tv'))
		global r26_`i': di %4.3f `= e(r2)'
		global N6_`i': di %9.0f `= e(N)'
		
		foreach n in u v {
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
		
		********** HOMBRES
		*** EDAD 1
		* v1 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==0, vce(cluster MUNICIPIO) ll(0) ul(24)
		local f: di %4.3f `= _b[conflict_time]'
		global sef_`i': di %4.3f `= _se[conflict_time]'
		local tf=_b[conflict_time]/_se[conflict_time]
		local pf= 2*ttail(`e(df_r)',abs(`tf'))
		global r27_`i': di %4.3f `= e(r2)'
		global N7_`i': di %9.0f `= e(N)'
		
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
		
		* v1 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==0, vce(cluster MUNICIPIO) ll(0) ul(24)
		local j: di %4.3f `= _b[conflict_time2016]'
		global sej_`i': di %4.3f `= _se[conflict_time2016]'	
		local m: di %4.3f `= _b[conflict_time2020]'
		global sem_`i': di %4.3f `= _se[conflict_time2020]'
		local tj=_b[conflict_time2016]/_se[conflict_time2016]
		local tm=_b[conflict_time2020]/_se[conflict_time2020]
		local pj= 2*ttail(`e(df_r)',abs(`tj'))
		local pm= 2*ttail(`e(df_r)',abs(`tm'))
		global r28_`i': di %4.3f `= e(r2)'
		global N8_`i': di %9.0f `= e(N)'
		
		foreach n in j m {
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
		
		*** EDAD 2
		* v1 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0 &dummyedad==1, vce(cluster MUNICIPIO) ll(0) ul(24)
		local g: di %4.3f `= _b[conflict_time]'
		global seg_`i': di %4.3f `= _se[conflict_time]'
		local tg=_b[conflict_time]/_se[conflict_time]
		local pg= 2*ttail(`e(df_r)',abs(`tg'))
		global r29_`i': di %4.3f `= e(r2)'
		global N9_`i': di %9.0f `= e(N)'
		
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
		
		* v1 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==1, vce(cluster MUNICIPIO) ll(0) ul(24)
		local k: di %4.3f `= _b[conflict_time2016]'
		global sek_`i': di %4.3f `= _se[conflict_time2016]'	
		local o: di %4.3f `= _b[conflict_time2020]'
		global seo_`i': di %4.3f `= _se[conflict_time2020]'
		local tk=_b[conflict_time2016]/_se[conflict_time2016]
		local to=_b[conflict_time2020]/_se[conflict_time2020]
		local pk= 2*ttail(`e(df_r)',abs(`tk'))
		local po= 2*ttail(`e(df_r)',abs(`to'))
		global r210_`i': di %4.3f `= e(r2)'
		global N10_`i': di %9.0f `= e(N)'
		
		foreach n in k o {
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
		
		*** EDAD 3
		* v1 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==2, vce(cluster MUNICIPIO) ll(0) ul(24)
		local h: di %4.3f `= _b[conflict_time]'
		global seh_`i': di %4.3f `= _se[conflict_time]'
		local th=_b[conflict_time]/_se[conflict_time]
		local ph= 2*ttail(`e(df_r)',abs(`th'))
		global r211_`i': di %4.3f `= e(r2)'
		global N11_`i': di %9.0f `= e(N)'
		
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
		
		* v1 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==2, vce(cluster MUNICIPIO) ll(0) ul(24)
		local l: di %4.3f `= _b[conflict_time2016]'
		global sel_`i': di %4.3f `= _se[conflict_time2016]'	
		local p: di %4.3f `= _b[conflict_time2020]'
		global sep_`i': di %4.3f `= _se[conflict_time2020]'
		local tl=_b[conflict_time2016]/_se[conflict_time2016]
		local tp=_b[conflict_time2020]/_se[conflict_time2020]
		local pl= 2*ttail(`e(df_r)',abs(`tl'))
		local pp= 2*ttail(`e(df_r)',abs(`tp'))
		global r212_`i': di %4.3f `= e(r2)'
		global N12_`i': di %9.0f `= e(N)'
		
		foreach n in l p {
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
	
file write latex4 "\textbf{`lab'} \\" _n
file write latex4 " Conflict x Time & ${ba_`i'} && ${bc_`i'} && ${be_`i'} && ${bf_`i'} && ${bg_`i'} && ${bh_`i'} & \\" _n
file write latex4 "  & (${sea_`i'})&& (${sec_`i'}) && (${see_`i'})&& (${sef_`i'})&& (${seg_`i'}) && (${seh_`i'})& \\" _n

file write latex4 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} && ${bu_`i'} && ${bj_`i'} && ${bk_`i'} && ${bl_`i'} \\" _n
file write latex4 " && (${sey_`i'})&& (${sex_`i'}) && (${seu_`i'}) && (${sej_`i'})&& (${sek_`i'}) && (${sel_`i'})\\" _n

file write latex4 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} && ${bv_`i'} && ${bm_`i'} && ${bo_`i'} && ${bp_`i'} \\" _n
file write latex4 " && (${sez_`i'})&& (${sew_`i'}) && (${sev_`i'}) && (${sem_`i'})&& (${seo_`i'}) && (${sep_`i'})\\" _n

file write latex4 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} & ${N5_`i'} & ${N6_`i'} & ${N7_`i'} & ${N8_`i'} & ${N9_`i'} & ${N10_`i'} & ${N11_`i'} & ${N12_`i'} \\" _n
file write latex4 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'} & ${r29_`i'} & ${r210_`i'} & ${r211_`i'} & ${r212_`i'} \\" _n
file write latex4 "\hline" _n
	}
file write latex4 "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex4 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex4 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex4 "\hline \hline" _n
file write latex4 "\end{tabular}" _n
file close latex4

*********************** v3 - Dummys

file open latex5 using "${sale}/reg4c_v3.txt", write replace text
file write latex5 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex5 "\begin{tabular}{l c c c c c c c c c c c c} \\ \hline \hline" _n
file write latex5 "& \multicolumn{6}{c}{Female} & \multicolumn{6}{c}{Male} \\ \cline{2-13}" _n
file write latex5 "& \multicolumn{2}{c}{14-19 years} & \multicolumn{2}{c}{20-23 years} & \multicolumn{2}{c}{24-28 years} & \multicolumn{2}{c}{14-19 years} & \multicolumn{2}{c}{20-23 years} & \multicolumn{2}{c}{24-28 years}  \\" _n
file write latex5 "& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) & (10) & (11) & (12) \\ \hline" _n

	foreach i in $dummys {
		
		********** MUJERES
		*** EDAD 1
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==0, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==0, vce(cluster MUNICIPIO)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** EDAD 2
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==1, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==1, vce(cluster MUNICIPIO)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
		
		*** EDAD 3
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==2, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==1 & dummyedad==2, vce(cluster MUNICIPIO)
		local u: di %4.3f `= _b[conflict_time2016]'
		global seu_`i': di %4.3f `= _se[conflict_time2016]'	
		local v: di %4.3f `= _b[conflict_time2020]'
		global sev_`i': di %4.3f `= _se[conflict_time2020]'
		local tu=_b[conflict_time2016]/_se[conflict_time2016]
		local tv=_b[conflict_time2020]/_se[conflict_time2020]
		local pu= 2*ttail(`e(df_r)',abs(`tu'))
		local pv= 2*ttail(`e(df_r)',abs(`tv'))
		global r26_`i': di %4.3f `= e(r2)'
		global N6_`i': di %9.0f `= e(N)'
		
		foreach n in u v {
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
		
		********** HOMBRES
		*** EDAD 1
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==0, vce(cluster MUNICIPIO)
		local f: di %4.3f `= _b[conflict_time]'
		global sef_`i': di %4.3f `= _se[conflict_time]'
		local tf=_b[conflict_time]/_se[conflict_time]
		local pf= 2*ttail(`e(df_r)',abs(`tf'))
		global r27_`i': di %4.3f `= e(r2)'
		global N7_`i': di %9.0f `= e(N)'
		
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==0, vce(cluster MUNICIPIO)
		local j: di %4.3f `= _b[conflict_time2016]'
		global sej_`i': di %4.3f `= _se[conflict_time2016]'	
		local m: di %4.3f `= _b[conflict_time2020]'
		global sem_`i': di %4.3f `= _se[conflict_time2020]'
		local tj=_b[conflict_time2016]/_se[conflict_time2016]
		local tm=_b[conflict_time2020]/_se[conflict_time2020]
		local pj= 2*ttail(`e(df_r)',abs(`tj'))
		local pm= 2*ttail(`e(df_r)',abs(`tm'))
		global r28_`i': di %4.3f `= e(r2)'
		global N8_`i': di %9.0f `= e(N)'
		
		foreach n in j m {
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
		
		*** EDAD 2
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0 &dummyedad==1, vce(cluster MUNICIPIO)
		local g: di %4.3f `= _b[conflict_time]'
		global seg_`i': di %4.3f `= _se[conflict_time]'
		local tg=_b[conflict_time]/_se[conflict_time]
		local pg= 2*ttail(`e(df_r)',abs(`tg'))
		global r29_`i': di %4.3f `= e(r2)'
		global N9_`i': di %9.0f `= e(N)'
		
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==1, vce(cluster MUNICIPIO)
		local k: di %4.3f `= _b[conflict_time2016]'
		global sek_`i': di %4.3f `= _se[conflict_time2016]'	
		local o: di %4.3f `= _b[conflict_time2020]'
		global seo_`i': di %4.3f `= _se[conflict_time2020]'
		local tk=_b[conflict_time2016]/_se[conflict_time2016]
		local to=_b[conflict_time2020]/_se[conflict_time2020]
		local pk= 2*ttail(`e(df_r)',abs(`tk'))
		local po= 2*ttail(`e(df_r)',abs(`to'))
		global r210_`i': di %4.3f `= e(r2)'
		global N10_`i': di %9.0f `= e(N)'
		
		foreach n in k o {
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
		
		*** EDAD 3
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==2, vce(cluster MUNICIPIO)
		local h: di %4.3f `= _b[conflict_time]'
		global seh_`i': di %4.3f `= _se[conflict_time]'
		local th=_b[conflict_time]/_se[conflict_time]
		local ph= 2*ttail(`e(df_r)',abs(`th'))
		global r211_`i': di %4.3f `= e(r2)'
		global N11_`i': di %9.0f `= e(N)'
		
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if SEXO==0 & dummyedad==2, vce(cluster MUNICIPIO)
		local l: di %4.3f `= _b[conflict_time2016]'
		global sel_`i': di %4.3f `= _se[conflict_time2016]'	
		local p: di %4.3f `= _b[conflict_time2020]'
		global sep_`i': di %4.3f `= _se[conflict_time2020]'
		local tl=_b[conflict_time2016]/_se[conflict_time2016]
		local tp=_b[conflict_time2020]/_se[conflict_time2020]
		local pl= 2*ttail(`e(df_r)',abs(`tl'))
		local pp= 2*ttail(`e(df_r)',abs(`tp'))
		global r212_`i': di %4.3f `= e(r2)'
		global N12_`i': di %9.0f `= e(N)'
		
		foreach n in l p {
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
	
file write latex5 "\textbf{`lab'} \\" _n
file write latex5 " Conflict x Time & ${ba_`i'} && ${bc_`i'} && ${be_`i'} && ${bf_`i'} && ${bg_`i'} && ${bh_`i'} & \\" _n
file write latex5 "  & (${sea_`i'})&& (${sec_`i'}) && (${see_`i'})&& (${sef_`i'})&& (${seg_`i'}) && (${seh_`i'})& \\" _n

file write latex5 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} && ${bu_`i'} && ${bj_`i'} && ${bk_`i'} && ${bl_`i'} \\" _n
file write latex5 " && (${sey_`i'})&& (${sex_`i'}) && (${seu_`i'}) && (${sej_`i'})&& (${sek_`i'}) && (${sel_`i'})\\" _n

file write latex5 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} && ${bv_`i'} && ${bm_`i'} && ${bo_`i'} && ${bp_`i'} \\" _n
file write latex5 " && (${sez_`i'})&& (${sew_`i'}) && (${sev_`i'}) && (${sem_`i'})&& (${seo_`i'}) && (${sep_`i'})\\" _n

file write latex5 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} & ${N5_`i'} & ${N6_`i'} & ${N7_`i'} & ${N8_`i'} & ${N9_`i'} & ${N10_`i'} & ${N11_`i'} & ${N12_`i'} \\" _n
file write latex5 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'} & ${r29_`i'} & ${r210_`i'} & ${r211_`i'} & ${r212_`i'} \\" _n
file write latex5 "\hline" _n
	}
file write latex5 "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex5 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex5 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex5 "\hline \hline" _n
file write latex5 "\end{tabular}" _n
file close latex5
	
* ----------------------------------------------------------------------
* VII.3 Educación jefe del hogar
* ---------------------------------------------------------------------*/

*********************** v1 - OLS

file open latex12 using "${sale}/reg5c_v1.txt", write replace text
file write latex12 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex12 "\begin{tabular}{l c c c c c c c c} \\ \hline \hline" _n
file write latex12 "& \multicolumn{2}{c}{No education} & \multicolumn{2}{c}{Preschool/elementary} & \multicolumn{2}{c}{Middle/High school} & \multicolumn{2}{c}{Under/postgraduate} \\" _n
file write latex12 "& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8)  \\ \hline" _n

	foreach i in $ceros {
		
		*** EDU 1
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==1, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if EDU==1, vce(cluster MUNICIPIO)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** EDU 2
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==2, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if EDU==2, vce(cluster MUNICIPIO)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
		
		*** EDU 3
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==3, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if EDU==3, vce(cluster MUNICIPIO)
		local u: di %4.3f `= _b[conflict_time2016]'
		global seu_`i': di %4.3f `= _se[conflict_time2016]'	
		local v: di %4.3f `= _b[conflict_time2020]'
		global sev_`i': di %4.3f `= _se[conflict_time2020]'
		local tu=_b[conflict_time2016]/_se[conflict_time2016]
		local tv=_b[conflict_time2020]/_se[conflict_time2020]
		local pu= 2*ttail(`e(df_r)',abs(`tu'))
		local pv= 2*ttail(`e(df_r)',abs(`tv'))
		global r26_`i': di %4.3f `= e(r2)'
		global N6_`i': di %9.0f `= e(N)'
		
		foreach n in u v {
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
		
		*** EDU 4
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==4, vce(cluster MUNICIPIO)
		local o: di %4.3f `= _b[conflict_time]'
		global seo_`i': di %4.3f `= _se[conflict_time]'
		local to=_b[conflict_time]/_se[conflict_time]
		local po= 2*ttail(`e(df_r)',abs(`to'))
		global r27_`i': di %4.3f `= e(r2)'
		global N7_`i': di %9.0f `= e(N)'
		
		if `po'<=0.01 {
			global bo_`i' "`o'\sym{***}"
		}
		
		if `po'<=0.05 & `po'>0.01 {
			global bo_`i' "`o'\sym{**}"
		}
		
		if `po'<=0.1 & `po'>0.05 {
			global bo_`i' "`o'\sym{*}"
		}

		if `po'>0.1  {
			global bo_`i' "`o'"
		}
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if EDU==4, vce(cluster MUNICIPIO)
		local m: di %4.3f `= _b[conflict_time2016]'
		global sem_`i': di %4.3f `= _se[conflict_time2016]'	
		local n: di %4.3f `= _b[conflict_time2020]'
		global sen_`i': di %4.3f `= _se[conflict_time2020]'
		local tm=_b[conflict_time2016]/_se[conflict_time2016]
		local tn=_b[conflict_time2020]/_se[conflict_time2020]
		local pm= 2*ttail(`e(df_r)',abs(`tm'))
		local pn= 2*ttail(`e(df_r)',abs(`tn'))
		global r28_`i': di %4.3f `= e(r2)'
		global N8_`i': di %9.0f `= e(N)'
		
		foreach a in m n {
		if `p`a''<=0.01 {
			global b`a'_`i' "``a''\sym{***}"
		}
		
		if `p`a''<=0.05 & `p`a''>0.01 {
			global b`a'_`i' "``a''\sym{**}"
		}
		
		if `p`a''<=0.1 & `p`a''>0.05 {
			global b`a'_`i' "``a''\sym{*}"
		}

		if `p`a''>0.1  {
			global b`a'_`i' "``a''"
		}
		}

	local lab: variable label `i'
	
		foreach n of numlist 1/4 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & EDU==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}

	
file write latex12 "\textbf{`lab'} \\" _n
file write latex12 " Conflict x Time & ${ba_`i'} && ${bc_`i'} && ${be_`i'} && ${bo_`i'} &  \\" _n
file write latex12 "  & (${sea_`i'})&& (${sec_`i'}) && (${see_`i'})&& (${seo_`i'})& \\" _n

file write latex12 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} && ${bu_`i'} && ${bm_`i'} \\" _n
file write latex12 " && (${sey_`i'})&& (${sex_`i'}) && (${seu_`i'}) && (${sem_`i'})\\" _n

file write latex12 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} && ${bv_`i'} && ${bn_`i'} \\" _n
file write latex12 " && (${sez_`i'})&& (${sew_`i'}) && (${sev_`i'}) && (${sen_`i'})\\" _n

file write latex12 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} & ${N5_`i'} & ${N6_`i'} & ${N7_`i'} & ${N8_`i'} \\" _n
file write latex12 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'}  \\" _n
file write latex12 " Pre-t treat. mean & ${m11_`i'} & ${m11_`i'} & ${m12_`i'} & ${m12_`i'} & ${m13_`i'} & ${m13_`i'} & ${m14_`i'} & ${m14_`i'}  \\" _n
file write latex12 " Pre-t cont. mean & ${m01_`i'} & ${m01_`i'} & ${m02_`i'} & ${m02_`i'} & ${m03_`i'} & ${m03_`i'} & ${m04_`i'} & ${m04_`i'}  \\" _n

file write latex12 "\hline" _n
	}
file write latex12 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex12 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex12 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex12 "\hline \hline" _n
file write latex12 "\end{tabular}" _n
file close latex12

*********************** v2 - Tobit

file open latex13 using "${sale}/reg5c_v2.txt", write replace text
file write latex13 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex13 "\begin{tabular}{l c c c c c c c c} \\ \hline \hline" _n
file write latex13 "& \multicolumn{2}{c}{No education} & \multicolumn{2}{c}{Preschool/elementary} & \multicolumn{2}{c}{Middle/High school} & \multicolumn{2}{c}{Under/postgraduate} \\" _n
file write latex13 "& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8)  \\ \hline" _n

	foreach i in $ceros {
		
		*** EDU 1
		* v2 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==1, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if EDU==1, vce(cluster MUNICIPIO) ll(0) ul(24)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** EDU 2
		* v2 - Básica 
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==2, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if EDU==2, vce(cluster MUNICIPIO) ll(0) ul(24)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
		
		*** EDU 3
		* v2 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==3, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año 
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if EDU==3, vce(cluster MUNICIPIO) ll(0) ul(24)
		local u: di %4.3f `= _b[conflict_time2016]'
		global seu_`i': di %4.3f `= _se[conflict_time2016]'	
		local v: di %4.3f `= _b[conflict_time2020]'
		global sev_`i': di %4.3f `= _se[conflict_time2020]'
		local tu=_b[conflict_time2016]/_se[conflict_time2016]
		local tv=_b[conflict_time2020]/_se[conflict_time2020]
		local pu= 2*ttail(`e(df_r)',abs(`tu'))
		local pv= 2*ttail(`e(df_r)',abs(`tv'))
		global r26_`i': di %4.3f `= e(r2)'
		global N6_`i': di %9.0f `= e(N)'
		
		foreach n in u v {
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
		
		*** EDU 4
		* v2 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==4, vce(cluster MUNICIPIO) ll(0) ul(24)
		local o: di %4.3f `= _b[conflict_time]'
		global seo_`i': di %4.3f `= _se[conflict_time]'
		local to=_b[conflict_time]/_se[conflict_time]
		local po= 2*ttail(`e(df_r)',abs(`to'))
		global r27_`i': di %4.3f `= e(r2)'
		global N7_`i': di %9.0f `= e(N)'
		
		if `po'<=0.01 {
			global bo_`i' "`o'\sym{***}"
		}
		
		if `po'<=0.05 & `po'>0.01 {
			global bo_`i' "`o'\sym{**}"
		}
		
		if `po'<=0.1 & `po'>0.05 {
			global bo_`i' "`o'\sym{*}"
		}

		if `po'>0.1  {
			global bo_`i' "`o'"
		}
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if EDU==4, vce(cluster MUNICIPIO) ll(0) ul(24)
		local m: di %4.3f `= _b[conflict_time2016]'
		global sem_`i': di %4.3f `= _se[conflict_time2016]'	
		local n: di %4.3f `= _b[conflict_time2020]'
		global sen_`i': di %4.3f `= _se[conflict_time2020]'
		local tm=_b[conflict_time2016]/_se[conflict_time2016]
		local tn=_b[conflict_time2020]/_se[conflict_time2020]
		local pm= 2*ttail(`e(df_r)',abs(`tm'))
		local pn= 2*ttail(`e(df_r)',abs(`tn'))
		global r28_`i': di %4.3f `= e(r2)'
		global N8_`i': di %9.0f `= e(N)'
		
		foreach a in m n {
		if `p`a''<=0.01 {
			global b`a'_`i' "``a''\sym{***}"
		}
		
		if `p`a''<=0.05 & `p`a''>0.01 {
			global b`a'_`i' "``a''\sym{**}"
		}
		
		if `p`a''<=0.1 & `p`a''>0.05 {
			global b`a'_`i' "``a''\sym{*}"
		}

		if `p`a''>0.1  {
			global b`a'_`i' "``a''"
		}
		}

	local lab: variable label `i'
	
		foreach n of numlist 1/4 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & EDU==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex13 "\textbf{`lab'} \\" _n
file write latex13 " Conflict x Time & ${ba_`i'} && ${bc_`i'} && ${be_`i'} && ${bo_`i'} &  \\" _n
file write latex13 "  & (${sea_`i'})&& (${sec_`i'}) && (${see_`i'})&& (${seo_`i'})& \\" _n

file write latex13 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} && ${bu_`i'} && ${bm_`i'} \\" _n
file write latex13 " && (${sey_`i'})&& (${sex_`i'}) && (${seu_`i'}) && (${sem_`i'})\\" _n

file write latex13 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} && ${bv_`i'} && ${bn_`i'} \\" _n
file write latex13 " && (${sez_`i'})&& (${sew_`i'}) && (${sev_`i'}) && (${sen_`i'})\\" _n

file write latex13 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} & ${N5_`i'} & ${N6_`i'} & ${N7_`i'} & ${N8_`i'} \\" _n
file write latex13 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'}  \\" _n
file write latex13 " Pre-t treat. mean & ${m11_`i'} & ${m11_`i'} & ${m12_`i'} & ${m12_`i'} & ${m13_`i'} & ${m13_`i'} & ${m14_`i'} & ${m14_`i'}  \\" _n
file write latex13 " Pre-t cont. mean & ${m01_`i'} & ${m01_`i'} & ${m02_`i'} & ${m02_`i'} & ${m03_`i'} & ${m03_`i'} & ${m04_`i'} & ${m04_`i'}  \\" _n

file write latex13 "\hline" _n
	}
file write latex13 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex13 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex13 "Control & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex13 "\hline \hline" _n
file write latex13 "\end{tabular}" _n
file close latex13

*********************** v3 - Dummys

file open latex14 using "${sale}/reg5c_v3.txt", write replace text
file write latex14 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex14 "\begin{tabular}{l c c c c c c c c} \\ \hline \hline" _n
file write latex14 "& \multicolumn{2}{c}{No education} & \multicolumn{2}{c}{Preschool/elementary} & \multicolumn{2}{c}{Middle/High school} & \multicolumn{2}{c}{Under/postgraduate} \\" _n
file write latex14 "& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8)  \\ \hline" _n

	foreach i in $dummys {
		
		*** EDU 1
		* v3 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==1, vce(cluster MUNICIPIO)
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
		
		* v3 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if EDU==1, vce(cluster MUNICIPIO)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** EDU 2
		* v3 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==2, vce(cluster MUNICIPIO)
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
		
		* v3 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if EDU==2, vce(cluster MUNICIPIO)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
		
		*** EDU 3
		* v3 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==3, vce(cluster MUNICIPIO)
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
		
		* v3 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if EDU==3, vce(cluster MUNICIPIO)
		local u: di %4.3f `= _b[conflict_time2016]'
		global seu_`i': di %4.3f `= _se[conflict_time2016]'	
		local v: di %4.3f `= _b[conflict_time2020]'
		global sev_`i': di %4.3f `= _se[conflict_time2020]'
		local tu=_b[conflict_time2016]/_se[conflict_time2016]
		local tv=_b[conflict_time2020]/_se[conflict_time2020]
		local pu= 2*ttail(`e(df_r)',abs(`tu'))
		local pv= 2*ttail(`e(df_r)',abs(`tv'))
		global r26_`i': di %4.3f `= e(r2)'
		global N6_`i': di %9.0f `= e(N)'
		
		foreach n in u v {
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
		
		*** EDU 4
		* v3 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if EDU==4, vce(cluster MUNICIPIO)
		local o: di %4.3f `= _b[conflict_time]'
		global seo_`i': di %4.3f `= _se[conflict_time]'
		local to=_b[conflict_time]/_se[conflict_time]
		local po= 2*ttail(`e(df_r)',abs(`to'))
		global r27_`i': di %4.3f `= e(r2)'
		global N7_`i': di %9.0f `= e(N)'
		
		if `po'<=0.01 {
			global bo_`i' "`o'\sym{***}"
		}
		
		if `po'<=0.05 & `po'>0.01 {
			global bo_`i' "`o'\sym{**}"
		}
		
		if `po'<=0.1 & `po'>0.05 {
			global bo_`i' "`o'\sym{*}"
		}

		if `po'>0.1  {
			global bo_`i' "`o'"
		}
		
		* v3 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if EDU==4, vce(cluster MUNICIPIO)
		local m: di %4.3f `= _b[conflict_time2016]'
		global sem_`i': di %4.3f `= _se[conflict_time2016]'	
		local n: di %4.3f `= _b[conflict_time2020]'
		global sen_`i': di %4.3f `= _se[conflict_time2020]'
		local tm=_b[conflict_time2016]/_se[conflict_time2016]
		local tn=_b[conflict_time2020]/_se[conflict_time2020]
		local pm= 2*ttail(`e(df_r)',abs(`tm'))
		local pn= 2*ttail(`e(df_r)',abs(`tn'))
		global r28_`i': di %4.3f `= e(r2)'
		global N8_`i': di %9.0f `= e(N)'
		
		foreach a in m n {
		if `p`a''<=0.01 {
			global b`a'_`i' "``a''\sym{***}"
		}
		
		if `p`a''<=0.05 & `p`a''>0.01 {
			global b`a'_`i' "``a''\sym{**}"
		}
		
		if `p`a''<=0.1 & `p`a''>0.05 {
			global b`a'_`i' "``a''\sym{*}"
		}

		if `p`a''>0.1  {
			global b`a'_`i' "``a''"
		}
		}

	local lab: variable label `i'
	
		foreach n of numlist 1/4 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & EDU==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex14 "\textbf{`lab'} \\" _n
file write latex14 " Conflict x Time & ${ba_`i'} && ${bc_`i'} && ${be_`i'} && ${bo_`i'} &  \\" _n
file write latex14 "  & (${sea_`i'})&& (${sec_`i'}) && (${see_`i'})&& (${seo_`i'})& \\" _n

file write latex14 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} && ${bu_`i'} && ${bm_`i'} \\" _n
file write latex14 " && (${sey_`i'})&& (${sex_`i'}) && (${seu_`i'}) && (${sem_`i'})\\" _n

file write latex14 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} && ${bv_`i'} && ${bn_`i'} \\" _n
file write latex14 " && (${sez_`i'})&& (${sew_`i'}) && (${sev_`i'}) && (${sen_`i'})\\" _n

file write latex14 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} & ${N5_`i'} & ${N6_`i'} & ${N7_`i'} & ${N8_`i'} \\" _n
file write latex14 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'}  \\" _n
file write latex14 " Pre-t treat. mean & ${m11_`i'} & ${m11_`i'} & ${m12_`i'} & ${m12_`i'} & ${m13_`i'} & ${m13_`i'} & ${m14_`i'} & ${m14_`i'}  \\" _n
file write latex14 " Pre-t cont. mean & ${m01_`i'} & ${m01_`i'} & ${m02_`i'} & ${m02_`i'} & ${m03_`i'} & ${m03_`i'} & ${m04_`i'} & ${m04_`i'}  \\" _n

file write latex14 "\hline" _n
	}
file write latex14 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex14 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex14 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex14 "\hline \hline" _n
file write latex14 "\end{tabular}" _n
file close latex14

* ----------------------------------------------------------------------
* VII.4 Tenencia de activos
* ----------------------------------------------------------------------
	
*********************** v1 - OLS

file open latex15 using "${sale}/reg6c_v1.txt", write replace text
file write latex15 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex15 "\begin{tabular}{l c c c c} \\ \hline \hline" _n
file write latex15 "& \multicolumn{2}{c}{Lower possession} & \multicolumn{2}{c}{Higher possession} \\" _n
file write latex15 "& (1) & (2) & (3) & (4)  \\ \hline" _n

	foreach i in $ceros {
		
		*** High
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if ingdummy==1, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if ingdummy==1, vce(cluster MUNICIPIO)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** Low
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
	
		foreach n of numlist 0/1 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & ingdummy==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex15 "\textbf{`lab'} \\" _n
file write latex15 " Conflict x Time & ${ba_`i'} && ${bc_`i'} &  \\" _n
file write latex15 "  & (${sea_`i'})&& (${sec_`i'}) & \\" _n

file write latex15 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} \\" _n
file write latex15 " && (${sey_`i'}) && (${sex_`i'}) \\" _n

file write latex15 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} \\" _n
file write latex15 " && (${sez_`i'})&& (${sew_`i'})\\" _n

file write latex15 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} \\" _n
file write latex15 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} \\" _n
file write latex15 " Pre-t treat. mean & ${m11_`i'} & ${m11_`i'} & ${m10_`i'} & ${m10_`i'} \\" _n
file write latex15 " Pre-t cont. mean & ${m01_`i'} & ${m01_`i'} & ${m00_`i'} & ${m00_`i'} \\" _n

file write latex15 "\hline" _n
	}
file write latex15 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex15 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex15 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex15 "\hline \hline" _n
file write latex15 "\end{tabular}" _n
file close latex15

*********************** v2 - Tobit

file open latex16 using "${sale}/reg6c_v2.txt", write replace text
file write latex16 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex16 "\begin{tabular}{l c c c c} \\ \hline \hline" _n
file write latex16 "& \multicolumn{2}{c}{Lower possession} & \multicolumn{2}{c}{Higher possession} \\" _n
file write latex16 "& (1) & (2) & (3) & (4)  \\ \hline" _n

	foreach i in $ceros {
		
		*** High
		* v2 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if ingdummy==1, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if ingdummy==1, vce(cluster MUNICIPIO) ll(0) ul(24)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** Low
		* v2 - Básica 
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO) ll(0) ul(24)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
	
		foreach n of numlist 0/1 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & ingdummy==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex16 "\textbf{`lab'} \\" _n
file write latex16 " Conflict x Time & ${ba_`i'} && ${bc_`i'} &  \\" _n
file write latex16 "  & (${sea_`i'})&& (${sec_`i'}) & \\" _n

file write latex16 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} \\" _n
file write latex16 " && (${sey_`i'}) && (${sex_`i'}) \\" _n

file write latex16 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} \\" _n
file write latex16 " && (${sez_`i'})&& (${sew_`i'})\\" _n

file write latex16 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} \\" _n
file write latex16 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} \\" _n
file write latex16 " Pre-t treat. mean & ${m11_`i'} & ${m11_`i'} & ${m10_`i'} & ${m10_`i'} \\" _n
file write latex16 " Pre-t cont. mean & ${m01_`i'} & ${m01_`i'} & ${m00_`i'} & ${m00_`i'} \\" _n

file write latex16 "\hline" _n
	}
file write latex16 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex16 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex16 "Control & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex16 "\hline \hline" _n
file write latex16 "\end{tabular}" _n
file close latex16

*********************** v3 - Dummys

file open latex17 using "${sale}/reg6c_v3.txt", write replace text
file write latex17 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex17 "\begin{tabular}{l c c c c} \\ \hline \hline" _n
file write latex17 "& \multicolumn{2}{c}{Lower possession} & \multicolumn{2}{c}{Higher possession} \\" _n
file write latex17 "& (1) & (2) & (3) & (4) \\ \hline" _n

	foreach i in $dummys {
		
		*** High
		* v3 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO if ingdummy==1, vce(cluster MUNICIPIO)
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
		
		* v3 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if ingdummy==1, vce(cluster MUNICIPIO)
		local y: di %4.3f `= _b[conflict_time2016]'
		global sey_`i': di %4.3f `= _se[conflict_time2016]'	
		local z: di %4.3f `= _b[conflict_time2020]'
		global sez_`i': di %4.3f `= _se[conflict_time2020]'
		local ty=_b[conflict_time2016]/_se[conflict_time2016]
		local tz=_b[conflict_time2020]/_se[conflict_time2020]
		local py= 2*ttail(`e(df_r)',abs(`ty'))
		local pz= 2*ttail(`e(df_r)',abs(`tz'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
		
		foreach n in y z {
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
		
		*** Low
		* v3 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO)
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
		
		* v3 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
	
		foreach n of numlist 0/1 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & ingdummy==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex17 "\textbf{`lab'} \\" _n
file write latex17 " Conflict x Time & ${ba_`i'} && ${bc_`i'} &  \\" _n
file write latex17 "  & (${sea_`i'})&& (${sec_`i'}) & \\" _n

file write latex17 " Conflict x 2016 && ${by_`i'} && ${bx_`i'} \\" _n
file write latex17 " && (${sey_`i'}) && (${sex_`i'}) \\" _n

file write latex17 " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} \\" _n
file write latex17 " && (${sez_`i'})&& (${sew_`i'})\\" _n

file write latex17 " Observations & ${N_`i'} & ${N2_`i'} & ${N3_`i'} & ${N4_`i'} \\" _n
file write latex17 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} \\" _n
file write latex17 " Pre-t treat. mean & ${m11_`i'} & ${m11_`i'} & ${m10_`i'} & ${m10_`i'} \\" _n
file write latex17 " Pre-t cont. mean & ${m01_`i'} & ${m01_`i'} & ${m00_`i'} & ${m00_`i'} \\" _n

file write latex17 "\hline" _n
	}
file write latex17 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex17 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex17 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex17 "\hline \hline" _n
file write latex17 "\end{tabular}" _n
file close latex17

* ----------------------------------------------------------------------
* VII.5 Region
* ----------------------------------------------------------------------*

*********************** v1 - OLS

file open latex18 using "${sale}/reg7c_v1.txt", write replace text
file write latex18 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex18 "\begin{tabular}{l c c c c c c} \\ \hline \hline" _n
file write latex18 "& \multicolumn{2}{c}{Central} & \multicolumn{2}{c}{Eastern} & \multicolumn{2}{c}{Pacific}\\" _n
file write latex18 " & (1) & (2) & (3) & (4) & (5) & (6) \\ \hline" _n

	foreach i in $ceros {
		
		*** Region 2
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if REGION==2, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if REGION==2, vce(cluster MUNICIPIO)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
		
		*** Region 3
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if REGION==3, vce(cluster MUNICIPIO)
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if REGION==3, vce(cluster MUNICIPIO)
		local u: di %4.3f `= _b[conflict_time2016]'
		global seu_`i': di %4.3f `= _se[conflict_time2016]'	
		local v: di %4.3f `= _b[conflict_time2020]'
		global sev_`i': di %4.3f `= _se[conflict_time2020]'
		local tu=_b[conflict_time2016]/_se[conflict_time2016]
		local tv=_b[conflict_time2020]/_se[conflict_time2020]
		local pu= 2*ttail(`e(df_r)',abs(`tu'))
		local pv= 2*ttail(`e(df_r)',abs(`tv'))
		global r26_`i': di %4.3f `= e(r2)'
		global N6_`i': di %9.0f `= e(N)'
		
		foreach n in u v {
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
		
		*** Region 4
		* v1 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if REGION==4, vce(cluster MUNICIPIO)
		local f: di %4.3f `= _b[conflict_time]'
		global sef_`i': di %4.3f `= _se[conflict_time]'
		local tf=_b[conflict_time]/_se[conflict_time]
		local pf= 2*ttail(`e(df_r)',abs(`tf'))
		global r27_`i': di %4.3f `= e(r2)'
		global N7_`i': di %9.0f `= e(N)'
		
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
		
		* v1 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if REGION==4, vce(cluster MUNICIPIO)
		local r: di %4.3f `= _b[conflict_time2016]'
		global ser_`i': di %4.3f `= _se[conflict_time2016]'	
		local s: di %4.3f `= _b[conflict_time2020]'
		global ses_`i': di %4.3f `= _se[conflict_time2020]'
		local tr=_b[conflict_time2016]/_se[conflict_time2016]
		local ts=_b[conflict_time2020]/_se[conflict_time2020]
		local pr= 2*ttail(`e(df_r)',abs(`tr'))
		local ps= 2*ttail(`e(df_r)',abs(`ts'))
		global r28_`i': di %4.3f `= e(r2)'
		global N8_`i': di %9.0f `= e(N)'
		
		foreach n in r s {
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

		foreach n of numlist 2/4 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & REGION==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex18 "\textbf{`lab'} \\" _n
file write latex18 " Conflict x Time & ${bc_`i'} && ${be_`i'} && ${bf_`i'} & \\" _n
file write latex18 "  & (${sec_`i'}) && (${see_`i'})&& (${sef_`i'})& \\" _n

file write latex18 " Conflict x 2016 && ${bx_`i'} && ${bu_`i'} && ${br_`i'}  \\" _n
file write latex18 " && (${sex_`i'}) && (${seu_`i'}) && (${ser_`i'}) \\" _n

file write latex18 " Conflict x 2020  && ${bw_`i'} && ${bv_`i'} && ${bs_`i'} \\" _n
file write latex18 " && (${sew_`i'}) && (${sev_`i'}) && (${ses_`i'}) \\" _n

file write latex18 " Observations & ${N3_`i'} & ${N4_`i'} & ${N5_`i'} & ${N6_`i'} & ${N7_`i'} & ${N8_`i'} \\" _n
file write latex18 " R-squared & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'}  \\" _n
file write latex18 " Pre-t. treat. mean & ${m12_`i'} & ${m12_`i'} & ${m13_`i'} & ${m13_`i'} & ${m14_`i'} & ${m14_`i'}  \\" _n
file write latex18 " Pre-t. cont. mean & ${m02_`i'} & ${m02_`i'} & ${m03_`i'} & ${m03_`i'} & ${m04_`i'} & ${m04_`i'}  \\" _n

file write latex18 "\hline" _n
	}
file write latex18 "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n	
file write latex18 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n	
file write latex18 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n			
file write latex18 "\hline \hline" _n
file write latex18 "\end{tabular}" _n
file close latex18

*********************** v2 - Tobit

file open latex20 using "${sale}/reg7c_v2.txt", write replace text
file write latex20 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex20 "\begin{tabular}{l c c c c c c} \\ \hline \hline" _n
file write latex20 "& \multicolumn{2}{c}{Central} & \multicolumn{2}{c}{Eastern} & \multicolumn{2}{c}{Pacific}\\" _n
file write latex20 " & (1) & (2) & (3) & (4) & (5) & (6) \\ \hline" _n

	foreach i in $ceros {
		
		*** Region 2
		* v2 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if REGION==2, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if REGION==2, vce(cluster MUNICIPIO) ll(0) ul(24)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
		
		*** Region 3
		* v1 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if REGION==3, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if REGION==3, vce(cluster MUNICIPIO) ll(0) ul(24)
		local u: di %4.3f `= _b[conflict_time2016]'
		global seu_`i': di %4.3f `= _se[conflict_time2016]'	
		local v: di %4.3f `= _b[conflict_time2020]'
		global sev_`i': di %4.3f `= _se[conflict_time2020]'
		local tu=_b[conflict_time2016]/_se[conflict_time2016]
		local tv=_b[conflict_time2020]/_se[conflict_time2020]
		local pu= 2*ttail(`e(df_r)',abs(`tu'))
		local pv= 2*ttail(`e(df_r)',abs(`tv'))
		global r26_`i': di %4.3f `= e(r2)'
		global N6_`i': di %9.0f `= e(N)'
		
		foreach n in u v {
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

		*** Region 4
		* v2 - Básica
		tobit `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if REGION==4, vce(cluster MUNICIPIO) ll(0) ul(24)
		local f: di %4.3f `= _b[conflict_time]'
		global sef_`i': di %4.3f `= _se[conflict_time]'
		local tf=_b[conflict_time]/_se[conflict_time]
		local pf= 2*ttail(`e(df_r)',abs(`tf'))
		global r27_`i': di %4.3f `= e(r2)'
		global N7_`i': di %9.0f `= e(N)'
		
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
		
		* v2 - Interacción por año
		tobit `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if REGION==4, vce(cluster MUNICIPIO) ll(0) ul(24)
		local r: di %4.3f `= _b[conflict_time2016]'
		global ser_`i': di %4.3f `= _se[conflict_time2016]'	
		local s: di %4.3f `= _b[conflict_time2020]'
		global ses_`i': di %4.3f `= _se[conflict_time2020]'
		local tr=_b[conflict_time2016]/_se[conflict_time2016]
		local ts=_b[conflict_time2020]/_se[conflict_time2020]
		local pr= 2*ttail(`e(df_r)',abs(`tr'))
		local ps= 2*ttail(`e(df_r)',abs(`ts'))
		global r28_`i': di %4.3f `= e(r2)'
		global N8_`i': di %9.0f `= e(N)'
		
		foreach n in r s {
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
	
		foreach n of numlist 2/4 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & REGION==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex20 "\textbf{`lab'} \\" _n
file write latex20 " Conflict x Time & ${bc_`i'} && ${be_`i'} && ${bf_`i'} & \\" _n
file write latex20 " & (${sec_`i'}) && (${see_`i'})&& (${sef_`i'})& \\" _n

file write latex20 " Conflict x 2016 && ${bx_`i'} && ${bu_`i'} && ${br_`i'}  \\" _n
file write latex20 " && (${sex_`i'}) && (${seu_`i'}) && (${ser_`i'}) \\" _n

file write latex20 " Conflict x 2020 && ${bw_`i'} && ${bv_`i'} && ${bs_`i'} \\" _n
file write latex20 " && (${sew_`i'}) && (${sev_`i'}) && (${ses_`i'}) \\" _n

file write latex20 " Observations & ${N3_`i'} & ${N4_`i'} & ${N5_`i'} & ${N6_`i'} & ${N7_`i'} & ${N8_`i'} \\" _n
file write latex20 " R-squared & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'}  \\" _n
file write latex20 " Pre-t. treat. mean & ${m12_`i'} & ${m12_`i'} & ${m13_`i'} & ${m13_`i'} & ${m14_`i'} & ${m14_`i'}  \\" _n
file write latex20 " Pre-t. cont. mean & ${m02_`i'} & ${m02_`i'} & ${m03_`i'} & ${m03_`i'} & ${m04_`i'} & ${m04_`i'}  \\" _n

file write latex20 "\hline" _n
	}
file write latex20 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n	
file write latex20 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n	
file write latex20 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n			
file write latex20 "\hline \hline" _n
file write latex20 "\end{tabular}" _n
file close latex20

*********************** v3 - Dummys

file open latex22 using "${sale}/reg7c_v3.txt", write replace text
file write latex22 "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex22 "\begin{tabular}{l c c c c c c} \\ \hline \hline" _n
file write latex22 " & \multicolumn{2}{c}{Central} & \multicolumn{2}{c}{Eastern} & \multicolumn{2}{c}{Pacific} \\" _n
file write latex22 " & (1) & (2) & (3) & (4) & (5) & (6)  \\ \hline" _n

	foreach i in $dummys {
		
		*** Region 2
		* v3 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if REGION==2, vce(cluster MUNICIPIO)
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
		
		* v3 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if REGION==2, vce(cluster MUNICIPIO)
		local x: di %4.3f `= _b[conflict_time2016]'
		global sex_`i': di %4.3f `= _se[conflict_time2016]'	
		local w: di %4.3f `= _b[conflict_time2020]'
		global sew_`i': di %4.3f `= _se[conflict_time2020]'
		local tx=_b[conflict_time2016]/_se[conflict_time2016]
		local tw=_b[conflict_time2020]/_se[conflict_time2020]
		local px= 2*ttail(`e(df_r)',abs(`tx'))
		local pw= 2*ttail(`e(df_r)',abs(`tw'))
		global r24_`i': di %4.3f `= e(r2)'
		global N4_`i': di %9.0f `= e(N)'
		
		foreach n in x w {
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
		
		*** Region 3
		* v3 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if REGION==3, vce(cluster MUNICIPIO)
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
		
		* v3 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if REGION==3, vce(cluster MUNICIPIO)
		local u: di %4.3f `= _b[conflict_time2016]'
		global seu_`i': di %4.3f `= _se[conflict_time2016]'	
		local v: di %4.3f `= _b[conflict_time2020]'
		global sev_`i': di %4.3f `= _se[conflict_time2020]'
		local tu=_b[conflict_time2016]/_se[conflict_time2016]
		local tv=_b[conflict_time2020]/_se[conflict_time2020]
		local pu= 2*ttail(`e(df_r)',abs(`tu'))
		local pv= 2*ttail(`e(df_r)',abs(`tv'))
		global r26_`i': di %4.3f `= e(r2)'
		global N6_`i': di %9.0f `= e(N)'
		
		foreach n in u v {
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

		*** Region 4
		* v2 - Básica
		reg `i' CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if REGION==4, vce(cluster MUNICIPIO)
		local f: di %4.3f `= _b[conflict_time]'
		global sef_`i': di %4.3f `= _se[conflict_time]'
		local tf=_b[conflict_time]/_se[conflict_time]
		local pf= 2*ttail(`e(df_r)',abs(`tf'))
		global r27_`i': di %4.3f `= e(r2)'
		global N7_`i': di %9.0f `= e(N)'
		
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
		
		* v2 - Interacción por año
		reg `i' CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if REGION==4, vce(cluster MUNICIPIO)
		local r: di %4.3f `= _b[conflict_time2016]'
		global ser_`i': di %4.3f `= _se[conflict_time2016]'	
		local s: di %4.3f `= _b[conflict_time2020]'
		global ses_`i': di %4.3f `= _se[conflict_time2020]'
		local tr=_b[conflict_time2016]/_se[conflict_time2016]
		local ts=_b[conflict_time2020]/_se[conflict_time2020]
		local pr= 2*ttail(`e(df_r)',abs(`tr'))
		local ps= 2*ttail(`e(df_r)',abs(`ts'))
		global r28_`i': di %4.3f `= e(r2)'
		global N8_`i': di %9.0f `= e(N)'
		
		foreach n in r s {
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
	
		foreach n of numlist 2/4 {
			foreach a of numlist 0/1 {
				sum `i' if TIME==0 & CONFLICT==`a' & REGION==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}

	
file write latex22 "\textbf{`lab'} \\" _n
file write latex22 " Conflict x Time & ${bc_`i'} && ${be_`i'} && ${bf_`i'} & \\" _n
file write latex22 " & (${sec_`i'}) && (${see_`i'})&& (${sef_`i'})& \\" _n

file write latex22 " Conflict x 2016 && ${bx_`i'} && ${bu_`i'} && ${br_`i'}  \\" _n
file write latex22 " && (${sex_`i'}) && (${seu_`i'}) && (${ser_`i'}) \\" _n

file write latex22 " Conflict x 2020 && ${bw_`i'} && ${bv_`i'} && ${bs_`i'} \\" _n
file write latex22 " && (${sew_`i'}) && (${sev_`i'}) && (${ses_`i'}) \\" _n

file write latex22 " Observations & ${N3_`i'} & ${N4_`i'} & ${N5_`i'} & ${N6_`i'} & ${N7_`i'} & ${N8_`i'} \\" _n
file write latex22 " R-squared  & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'}  \\" _n
file write latex22 " Pre-t. treat. mean & ${m12_`i'} & ${m12_`i'} & ${m13_`i'} & ${m13_`i'} & ${m14_`i'} & ${m14_`i'}  \\" _n
file write latex22 " Pre-t. cont. mean & ${m02_`i'} & ${m02_`i'} & ${m03_`i'} & ${m03_`i'} & ${m04_`i'} & ${m04_`i'}  \\" _n

file write latex22 "\hline" _n
	}
file write latex22 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n	
file write latex22 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n	
file write latex22 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n			
file write latex22 "\hline \hline" _n
file write latex22 "\end{tabular}" _n
file close latex22
	