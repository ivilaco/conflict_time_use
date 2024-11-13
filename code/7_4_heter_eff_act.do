/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
7_4_heter_eff_act.do

This do file runs regression with heterogeneous effects
=========================================================================*/

	use "${enut}/ENUT_FARC_J.dta", clear
	
* =====================================================================
* VII. Efectos heterogeneos Tenencia de Activos

	* v1 - Básica
	* v2 - Tobit
	* v3 - Dummys
* =====================================================================

	foreach i in v4 v20 {
		gen `i'_c=`i'*TIME
	}

* ----------------------------------------------------------------------
* v1 - OLS
* ----------------------------------------------------------------------
	
file open latex using "${sale}/reg6c_v1.txt", write replace text
file write latex "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex "\begin{tabular}{l c c c c} \\ \hline \hline" _n
file write latex "& \multicolumn{2}{c}{Lower possession} & \multicolumn{2}{c}{Higher possession} \\" _n
file write latex "& (1) & (2) & (3) & (4)  \\ \hline" _n

* v1 - Básica (OLS) Modelo 1 Rwolf, ingdummy 1
	qui rwolf2 (reg MWc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg NW1c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg NW2c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg NW3c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg CHc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg CUc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global rw1_MW: di %4.3f `= e(RW)[1,3]'
		global rw1_NW1: di %4.3f `= e(RW)[2,3]'
		global rw1_NW2: di %4.3f `= e(RW)[3,3]'
		global rw1_NW3: di %4.3f `= e(RW)[4,3]'
		global rw1_CH: di %4.3f `= e(RW)[5,3]'
		global rw1_CU: di %4.3f `= e(RW)[6,3]'

	* v1 - Interacción por año (OLS) Modelo 2 y 3 Rwolf, ingdummy 1
	qui rwolf2 (reg MWc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg NW1c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg NW2c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg NW3c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg CHc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg CUc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)), ///
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

	* v2 - Básica (OLS) Modelo 4 Rwolf, ingdummy 2
	qui rwolf2 (reg MWc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg NW1c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg NW2c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg NW3c conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg CHc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg CUc conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global rw4_MW: di %4.3f `= e(RW)[1,3]'
		global rw4_NW1: di %4.3f `= e(RW)[2,3]'
		global rw4_NW2: di %4.3f `= e(RW)[3,3]'
		global rw4_NW3: di %4.3f `= e(RW)[4,3]'
		global rw4_CH: di %4.3f `= e(RW)[5,3]'
		global rw4_CU: di %4.3f `= e(RW)[6,3]'
		
	* v2 - Interacción por año (OLS) Modelo 5 y 6 Rwolf, ingdummy 2
	qui rwolf2 (reg MWc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg NW1c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg NW2c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg NW3c TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg CHc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg CUc TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)), ///
	indepvars(conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020) reps(1000) seed(12345)
	
		* 2016
		global rw5_MW: di %4.3f `= e(RW)[1,3]'
		global rw5_NW1: di %4.3f `= e(RW)[3,3]'
		global rw5_NW2: di %4.3f `= e(RW)[5,3]'
		global rw5_NW3: di %4.3f `= e(RW)[7,3]'
		global rw5_CH: di %4.3f `= e(RW)[9,3]'
		global rw5_CU: di %4.3f `=  e(RW)[11,3]'

		* 2020
		global rw6_MW: di %4.3f `= e(RW)[2,3]'
		global rw6_NW1: di %4.3f `= e(RW)[4,3]'
		global rw6_NW2: di %4.3f `= e(RW)[6,3]'
		global rw6_NW3: di %4.3f `= e(RW)[8,3]'
		global rw6_CH: di %4.3f `= e(RW)[10,3]'
		global rw6_CU: di %4.3f `= e(RW)[12,3]'

	foreach i in $out {
		
		*** High
		* v1 - Básica
		reg `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if ingdummy==1, vce(cluster MUNICIPIO)
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
		reg `i'c CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if ingdummy==1, vce(cluster MUNICIPIO)
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
		reg `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO)
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
		reg `i'c CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO)
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
		
	local lab: variable label `i'c
	
		foreach n of numlist 0/1 {
			foreach a of numlist 0/1 {
				sum `i'c if TIME==0 & CONFLICT==`a' & ingdummy==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex "\textbf{`lab'} \\" _n
file write latex " Conflict x Time & ${ba_`i'} && ${bc_`i'} &  \\" _n
file write latex "  & (${sea_`i'})&& (${sec_`i'}) & \\" _n
file write latex "  & [${rw1_`i'}]&& [${rw4_`i'}] & \\" _n

file write latex " Conflict x 2016 && ${by_`i'} && ${bx_`i'} \\" _n
file write latex " && (${sey_`i'}) && (${sex_`i'}) \\" _n
file write latex " && [${rw2_`i'}] && [${rw5_`i'}] \\" _n

file write latex " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} \\" _n
file write latex " && (${sez_`i'})&& (${sew_`i'}) \\" _n
file write latex " && [${rw3_`i'}]&& [${rw6_`i'}] \\" _n

file write latex " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} \\" _n
file write latex " Pre-t treat. mean & ${m11_`i'} & ${m11_`i'} & ${m10_`i'} & ${m10_`i'} \\" _n
file write latex " Pre-t cont. mean & ${m01_`i'} & ${m01_`i'} & ${m00_`i'} & ${m00_`i'} \\" _n

file write latex "\hline" _n
	}
file write latex "Observations & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N4_MW} \\" _n
file write latex "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex "\hline \hline" _n
file write latex "\end{tabular}" _n
file close latex

* ----------------------------------------------------------------------
* v2 - Tobit
* ----------------------------------------------------------------------

file open latex using "${sale}/reg6c_v2.txt", write replace text
file write latex "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex "\begin{tabular}{l c c c c} \\ \hline \hline" _n
file write latex "& \multicolumn{2}{c}{Lower possession} & \multicolumn{2}{c}{Higher possession} \\" _n
file write latex "& (1) & (2) & (3) & (4)  \\ \hline" _n

	* v1 - Básica (Tobit) Modelo 1 wyoung & sidak, ingdummy 1
	qui wyoung $ceros, cmd(tobit OUTCOMEVAR conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if ingdummy==1, vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time) cluster(MUNICIPIO) bootstraps(100) seed(12345)
		
		* wyoung 
		global rw1_MW: di %4.3f `= r(table)[1,4]'
		global rw1_NW1: di %4.3f `= r(table)[2,4]'
		global rw1_NW2: di %4.3f `= r(table)[3,4]'
		global rw1_NW3: di %4.3f `= r(table)[4,4]'
		global rw1_CH: di %4.3f `= r(table)[5,4]'
		global rw1_CU: di %4.3f `= r(table)[6,4]'
		
		* Sidak
		global rw1_MW_s: di %4.3f `= r(table)[1,6]'
		global rw1_NW1_s: di %4.3f `= r(table)[2,6]'
		global rw1_NW2_s: di %4.3f `= r(table)[3,6]'
		global rw1_NW3_s: di %4.3f `= r(table)[4,6]'
		global rw1_CH_s: di %4.3f `= r(table)[5,6]'
		global rw1_CU_s: di %4.3f `= r(table)[6,6]'

	* v1 - Interacción por año (Tobit) Modelo 2 y 3 wyoung & sidak, ingdummy 1
	qui wyoung $ceros, cmd(tobit OUTCOMEVAR conflict_time2016 conflict_time2020 CONFLICT TIME2016 TIME2020 i.ANNO i.MUNICIPIO $controls if ingdummy==1, vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time2016 conflict_time2020) cluster(MUNICIPIO) bootstraps(100) seed(12345)
		
		* wyoung

			* 2016
			global rw2_MW: di %4.3f `= r(table)[1,4]'
			global rw2_NW1: di %4.3f `= r(table)[2,4]'
			global rw2_NW2: di %4.3f `= r(table)[3,4]'
			global rw2_NW3: di %4.3f `= r(table)[4,4]'
			global rw2_CH: di %4.3f `= r(table)[5,4]'
			global rw2_CU: di %4.3f `=  r(table)[6,4]'

			* 2020
			global rw3_MW: di %4.3f `= r(table)[7,4]'
			global rw3_NW1: di %4.3f `= r(table)[8,4]'
			global rw3_NW2: di %4.3f `= r(table)[9,4]'
			global rw3_NW3: di %4.3f `= r(table)[10,4]'
			global rw3_CH: di %4.3f `= r(table)[11,4]'
			global rw3_CU: di %4.3f `= r(table)[12,4]'
			
		* Sidak

			* 2016
			global rw2_MW_s: di %4.3f `= r(table)[1,6]'
			global rw2_NW1_s: di %4.3f `= r(table)[2,6]'
			global rw2_NW2_s: di %4.3f `= r(table)[3,6]'
			global rw2_NW3_s: di %4.3f `= r(table)[4,6]'
			global rw2_CH_s: di %4.3f `= r(table)[5,6]'
			global rw2_CU_s: di %4.3f `=  r(table)[6,6]'

			* 2020
			global rw3_MW_s: di %4.3f `= r(table)[7,6]'
			global rw3_NW1_s: di %4.3f `= r(table)[8,6]'
			global rw3_NW2_s: di %4.3f `= r(table)[9,6]'
			global rw3_NW3_s: di %4.3f `= r(table)[10,6]'
			global rw3_CH_s: di %4.3f `= r(table)[11,6]'
			global rw3_CU_s: di %4.3f `= r(table)[12,6]'

	* v2 - Básica (Tobit) Modelo 4 wyoung & sidak, ingdummy 2
	qui wyoung $ceros, cmd(tobit OUTCOMEVAR conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time) cluster(MUNICIPIO) bootstraps(100) seed(12345)
		
		* wyoung 
		global rw4_MW: di %4.3f `= r(table)[1,4]'
		global rw4_NW1: di %4.3f `= r(table)[2,4]'
		global rw4_NW2: di %4.3f `= r(table)[3,4]'
		global rw4_NW3: di %4.3f `= r(table)[4,4]'
		global rw4_CH: di %4.3f `= r(table)[5,4]'
		global rw4_CU: di %4.3f `= r(table)[6,4]'
		
		* Sidak
		global rw4_MW_s: di %4.3f `= r(table)[1,6]'
		global rw4_NW1_s: di %4.3f `= r(table)[2,6]'
		global rw4_NW2_s: di %4.3f `= r(table)[3,6]'
		global rw4_NW3_s: di %4.3f `= r(table)[4,6]'
		global rw4_CH_s: di %4.3f `= r(table)[5,6]'
		global rw4_CU_s: di %4.3f `= r(table)[6,6]'

	* v2 - Interacción por año (Tobit) Modelo 5 y 6 wyoung & sidak, ingdummy 2
	qui wyoung $ceros, cmd(tobit OUTCOMEVAR conflict_time2016 conflict_time2020 CONFLICT TIME2016 TIME2020 i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO) ll(0) ul(24)) familyp(conflict_time2016 conflict_time2020) cluster(MUNICIPIO) bootstraps(100) seed(12345)
		
		* wyoung

			* 2016
			global rw5_MW: di %4.3f `= r(table)[1,4]'
			global rw5_NW1: di %4.3f `= r(table)[2,4]'
			global rw5_NW2: di %4.3f `= r(table)[3,4]'
			global rw5_NW3: di %4.3f `= r(table)[4,4]'
			global rw5_CH: di %4.3f `= r(table)[5,4]'
			global rw5_CU: di %4.3f `=  r(table)[6,4]'

			* 2020
			global rw6_MW: di %4.3f `= r(table)[7,4]'
			global rw6_NW1: di %4.3f `= r(table)[8,4]'
			global rw6_NW2: di %4.3f `= r(table)[9,4]'
			global rw6_NW3: di %4.3f `= r(table)[10,4]'
			global rw6_CH: di %4.3f `= r(table)[11,4]'
			global rw6_CU: di %4.3f `= r(table)[12,4]'
			
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

	foreach i in $out {
		
		*** High
		* v2 - Básica
		tobit `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if ingdummy==1, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		tobit `i'c CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if ingdummy==1, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		tobit `i'c CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		tobit `i'c CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO) ll(0) ul(24)
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
		
	local lab: variable label `i'c
	
		foreach n of numlist 0/1 {
			foreach a of numlist 0/1 {
				sum `i'c if TIME==0 & CONFLICT==`a' & ingdummy==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex "\textbf{`lab'} \\" _n
file write latex " Conflict x Time & ${ba_`i'} && ${bc_`i'} &  \\" _n
file write latex "  & (${sea_`i'})&& (${sec_`i'}) & \\" _n
file write latex "  & \{${rw1_`i'}\} && \{${rw4_`i'}\} & \\" _n
file write latex "  & <${rw1_`i'_s}> && <${rw4_`i'_s}> & \\" _n

file write latex " Conflict x 2016 && ${by_`i'} && ${bx_`i'} \\" _n
file write latex " && (${sey_`i'}) && (${sex_`i'}) \\" _n
file write latex " && \{${rw2_`i'}\} && \{${rw5_`i'}\} \\" _n
file write latex " && <${rw2_`i'_s}> && <${rw5_`i'_s}> \\" _n

file write latex " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} \\" _n
file write latex " && (${sez_`i'})&& (${sew_`i'}) \\" _n
file write latex " && \{${rw3_`i'}\} && \{${rw6_`i'}\} \\" _n
file write latex " && <${rw3_`i'_s}> && <${rw6_`i'_s}> \\" _n

*file write latex " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} \\" _n
file write latex " Pre-t treat. mean & ${m11_`i'} & ${m11_`i'} & ${m10_`i'} & ${m10_`i'} \\" _n
file write latex " Pre-t cont. mean & ${m01_`i'} & ${m01_`i'} & ${m00_`i'} & ${m00_`i'} \\" _n

file write latex "\hline" _n
	}
file write latex "Observations & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N4_MW} \\" _n
file write latex "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex "Control & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex "\hline \hline" _n
file write latex "\end{tabular}" _n
file close latex

* ----------------------------------------------------------------------
* v3 - Dummys
* ----------------------------------------------------------------------

file open latex using "${sale}/reg6c_v3.txt", write replace text
file write latex "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write latex "\begin{tabular}{l c c c c} \\ \hline \hline" _n
file write latex "& \multicolumn{2}{c}{Lower possession} & \multicolumn{2}{c}{Higher possession} \\" _n
file write latex "& (1) & (2) & (3) & (4) \\ \hline" _n

	* v1 - Básica (OLS) Modelo 1 Rwolf, ingdummy 1
	qui rwolf2 (reg MWd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg NW1d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg NW2d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg NW3d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg CHd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg CUd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global rw1_MW: di %4.3f `= e(RW)[1,3]'
		global rw1_NW1: di %4.3f `= e(RW)[2,3]'
		global rw1_NW2: di %4.3f `= e(RW)[3,3]'
		global rw1_NW3: di %4.3f `= e(RW)[4,3]'
		global rw1_CH: di %4.3f `= e(RW)[5,3]'
		global rw1_CU: di %4.3f `= e(RW)[6,3]'

	* v1 - Interacción por año (OLS) Modelo 2 y 3 Rwolf, ingdummy 1
	qui rwolf2 (reg MWd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg NW1d TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg NW2d TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg NW3d TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg CHd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)) ///
	(reg CUd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==1, cluster(MUNICIPIO)), ///
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

	* v2 - Básica (OLS) Modelo 4 Rwolf, ingdummy 1
	qui rwolf2 (reg MWd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg NW1d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg NW2d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg NW3d conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg CHd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg CUd conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)), ///
	indepvars(conflict_time, conflict_time, conflict_time, conflict_time, conflict_time, conflict_time) reps(1000) seed(12345)
		
		global rw4_MW: di %4.3f `= e(RW)[1,3]'
		global rw4_NW1: di %4.3f `= e(RW)[2,3]'
		global rw4_NW2: di %4.3f `= e(RW)[3,3]'
		global rw4_NW3: di %4.3f `= e(RW)[4,3]'
		global rw4_CH: di %4.3f `= e(RW)[5,3]'
		global rw4_CU: di %4.3f `= e(RW)[6,3]'
		
	* v2 - Interacción por año (OLS) Modelo 5 y 6 Rwolf, ingdummy 1
	qui rwolf2 (reg MWd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg NW1d TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg NW2d TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg NW3d TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg CHd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)) ///
	(reg CUd TIME2016 TIME2020 conflict_time2016 conflict_time2020 CONFLICT i.ANNO i.MUNICIPIO  $controls if ingdummy==0, cluster(MUNICIPIO)), ///
	indepvars(conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020, conflict_time2016 conflict_time2020) reps(1000) seed(12345)
	
		* 2016
		global rw5_MW: di %4.3f `= e(RW)[1,3]'
		global rw5_NW1: di %4.3f `= e(RW)[3,3]'
		global rw5_NW2: di %4.3f `= e(RW)[5,3]'
		global rw5_NW3: di %4.3f `= e(RW)[7,3]'
		global rw5_CH: di %4.3f `= e(RW)[9,3]'
		global rw5_CU: di %4.3f `=  e(RW)[11,3]'

		* 2020
		global rw6_MW: di %4.3f `= e(RW)[2,3]'
		global rw6_NW1: di %4.3f `= e(RW)[4,3]'
		global rw6_NW2: di %4.3f `= e(RW)[6,3]'
		global rw6_NW3: di %4.3f `= e(RW)[8,3]'
		global rw6_CH: di %4.3f `= e(RW)[10,3]'
		global rw6_CU: di %4.3f `= e(RW)[12,3]'

	foreach i in $out {
		
		*** High
		* v3 - Básica
		reg `i'd CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO if ingdummy==1, vce(cluster MUNICIPIO)
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
		reg `i'd CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if ingdummy==1, vce(cluster MUNICIPIO)
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
		reg `i'd CONFLICT TIME conflict_time i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO)
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
		reg `i'd CONFLICT TIME2016 TIME2020 conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO $controls if ingdummy==0, vce(cluster MUNICIPIO)
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
		
	local lab: variable label `i'd
	
		foreach n of numlist 0/1 {
			foreach a of numlist 0/1 {
				sum `i'd if TIME==0 & CONFLICT==`a' & ingdummy==`n', d 
				global m`a'`n'_`i': di %10.2f `= r(mean)'
			}
		}
	
file write latex "\textbf{`lab'} \\" _n
file write latex " Conflict x Time & ${ba_`i'} && ${bc_`i'} &  \\" _n
file write latex "  & (${sea_`i'})&& (${sec_`i'}) & \\" _n
file write latex "  & [${rw1_`i'}]&& [${rw4_`i'}] & \\" _n

file write latex " Conflict x 2016 && ${by_`i'} && ${bx_`i'} \\" _n
file write latex " && (${sey_`i'}) && (${sex_`i'}) \\" _n
file write latex " && [${rw2_`i'}] && [${rw5_`i'}] \\" _n

file write latex " Conflict x 2020 && ${bz_`i'} && ${bw_`i'} \\" _n
file write latex " && (${sez_`i'})&& (${sew_`i'}) \\" _n
file write latex " && [${rw3_`i'}]&& [${rw6_`i'}] \\" _n

file write latex " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} \\" _n
file write latex " Pre-t treat. mean & ${m11_`i'} & ${m11_`i'} & ${m10_`i'} & ${m10_`i'} \\" _n
file write latex " Pre-t cont. mean & ${m01_`i'} & ${m01_`i'} & ${m00_`i'} & ${m00_`i'} \\" _n

file write latex "\hline" _n
	}
file write latex "Observations & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N4_MW} \\" _n
file write latex "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex "\hline \hline" _n
file write latex "\end{tabular}" _n
file close latex
