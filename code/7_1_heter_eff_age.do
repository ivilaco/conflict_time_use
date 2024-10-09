/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
7_1_heter_eff_age.do

This do file runs regression with heterogeneous effects
=========================================================================*/

	use "${enut}/ENUT_FARC_J.dta", clear
	
* =====================================================================
* VII. Efectos Heterogeneos Grupos de Edad

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

* ---------------------------------------------------------------------
* v1 - OLS
* ---------------------------------------------------------------------
	
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

file write latex3 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'}  \\" _n
file write latex3 " Pre-t. treat. mean & ${m10_`i'} & ${m10_`i'} & ${m11_`i'} & ${m11_`i'} & ${m12_`i'} & ${m12_`i'}  \\" _n
file write latex3 " Pre-t. cont. mean & ${m00_`i'} & ${m00_`i'} & ${m01_`i'} & ${m01_`i'} & ${m02_`i'} & ${m02_`i'}  \\" _n

file write latex3 "\hline" _n
	}
file write latex3 " Observations & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N4_MW} & ${N5_MW} & ${N6_MW} \\" _n
file write latex3 "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex3 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex3 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex3 "\hline \hline" _n
file write latex3 "\end{tabular}" _n
file close latex3

* ---------------------------------------------------------------------
* v2 - Tobit
* ---------------------------------------------------------------------

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

file write latex4 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'}  \\" _n
file write latex4 " Pre-t. treat. mean & ${m10_`i'} & ${m10_`i'} & ${m11_`i'} & ${m11_`i'} & ${m12_`i'} & ${m12_`i'}  \\" _n
file write latex4 " Pre-t. cont. mean & ${m00_`i'} & ${m00_`i'} & ${m01_`i'} & ${m01_`i'} & ${m02_`i'} & ${m02_`i'}  \\" _n

file write latex4 "\hline" _n
	}
file write latex4 " Observations & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N4_MW} & ${N5_MW} & ${N6_MW} \\" _n
file write latex4 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex4 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex4 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex4 "\hline \hline" _n
file write latex4 "\end{tabular}" _n
file close latex4

* ---------------------------------------------------------------------
* v3 - Dummys
* ---------------------------------------------------------------------

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

file write latex5 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'}  \\" _n
file write latex5 " Pre-t. treat. mean & ${m10_`i'} & ${m10_`i'} & ${m11_`i'} & ${m11_`i'} & ${m12_`i'} & ${m12_`i'}  \\" _n
file write latex5 " Pre-t. cont. mean & ${m00_`i'} & ${m00_`i'} & ${m01_`i'} & ${m01_`i'} & ${m02_`i'} & ${m02_`i'}  \\" _n

file write latex5 "\hline" _n
	}
file write latex5 " Observations & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N4_MW} & ${N5_MW} & ${N6_MW} \\" _n
file write latex5 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex5 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex5 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex5 "\hline \hline" _n
file write latex5 "\end{tabular}" _n
file close latex5
	
	