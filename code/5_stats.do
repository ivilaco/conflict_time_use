/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
5_stats.do

This do file runs describptive stats and behaviour graphs
=========================================================================*/

	use "${enut}/ENUT_FARC.dta", clear
	
	tab EDU, gen(edu)
	
	* Correlation between HH education and ingresos
	corr INGRESO EDU

*******************************************
*** GRAPH USE OF TIME - ALL ***
*******************************************
	
	preserve
		collapse (mean) CH CU MW NW1 NW2 NW3 CHc CUc MWc NW1c NW2c NW3c, by(EDAD)

			* 1.1 Con missings
			twoway line MW EDAD, color(gold) ///		
			|| line NW1 EDAD, color(mint) lpattern(shortdash_dot) ///
			|| line NW2 EDAD, color(green) lpattern(longdash_dot) ///
			|| line NW3 EDAD, color(ebblue) lpattern(dash) ///
			|| line CH EDAD, color(purple) lpattern(shortdash) ///
			|| line CU EDAD, color(black) lpattern(dot) ///
			graphregion(color(gs16)) xsize(7) xlabel(14(2)28) ///
			legen(order(1 "Labour market" 2 "Leisure and self-care" 3 "Sleep" 4 "Education" 5 "Household activities" 6 "Care") ///
			cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) ///
			ytitle("Time spent (Hours/Day)") xtitle("Age (Years)") subtitle("Panel A: With Missing Values")
			graph export "${sale}/todcat_miss.pdf", replace
				
			* 1.2 Con ceros
			twoway line MWc EDAD, color(gold) ///		
			|| line NW1c EDAD, color(mint) lpattern(shortdash_dot) ///
			|| line NW2c EDAD, color(green) lpattern(longdash_dot) ///
			|| line NW3c EDAD, color(ebblue) lpattern(dash) ///
			|| line CHc EDAD, color(purple) lpattern(shortdash) ///
			|| line CUc EDAD, color(black) lpattern(dot) ///
			graphregion(color(gs16)) xsize(7) xlabel(14(2)28) ///
			legen(order(1 "Labour market" 2 "Leisure and self-care" 3 "Sleep" 4 "Education" 5 "Household activities" 6 "Care") ///
			cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) ///
			ytitle("Time spent (Hours/Day)") xtitle("Age (Years)") subtitle("Panel B: Taking Missing Values as Zero")
			graph export "${sale}/todcat_ceros.pdf", replace
			
			* 1.3 Con ceros (presentación)
			twoway line MWc EDAD, color(gold) ///		
			|| line NW1c EDAD, color(mint) lpattern(shortdash_dot) ///
			|| line NW2c EDAD, color(green) lpattern(longdash_dot) ///
			|| line NW3c EDAD, color(ebblue) lpattern(dash) ///
			|| line CHc EDAD, color(purple) lpattern(shortdash) ///
			|| line CUc EDAD, color(black) lpattern(dot) ///
			graphregion(color(gs16)) /*xsize(7)*/ xsize(4) xlabel(14(2)28) ///
			legen(order(1 "Labour market" 2 "Leisure and self-care" 3 "Sleep" 4 "Education" 5 "Household activities" 6 "Care") ///
			rows(2) position(6) size(small) symxsize(3) region(lcolor(white))) ///
			ytitle("Time spent (Hours/Day)") xtitle("Age (Years)")
			graph export "${sale}/todcat_ceros_p.pdf", replace
			
	restore
	
*******************************************
*** GRAPH USE OF TIME - DIFF. GENDER ***
*******************************************
		
	preserve
		collapse (mean) CH CU MW NW1 NW2 NW3 CHc CUc MWc NW1c NW2c NW3c, by(EDAD SEXO)
		reshape wide CH CU MW NW1 NW2 NW3 CHc CUc MWc NW1c NW2c NW3c, i(EDAD) j(SEXO)
		foreach i in CH CU MW NW1 NW2 NW3 CHc CUc MWc NW1c NW2c NW3c{
			gen `i'm = `i'1-`i'0
		}
			
			* 1.1 Diferencia entre hombres y mujeres missings
			twoway line MWm EDAD, color(gold) ///		
			|| line NW1m EDAD, color(mint) lpattern(shortdash_dot) ///
			|| line NW2m EDAD, color(green) lpattern(longdash_dot) ///
			|| line NW3m EDAD, color(ebblue) lpattern(dash) ///
			|| line CHm EDAD, color(purple) lpattern(shortdash) ///
			|| line CUm EDAD, color(black) lpattern(dot) ///
			graphregion(color(gs16)) xsize(7) xlabel(14(2)28) ///
			legen(order(1 "Labour market" 2 "Leisure and self-care" 3 "Sleep" 4 "Education" 5 "Household activities" 6 "Care") cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) ///
			ytitle("Female-Male Difference (Hours/Day)") xtitle("Age (Years)") subtitle("Panel A: With Missing Values")
			graph export "${sale}/todcat_missd.pdf", replace
				
			* 1.2 Diferencia entre hombres y mujeres ceros
			twoway line MWcm EDAD, color(gold) ///	
			|| line NW1cm EDAD, color(mint) lpattern(shortdash_dot) ///     
			|| line NW2cm EDAD, color(green) lpattern(longdash_dot) ///     
			|| line NW3cm EDAD, color(ebblue) lpattern(dash) ///     
			|| line CHcm EDAD, color(purple) lpattern(shortdash) ///      
			|| line CUcm EDAD, color(black) lpattern(dot) ///      
			graphregion(color(gs16)) xsize(7) xlabel(14(2)28) ///
			legen(order(1 "Labour market" 2 "Leisure and self-care" 3 "Sleep" 4 "Education" 5 "Household activities" 6 "Care") ///
			cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) ///
			ytitle("Female-Male Difference (Hours/Day)") xtitle("Age (Years)") subtitle("Panel B: Taking Missing Values as Zero")
			graph export "${sale}/todcat_cerosd_p.pdf", replace
			
			* 1.3 Diferencia entre hombres y mujeres ceros (presentación)
			twoway line MWcm EDAD, color(gold) ///	
			|| line NW1cm EDAD, color(mint) lpattern(shortdash_dot) ///     
			|| line NW2cm EDAD, color(green) lpattern(longdash_dot) ///     
			|| line NW3cm EDAD, color(ebblue) lpattern(dash) ///     
			|| line CHcm EDAD, color(purple) lpattern(shortdash) ///      
			|| line CUcm EDAD, color(black) lpattern(dot) ///      
			graphregion(color(gs16)) xsize(4) xlabel(14(2)28) ///
			legen(order(1 "Labour market" 2 "Leisure and self-care" 3 "Sleep" 4 "Education" 5 "Household activities" 6 "Care") ///
			rows(2) position(6)  size(small) symxsize(3) region(lcolor(white))) ///
			ytitle("Female-Male Difference (Hours/Day)") xtitle("Age (Years)")
			graph export "${sale}/todcat_cerosd_p.pdf", replace
	
	restore

*******************************************
*** GRAPH PROPORTION OF ZEROS ***
*******************************************

		file open latex0 using "${sale}/zeros.txt", write replace text
		file write latex0 "\begin{tabular}{l c c c c} \\ \hline \hline" _n
		file write latex0 "\large" _n
		file write latex0 "& \multicolumn{2}{c}{Frequency} & \multicolumn{2}{c}{Percentage} \\ \cline{2-5}" _n
		file write latex0 " & $>$0 & =0  & $>$0 & =0 \\ \hline" _n
		foreach i in $out {
			tab `i'd
			estpost tabulate `i'd
			mat b = e(b)
			mat a = e(pct)
			scalar f0_`i' = b[1,1]
			scalar f1_`i' = b[1,2]		
			scalar p0_`i' = a[1,1]
			scalar p1_`i' = a[1,2]	
			glo f0_`i' : di f0_`i'
			glo f1_`i' : di f1_`i'
			glo p0_`i' : di %10.2f p0_`i'
			glo p1_`i' : di %10.2f p1_`i'		
			
			local lab: variable label `i'
		
		file write latex0 "`lab' & ${f1_`i'} & ${f0_`i'} & ${p1_`i'} & ${p0_`i'} \\" _n
		}
		file write latex0 "\hline \hline" _n
		file write latex0 "\end{tabular}" _n
		file close latex0		
		
*******************************************
*** HOUSEHOLD DEMOGRAPHICS ***
*******************************************

		* Porcentage de hombres y discapacitados en el hogar
		file open latex01 using "${sale}/phh.txt", write replace text
		file write latex01 "\begin{tabular}{l c c c c c} \\ \hline \hline" _n
		file write latex01 "&& \multicolumn{3}{c}{Males} & Disabled \\ \cline{3-6}" _n
		file write latex01 " & Period & Total & Care work & House work & Total \\" _n
		file write latex01 " && (1) & (2) & (3) & (1) \\ \hline" _n
		preserve
			duplicates drop idhogar ANNO, force
			collapse (mean) hh_p* hhcu_p* hhch_p* hdis_p*, by(TIME)
			foreach i of numlist 1/2 {
				forvalues n=0/1 {
					glo a`i'_`n' : dis %10.2f hh_p`n'[`i']
					glo b`i'_`n' : dis %10.2f hhcu_p`n'[`i']
					glo c`i'_`n' : dis %10.2f hhch_p`n'[`i']
					glo d`i'_`n' : dis %10.2f hdis_p`n'[`i']
				}
			}
		file write latex01 "Treatment & Pre & ${a1_1} & ${b1_1} & ${c1_1} & ${d1_1} \\" _n
		file write latex01 "& Post & ${a2_1} & ${b2_1} & ${c2_1} & ${d2_1} \\ \hline" _n
		file write latex01 "Control & Pre & ${a1_0} & ${b1_0} & ${c1_0} & ${d1_0} \\" _n
		file write latex01 "& Post & ${a2_0} & ${b2_0} & ${c2_0} & ${d2_0} \\" _n
		restore
		file write latex01 "\hline \hline" _n
		file write latex01 "\end{tabular}" _n
		file close latex01	
					
*******************************************
*** DESCRIPTIVE STATS ***
*******************************************

	label var CONFLICT "Treatment (1: Conflict)"
	label var TIME "Time (1: After 2014)"
	label var EDAD "Age (in years)"
	label var SEXO "Gender (1: Female)"
	label var ingdummy "HH possesion of goods (1: High)"
	label var edu1 "No education"
	label var edu2 "Preschool/Elementary"
	label var edu3 "Middle/High school"
	label var edu4 "Under/Postgraduate"

	file open latex using "${sale}/estad.txt", write replace text
	file write latex "\begin{tabular}{l c c c c c } \\ \hline \hline" _n
	file write latex "\textbf{Variable} & \textbf{Mean} & \textbf{Median} & \textbf{SD} & \textbf{Min} & \textbf{Max}\\" _n
	file write latex " & (1) & (2) & (3) & (4) & (5) \\ \hline " _n
	foreach i in CONFLICT TIME EDAD SEXO ingdummy {	
					
		sum `i', d 
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(p50)'
		global sd1_`i': di %10.2f `= r(sd)'
		global min1_`i': di %10.2f `= r(min)'
		global max1_`i': di %10.2f `= r(max)'
						
			local lab: variable label `i' 
					
	file write latex "`lab' & ${m1_`i'} & ${p1_`i'}  & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}	
	file write latex "Education of the Head of HH (1: Highest) &&&&& \\" _n
	foreach i in edu1 edu2 edu3 edu4 {	
					
		sum `i', d 
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(p50)'
		global sd1_`i': di %10.2f `= r(sd)'
		global min1_`i': di %10.2f `= r(min)'
		global max1_`i': di %10.2f `= r(max)'
						
			local lab: variable label `i' 
					
	file write latex "\hspace{3mm} `lab' & ${m1_`i'} & ${p1_`i'}  & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}	
	file write latex " \\ " _n
	file write latex "\textbf{Extensive margin (Dummy)} &&&&& \\ " _n
	foreach i in $dummys {	
					
		sum `i', d 
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(p50)'
		global sd1_`i': di %10.2f `= r(sd)'
		global min1_`i': di %10.2f `= r(min)'
		global max1_`i': di %10.2f `= r(max)'
						
			local lab: variable label `i' 
					
	file write latex "`lab' & ${m1_`i'} & ${p1_`i'} & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}
	file write latex " \\ " _n
	file write latex "\textbf{Intensive margin (Hours)} &&&&& \\ " _n
	foreach i in $ceros {	
						
		sum `i', d 
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(p50)'
		global sd1_`i': di %10.2f `= r(sd)'
		global min1_`i': di %10.2f `= r(min)'
		global max1_`i': di %10.2f `= r(max)'
					
		local lab: variable label `i' 
				
	file write latex "`lab' & ${m1_`i'} & ${p1_`i'} & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
	
*******************************************
*** MAP COLOMBIA MUNICIPALITIES ***
*******************************************

	* Importing shapefiles
	shp2dta using "${entra}/mpio.shp", database(col_mpios) coordinates(col_coord) genid(id) replace

	use col_mpios, clear
	destring MPIOS, gen(MUNICIPIO)
	describe
	list id MUNICIPIO in 1/5
	save col_mpios, replace
	
	* Mergin with conflict database
	use "${enut}/ENUT_FARC.dta", clear
	keep MUNICIPIO CONFLICT 
	duplicates drop MUNICIPIO, force
	
	merge 1:m MUNICIPIO using col_mpios
	drop _merge
	
	* Creating the map and exporting
	spmap CONFLICT using col_coord, id(id) fcolor(Accent) ///
		legend(label(2 "No conflict") label(3 "Conflict"))	
	graph export "${sale}/map.pdf", replace
	
	
	