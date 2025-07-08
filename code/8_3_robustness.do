/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
9_3_robustness.do

This do file runs robustness 3 - Selective migration paterns
=========================================================================*/

*******************************************
*** Robustness 3: Census *** 
*******************************************

****************************
*** Editing raw data ***
****************************

	* Cleaning raw data
	foreach i in 05 08 11 13 15 17 18 19 20 23 25 27 41 44 47 50 52 54 63 66 68 70 73 76 81 85 86 88 91 94 95 97 99 {
	
		use "${data}/raw/CENSO/CNPV2018_5PER_A2_`i'.DTA", clear
		
		keep u_mpio p_nrohog p_nro_per pa_vivia_5anos pa_vivia_1ano p_edadr u_dpto
		gen unos=1
		gen MUNICIPIO = u_dpto + u_mpio
		destring MUNICIPIO, replace
		
		merge m:1 MUNICIPIO using "${data}/coded/FARC.dta"
		
		keep if _merge==3

		drop u_mpio p_nrohog p_nro_per u_dpto
		
		save "${data}/coded/censo_depto_`i'.dta", replace
	}
	
	* Append all departments
	use "${data}/coded/censo_depto_05.dta", clear
	foreach i in 08 11 13 15 17 18 19 20 23 25 27 41 44 47 50 52 54 63 66 68 70 73 76 81 85 86 88 91 94 95 97 99 {
		append using "${data}/coded/censo_depto_`i'.dta"
	}
	
	* Creating relevant vars
	gen vivia_1 = (pa_vivia_1ano==3)
	gen vivia_5 = (pa_vivia_5anos==3)

	gen young=.
	replace young=1 if p_edadr==4 | p_edadr==5 | p_edadr==6
	gen vivia_1y = (pa_vivia_1ano==3)
	gen vivia_5y = (pa_vivia_5anos==3)
	replace vivia_1y=. if young==.
	replace vivia_5y=. if young==.
	
	replace vivia_1=100 if vivia_1==1
	replace vivia_5=100 if vivia_5==1
	drop pa_vivia_1ano pa_vivia_5anos
	
	save "${data}/coded/censo_depto_total.dta", replace

****************************
*** Regression ***
****************************

	use "${data}/coded/censo_depto_total.dta", clear
	
	* Regresion
	file open latex using "${output}/censo.txt", write replace text
	file write latex "\begin{tabular}{l c c c c c} \\ \hline \hline" _n
	file write latex "& \multicolumn{2}{c}{Total population} && \multicolumn{2}{c}{Young population} \\ \cline{2-3} \cline{5-6}" _n
	file write latex "& Five years back & One year back && Five years back & One year back \\  " _n
	file write latex "& (1) & (2) && (3) & (4) \\ \hline" _n

	foreach i in vivia_5 vivia_5y vivia_1 vivia_1y {
		
		reg `i' CONFLICT i.MUNICIPIO
		local b: di %4.3f `= _b[CONFLICT]'
		global seb_`i': di %4.3f `= _se[CONFLICT]'
		local tb=_b[CONFLICT]/_se[CONFLICT]
		local pb= 2*ttail(`e(df_r)',abs(`tb'))
		global r2_`i': di %4.3f `= e(r2)'
		global N_`i': di %9.0f `= e(N)'
			
			foreach n in b {
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
	
	file write latex " Conflict & ${bb_vivia_5} & ${bb_vivia_1} && ${bb_vivia_5y} & ${bb_vivia_1y} \\" _n
	file write latex "  & (${seb_vivia_5}) & (${seb_vivia_1}) && (${seb_vivia_5y}) & (${seb_vivia_1y}) \\" _n

	file write latex " Observations & ${N_vivia_5} & ${N_vivia_1} && ${N_vivia_5y} & ${N_vivia_1y} \\" _n
	file write latex " R-squared & ${r2_vivia_5} & ${r2_vivia_1} && ${r2_vivia_5y} & ${r2_vivia_1y} \\" _n
	file write latex "\hline" _n

	file write latex "Mean & ${m1_vivia_5} & ${m1_vivia_1} && ${m1_vivia_5y} & ${m1_vivia_1y} \\" _n
	file write latex "Std. Dev. & ${p1_vivia_5} & ${p1_vivia_1} && ${p1_vivia_5y} & ${p1_vivia_1y} \\" _n		
	file write latex "Municipality FE & $\checkmark$ & $\checkmark$ && $\checkmark$ & $\checkmark$ \\" _n	
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
