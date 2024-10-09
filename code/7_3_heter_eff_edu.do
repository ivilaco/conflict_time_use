/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
7_3_heter_eff_edu.do

This do file runs regression with heterogeneous effects
=========================================================================*/

	use "${enut}/ENUT_FARC_J.dta", clear
	
* =====================================================================
* VII. Efectos Heterogeneos Educación Jefe del Hogar

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
* ---------------------------------------------------------------------*

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

file write latex12 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'}  \\" _n
file write latex12 " Pre-t treat. mean & ${m11_`i'} & ${m11_`i'} & ${m12_`i'} & ${m12_`i'} & ${m13_`i'} & ${m13_`i'} & ${m14_`i'} & ${m14_`i'}  \\" _n
file write latex12 " Pre-t cont. mean & ${m01_`i'} & ${m01_`i'} & ${m02_`i'} & ${m02_`i'} & ${m03_`i'} & ${m03_`i'} & ${m04_`i'} & ${m04_`i'}  \\" _n

file write latex12 "\hline" _n
	}
file write latex12 "Observations & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N4_MW} & ${N5_MW} & ${N6_MW} & ${N7_MW} & ${N8_MW} \\" _n
file write latex12 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex12 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex12 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex12 "\hline \hline" _n
file write latex12 "\end{tabular}" _n
file close latex12

* ----------------------------------------------------------------------
* v2 - Tobit
* ---------------------------------------------------------------------*

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

file write latex13 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'}  \\" _n
file write latex13 " Pre-t treat. mean & ${m11_`i'} & ${m11_`i'} & ${m12_`i'} & ${m12_`i'} & ${m13_`i'} & ${m13_`i'} & ${m14_`i'} & ${m14_`i'}  \\" _n
file write latex13 " Pre-t cont. mean & ${m01_`i'} & ${m01_`i'} & ${m02_`i'} & ${m02_`i'} & ${m03_`i'} & ${m03_`i'} & ${m04_`i'} & ${m04_`i'}  \\" _n

file write latex13 "\hline" _n
	}
file write latex13 "Observations & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N4_MW} & ${N5_MW} & ${N6_MW} & ${N7_MW} & ${N8_MW} \\" _n
file write latex13 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex13 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex13 "Control & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex13 "\hline \hline" _n
file write latex13 "\end{tabular}" _n
file close latex13

* ----------------------------------------------------------------------
* v3 - Dummys
* ---------------------------------------------------------------------*

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

file write latex14 " R-squared & ${r2_`i'} & ${r22_`i'} & ${r23_`i'} & ${r24_`i'} & ${r25_`i'} & ${r26_`i'} & ${r27_`i'} & ${r28_`i'}  \\" _n
file write latex14 " Pre-t treat. mean & ${m11_`i'} & ${m11_`i'} & ${m12_`i'} & ${m12_`i'} & ${m13_`i'} & ${m13_`i'} & ${m14_`i'} & ${m14_`i'}  \\" _n
file write latex14 " Pre-t cont. mean & ${m01_`i'} & ${m01_`i'} & ${m02_`i'} & ${m02_`i'} & ${m03_`i'} & ${m03_`i'} & ${m04_`i'} & ${m04_`i'}  \\" _n

file write latex14 "\hline" _n
	}
file write latex14 "Observations & ${N_MW} & ${N2_MW} & ${N3_MW} & ${N4_MW} & ${N5_MW} & ${N6_MW} & ${N7_MW} & ${N8_MW} \\" _n
file write latex14 "Year FE  & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
file write latex14 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex14 "Controls & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n		
file write latex14 "\hline \hline" _n
file write latex14 "\end{tabular}" _n
file close latex14
