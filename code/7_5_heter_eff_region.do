/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
7_5_heter_eff_region.do

This do file runs regression with heterogeneous effects
=========================================================================*/

	use "${enut}/ENUT_FARC_J.dta", clear
	
* =====================================================================
* VII. Efectos Heterogeneos Region

	* v1 - Básica
	* v2 - Tobit
	* v3 - Dummys
* =====================================================================

	foreach i in v4 v20 {
		gen `i'_c=`i'*TIME
	}

	gen dummyedad=.
	replace dummyedad=0 if EDAD<19
	replace dummyedad=1 if EDAD>=19 & EDAD<=23
	replace dummyedad=2 if EDAD>23

* ----------------------------------------------------------------------
* v1 - OLS
* ----------------------------------------------------------------------*

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

file write latex18 " R-squared & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'}  \\" _n
file write latex18 " Pre-t. treat. mean & ${m12_`i'} & ${m12_`i'} & ${m13_`i'} & ${m13_`i'} & ${m14_`i'} & ${m14_`i'}  \\" _n
file write latex18 " Pre-t. cont. mean & ${m02_`i'} & ${m02_`i'} & ${m03_`i'} & ${m03_`i'} & ${m04_`i'} & ${m04_`i'}  \\" _n

file write latex18 "\hline" _n
	}
file write latex18 "Observations & ${N3_MW} & ${N4_MW} & ${N5_MW} & ${N6_MW} & ${N7_MW} & ${N8_MW} \\" _n
file write latex18 "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n	
file write latex18 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n	
file write latex18 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n			
file write latex18 "\hline \hline" _n
file write latex18 "\end{tabular}" _n
file close latex18

* ----------------------------------------------------------------------
* v2 - Tobit
* ----------------------------------------------------------------------*

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

file write latex20 " R-squared & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'}  \\" _n
file write latex20 " Pre-t. treat. mean & ${m12_`i'} & ${m12_`i'} & ${m13_`i'} & ${m13_`i'} & ${m14_`i'} & ${m14_`i'}  \\" _n
file write latex20 " Pre-t. cont. mean & ${m02_`i'} & ${m02_`i'} & ${m03_`i'} & ${m03_`i'} & ${m04_`i'} & ${m04_`i'}  \\" _n

file write latex20 "\hline" _n
	}
file write latex20 "Observations & ${N3_MW} & ${N4_MW} & ${N5_MW} & ${N6_MW} & ${N7_MW} & ${N8_MW} \\" _n
file write latex20 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n	
file write latex20 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n	
file write latex20 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n			
file write latex20 "\hline \hline" _n
file write latex20 "\end{tabular}" _n
file close latex20

* ----------------------------------------------------------------------
* v3 - Dummys
* ----------------------------------------------------------------------*

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

file write latex22 " R-squared  & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'}  \\" _n
file write latex22 " Pre-t. treat. mean & ${m12_`i'} & ${m12_`i'} & ${m13_`i'} & ${m13_`i'} & ${m14_`i'} & ${m14_`i'}  \\" _n
file write latex22 " Pre-t. cont. mean & ${m02_`i'} & ${m02_`i'} & ${m03_`i'} & ${m03_`i'} & ${m04_`i'} & ${m04_`i'}  \\" _n

file write latex22 "\hline" _n
	}
file write latex22 "Observations & ${N3_MW} & ${N4_MW} & ${N5_MW} & ${N6_MW} & ${N7_MW} & ${N8_MW} \\" _n
file write latex22 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n	
file write latex22 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n	
file write latex22 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$\\" _n			
file write latex22 "\hline \hline" _n
file write latex22 "\end{tabular}" _n
file close latex22
	