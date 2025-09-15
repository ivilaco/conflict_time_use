/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
8_2_mechanisms.do

This do file runs mechanism 2 - Household Composition
=========================================================================*/
	
*******************************************
*** Mechanism 2: Household Composition ***
*******************************************

	use "${data}/coded/enut/ENUT_FARC_J.dta", clear 
	keep idhogar
	duplicates drop idhogar, force

	merge 1:m idhogar using "${data}/coded/enut/ENUT_FARC_ALL.dta"
	keep if _merge == 3
	drop _merge
		
	* We collapse at hh and time level
	collapse (mean) hht* hdist p_hhs_jm p_hhs_c CONFLICT ANNO MUNICIPIO p_hhth p_hhthj p_hdist TIME2016 TIME2020 [pw=F_EXP], by(idhogar TIME)
	gen conflict_time = CONFLICT*TIME
	gen conflict_time2016 = CONFLICT*TIME2016
	gen conflict_time2020 = CONFLICT*TIME2020
	
	foreach i in p_hhth p_hhthj hht p_hdist p_hhs_jm p_hhs_c {
		replace `i'=0 if `i'==.
	}

	* Regresion
	file open latex using "${sale}/mecanismos1.txt", write replace text
	file write latex "\begin{tabular}{l c c c c c c c c c c c c} \\ \hline \hline" _n
	file write latex "& \multicolumn{2}{c}{HH size} & \multicolumn{2}{c}{\% males} & \multicolumn{2}{c}{\% young males} & \multicolumn{2}{c}{\% disabled} & \multicolumn{2}{c}{\% female head} & \multicolumn{2}{c}{\% spouse presente} \\ " _n
	file write latex "& (1) & (2) & (1) & (2) & (1) & (2) & (1) & (2) & (1) & (2) & (1) & (2) \\ \hline" _n

	foreach i in p_hhth p_hhthj hht p_hdist p_hhs_jm p_hhs_c {
		
		* Conflict x time all
		reg `i' conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO, vce(cluster MUNICIPIO)
		local a: di %4.3f `= _b[conflict_time]'
		local b: di %4.3f `= _b[CONFLICT]'
		local c: di %4.3f `= _b[TIME]'
		global sea_`i': di %4.3f `= _se[conflict_time]'
		global seb_`i': di %4.3f `= _se[CONFLICT]'
		global sec_`i': di %4.3f `= _se[TIME]'
		local ta=_b[conflict_time]/_se[conflict_time]
		local tb=_b[CONFLICT]/_se[CONFLICT]
		local tc=_b[TIME]/_se[TIME]
		local pa= 2*ttail(`e(df_r)',abs(`ta'))
		local pb= 2*ttail(`e(df_r)',abs(`tb'))
		local pc= 2*ttail(`e(df_r)',abs(`tc'))
		global r2_`i': di %4.3f `= e(r2)'
		global N_`i': di %9.0f `= e(N)'
			
			foreach n in a b c {
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
			
			
		* Conflict x years
		reg `i' conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO, vce(cluster MUNICIPIO)
		local d: di %4.3f `= _b[conflict_time2016]'
		local e: di %4.3f `= _b[conflict_time2020]'
		global sed_`i': di %4.3f `= _se[conflict_time2016]'
		global see_`i': di %4.3f `= _se[conflict_time2020]'
		local td=_b[conflict_time2016]/_se[conflict_time2016]
		local te=_b[conflict_time2020]/_se[conflict_time2020]
		local pd= 2*ttail(`e(df_r)',abs(`td'))
		local pe= 2*ttail(`e(df_r)',abs(`te'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
			
			foreach n in d e {
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

		sum `i', d 
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(sd)'
			
	}
	
	file write latex " Conflict x Time & ${ba_hht} && ${ba_p_hhth} && ${ba_p_hhthj} && ${ba_p_hdist} && ${ba_p_hhs_jm} && ${ba_p_hhs_c} & \\" _n
	file write latex "  & (${sea_hht}) && (${sea_p_hhth}) && (${sea_p_hhthj}) && (${sea_p_hdist}) && (${sea_p_hhs_jm}) && (${sea_p_hhs_c}) & \\" _n

	file write latex " Conflict x 2016 && ${bd_hht} && ${bd_p_hhth} && ${bd_p_hhthj} && ${bd_p_hdist} && ${bd_p_hhs_jm} && ${bd_p_hhs_c} \\" _n
	file write latex "  && (${sed_hht}) && (${sed_p_hhth}) && (${sed_p_hhthj}) && (${sed_p_hdist}) && (${sed_p_hhs_jm}) && (${sed_p_hhs_c}) \\" _n
	
	file write latex " Conflict x 2020 && ${be_hht} && ${be_p_hhth} && ${be_p_hhthj} && ${be_p_hdist}&& ${be_p_hhs_jm} && ${be_p_hhs_c} \\" _n
	file write latex "  && (${see_hht}) && (${see_p_hhth}) && (${see_p_hhthj}) && (${see_p_hdist}) && (${see_p_hhs_jm}) && (${see_p_hhs_c}) \\" _n
	
	file write latex " Conflict & ${bb_hht} && ${bb_p_hhth} && ${bb_p_hhthj} && ${bb_p_hdist} && ${bb_p_hhs_jm} && ${bb_p_hhs_c} & \\" _n
	file write latex "  & (${seb_hht}) && (${seb_p_hhth}) && (${seb_p_hhthj}) && (${seb_p_hdist}) && (${seb_p_hhs_jm}) & & (${seb_p_hhs_c}) &  \\" _n

	file write latex " Time & ${bc_hht} && ${bc_p_hhth} && ${bc_p_hhthj} && ${bc_p_hdist} && ${bc_p_hhs_jm} && ${bc_p_hhs_c} & \\" _n
	file write latex "  & (${sec_hht}) && (${sec_p_hhth}) && (${sec_p_hhthj}) && (${sec_p_hdist}) && (${sec_p_hhs_jm}) && (${sec_p_hhs_c}) & \\" _n

	file write latex " Observations & ${N_hht} & ${N2_hht} & ${N_p_hhth} & ${N2_p_hhth} & ${N_p_hhthj} & ${N2_p_hhthj} & ${N_p_hdist} & ${N2_p_hdist} & ${N_p_hhs_jm} & ${N2_p_hhs_jm} & ${N_p_hhs_c} & ${N2_p_hhs_c} \\" _n
	file write latex " R-squared & ${r2_hht} & ${r22_hht} & ${r2_p_hhth} & ${r22_p_hhth} & ${r2_p_hhthj} & ${r22_p_hhthj} & ${r2_p_hdist} & ${r22_p_hdist} & ${r2_p_hhs_jm} & ${r22_p_hhs_jm} & ${r2_p_hhs_c} & ${r22_p_hhs_c} \\" _n
	file write latex "\hline" _n

	file write latex "Mean & ${m1_hht} & ${m1_hht} & ${m1_p_hhth}  & ${m1_p_hhth} & ${m1_p_hhthj} & ${m1_p_hhthj} & ${m1_p_hdist} & ${m1_p_hdist} & ${m1_p_hhs_jm} & ${m1_p_hhs_jm} & ${m1_p_hhs_c} & ${m1_p_hhs_c} \\" _n
	file write latex "Std. Dev. & ${p1_hht} & ${p1_hht} & ${p1_p_hhth} & ${p1_p_hhth} & ${p1_p_hhthj} & ${p1_p_hhthj} & ${p1_p_hdist} & ${p1_p_hdist} & ${p1_p_hhs_jm} & ${p1_p_hhs_jm} & ${p1_p_hhs_c} & ${p1_p_hhs_c} \\" _n
	file write latex "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
	file write latex "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n			
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
	
*******************************************
*** Mechanism 2: Household Composition - ALL ***
*******************************************

	use "${data}/coded/enut/ENUT_FARC_ALL.dta", clear 

	* We collapse at hh and time level
	collapse (mean) hht* hdist p_hhs_jm p_hhs_c CONFLICT ANNO MUNICIPIO p_hhth p_hhthj p_hdist TIME2016 TIME2020 [pw=F_EXP], by(idhogar TIME)
	gen conflict_time = CONFLICT*TIME
	gen conflict_time2016 = CONFLICT*TIME2016
	gen conflict_time2020 = CONFLICT*TIME2020
	
	foreach i in p_hhth p_hhthj hht p_hdist p_hhs_jm p_hhs_c {
		replace `i'=0 if `i'==.
	}

	* Regresion
	file open latex using "${sale}/mecanismos1_all.txt", write replace text
	file write latex "\begin{tabular}{l c c c c c c c c c c c c} \\ \hline \hline" _n
	file write latex "& \multicolumn{2}{c}{HH size} & \multicolumn{2}{c}{\% males} & \multicolumn{2}{c}{\% young males} & \multicolumn{2}{c}{\% disabled} & \multicolumn{2}{c}{\% female head} & \multicolumn{2}{c}{\% spouse presente} \\ " _n
	file write latex "& (1) & (2) & (1) & (2) & (1) & (2) & (1) & (2) & (1) & (2) & (1) & (2) \\ \hline" _n

	foreach i in p_hhth p_hhthj hht p_hdist p_hhs_jm p_hhs_c {
		
		* Conflict x time all
		reg `i' conflict_time CONFLICT TIME i.ANNO i.MUNICIPIO, vce(cluster MUNICIPIO)
		local a: di %4.3f `= _b[conflict_time]'
		local b: di %4.3f `= _b[CONFLICT]'
		local c: di %4.3f `= _b[TIME]'
		global sea_`i': di %4.3f `= _se[conflict_time]'
		global seb_`i': di %4.3f `= _se[CONFLICT]'
		global sec_`i': di %4.3f `= _se[TIME]'
		local ta=_b[conflict_time]/_se[conflict_time]
		local tb=_b[CONFLICT]/_se[CONFLICT]
		local tc=_b[TIME]/_se[TIME]
		local pa= 2*ttail(`e(df_r)',abs(`ta'))
		local pb= 2*ttail(`e(df_r)',abs(`tb'))
		local pc= 2*ttail(`e(df_r)',abs(`tc'))
		global r2_`i': di %4.3f `= e(r2)'
		global N_`i': di %9.0f `= e(N)'
			
			foreach n in a b c {
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
			
			
		* Conflict x years
		reg `i' conflict_time2016 conflict_time2020 i.ANNO i.MUNICIPIO, vce(cluster MUNICIPIO)
		local d: di %4.3f `= _b[conflict_time2016]'
		local e: di %4.3f `= _b[conflict_time2020]'
		global sed_`i': di %4.3f `= _se[conflict_time2016]'
		global see_`i': di %4.3f `= _se[conflict_time2020]'
		local td=_b[conflict_time2016]/_se[conflict_time2016]
		local te=_b[conflict_time2020]/_se[conflict_time2020]
		local pd= 2*ttail(`e(df_r)',abs(`td'))
		local pe= 2*ttail(`e(df_r)',abs(`te'))
		global r22_`i': di %4.3f `= e(r2)'
		global N2_`i': di %9.0f `= e(N)'
			
			foreach n in d e {
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

		sum `i', d 
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(sd)'
			
	}
	
	file write latex " Conflict x Time & ${ba_hht} && ${ba_p_hhth} && ${ba_p_hhthj} && ${ba_p_hdist} && ${ba_p_hhs_jm} && ${ba_p_hhs_c} & \\" _n
	file write latex "  & (${sea_hht}) && (${sea_p_hhth}) && (${sea_p_hhthj}) && (${sea_p_hdist}) && (${sea_p_hhs_jm}) && (${sea_p_hhs_c}) & \\" _n

	file write latex " Conflict x 2016 && ${bd_hht} && ${bd_p_hhth} && ${bd_p_hhthj} && ${bd_p_hdist} && ${bd_p_hhs_jm} && ${bd_p_hhs_c} \\" _n
	file write latex "  && (${sed_hht}) && (${sed_p_hhth}) && (${sed_p_hhthj}) && (${sed_p_hdist}) && (${sed_p_hhs_jm}) && (${sed_p_hhs_c}) \\" _n
	
	file write latex " Conflict x 2020 && ${be_hht} && ${be_p_hhth} && ${be_p_hhthj} && ${be_p_hdist}&& ${be_p_hhs_jm} && ${be_p_hhs_c} \\" _n
	file write latex "  && (${see_hht}) && (${see_p_hhth}) && (${see_p_hhthj}) && (${see_p_hdist}) && (${see_p_hhs_jm}) && (${see_p_hhs_c}) \\" _n
	
	file write latex " Conflict & ${bb_hht} && ${bb_p_hhth} && ${bb_p_hhthj} && ${bb_p_hdist} && ${bb_p_hhs_jm} && ${bb_p_hhs_c} & \\" _n
	file write latex "  & (${seb_hht}) && (${seb_p_hhth}) && (${seb_p_hhthj}) && (${seb_p_hdist}) && (${seb_p_hhs_jm}) & & (${seb_p_hhs_c}) &  \\" _n

	file write latex " Time & ${bc_hht} && ${bc_p_hhth} && ${bc_p_hhthj} && ${bc_p_hdist} && ${bc_p_hhs_jm} && ${bc_p_hhs_c} & \\" _n
	file write latex "  & (${sec_hht}) && (${sec_p_hhth}) && (${sec_p_hhthj}) && (${sec_p_hdist}) && (${sec_p_hhs_jm}) && (${sec_p_hhs_c}) & \\" _n

	file write latex " Observations & ${N_hht} & ${N2_hht} & ${N_p_hhth} & ${N2_p_hhth} & ${N_p_hhthj} & ${N2_p_hhthj} & ${N_p_hdist} & ${N2_p_hdist} & ${N_p_hhs_jm} & ${N2_p_hhs_jm} & ${N_p_hhs_c} & ${N2_p_hhs_c} \\" _n
	file write latex " R-squared & ${r2_hht} & ${r22_hht} & ${r2_p_hhth} & ${r22_p_hhth} & ${r2_p_hhthj} & ${r22_p_hhthj} & ${r2_p_hdist} & ${r22_p_hdist} & ${r2_p_hhs_jm} & ${r22_p_hhs_jm} & ${r2_p_hhs_c} & ${r22_p_hhs_c} \\" _n
	file write latex "\hline" _n

	file write latex "Mean & ${m1_hht} & ${m1_hht} & ${m1_p_hhth}  & ${m1_p_hhth} & ${m1_p_hhthj} & ${m1_p_hhthj} & ${m1_p_hdist} & ${m1_p_hdist} & ${m1_p_hhs_jm} & ${m1_p_hhs_jm} & ${m1_p_hhs_c} & ${m1_p_hhs_c} \\" _n
	file write latex "Std. Dev. & ${p1_hht} & ${p1_hht} & ${p1_p_hhth} & ${p1_p_hhth} & ${p1_p_hhthj} & ${p1_p_hhthj} & ${p1_p_hdist} & ${p1_p_hdist} & ${p1_p_hhs_jm} & ${p1_p_hhs_jm} & ${p1_p_hhs_c} & ${p1_p_hhs_c} \\" _n
	file write latex "Year FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
	file write latex "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n			
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
	