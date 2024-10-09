/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
7_2_heter_eff_gender.do

This do file runs regression with heterogeneous effects
=========================================================================*/

	use "${enut}/ENUT_FARC_J.dta", clear
	
* =====================================================================
* VII. Efectos Heterogeneos Genero

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
	
* ------------------------------------------------------
* v1 - OLS
* ------------------------------------------------------
	
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
file write latex6 " Observations & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N4_MW} \\" _n
file write latex6 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex6 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex6 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex6 "\hline \hline" _n
file write latex6 "\end{tabular}" _n
file close latex6

* ------------------------------------------------------
* v2 - Tobit
* ------------------------------------------------------

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

file write latex7 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} \\" _n
file write latex7 " Pre-t. treat. mean & ${m11_`i'} & ${m11_`i'} & ${m10_`i'} & ${m10_`i'} \\" _n
file write latex7 " Pre-t. cont. mean & ${m01_`i'} & ${m01_`i'} & ${m00_`i'} & ${m00_`i'}  \\" _n

file write latex7 "\hline" _n
	}
file write latex7 " Observations & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N4_MW} \\" _n
file write latex7 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex7 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex7 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex7 "\hline \hline" _n
file write latex7 "\end{tabular}" _n
file close latex7

* ------------------------------------------------------
* v3 - Dummys
* ------------------------------------------------------

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

file write latex8 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} \\" _n
file write latex8 " Pre-t. treat. mean & ${m11_`i'} & ${m11_`i'} & ${m10_`i'} & ${m10_`i'} \\" _n
file write latex8 " Pre-t. cont. mean & ${m01_`i'} & ${m01_`i'} & ${m00_`i'} & ${m00_`i'}  \\" _n

file write latex8 "\hline" _n
	}
file write latex8 "Observations & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N4_MW} \\" _n
file write latex8 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex8 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex8 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex8 "\hline \hline" _n
file write latex8 "\end{tabular}" _n
file close latex8

	