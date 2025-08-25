/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
5_stats.do

This do file runs descriptive stats, behaviour graphs and maps
=========================================================================*/

	use "${data}/coded/enut/ENUT_FARC_J.dta", clear // clave	
	
*******************************************
*** Graphs on the use of time - All ***
*******************************************

	preserve
	
		collapse (mean) CH CU MW NW1 NW2 NW3 CHc CUc MWc NW1c NW2c NW3c [pw=F_EXP], by(EDAD) // Revisar que si funcione

		* 1.1 With missings
		twoway line NW3 EDAD, color(ebblue) lpattern(dash) ///
		|| line MW EDAD, color(gold) ///
		|| line CH EDAD, color(purple) lpattern(shortdash) ///
		|| line CU EDAD, color(black) lpattern(dot) ///
		|| line NW1 EDAD, color(black) ///
		|| line NW2 EDAD, color(green) lpattern(longdash_dot) ///
		graphregion(color(gs16)) xsize(7) xlabel(14(2)28) ///
		legen(order(1 "Education" 2 "Labour market" 3 "Household activities" 4 "Care of individuals" 5 "Leisure and self-care" 6 "Sleep") ///
		cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) ///
		ytitle("Time spent (Hours/Day)") xtitle("Age (Years)")
		
		graph export "${sale}/todcat_miss.pdf", replace
				
		* 1.2 With zeros
		twoway line NW3c EDAD, color(ebblue) lpattern(dash) /// 	
		|| line MWc EDAD, color(gold) ///
		|| line CHc EDAD, color(purple) lpattern(shortdash) ///
		|| line CUc EDAD, color(black) lpattern(dot) ///		
		|| line NW1c EDAD, color(black) ///
		|| line NW2c EDAD, color(green) lpattern(longdash_dot) ///
		graphregion(color(gs16)) xsize(7) xlabel(14(2)28) ///
		legen(order(1 "Education" 2 "Labour market" 3 "Household activities" 4 "Care of individuals" 5 "Leisure and self-care" 6 "Sleep") ///
		cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) ///
		ytitle("Time spent (Hours/Day)") xtitle("Age (Years)")
		
		graph export "${sale}/todcat_ceros.pdf", replace
			
		* 1.3 With zeros (presentation)
		twoway line NW3c EDAD, color(ebblue) lpattern(dash) /// 
		|| line MWc EDAD, color(gold) ///		
		|| line CHc EDAD, color(purple) lpattern(shortdash) ///
		|| line CUc EDAD, color(black) lpattern(dot) ///
		|| line NW1c EDAD, color(black) ///
		|| line NW2c EDAD, color(green) lpattern(longdash_dot) ///
		graphregion(color(gs16)) /*xsize(7)*/ xsize(4) xlabel(14(2)28) ///
		legen(order(1 "Education" 2 "Labour market" 3 "Household activities" 4 "Care of individuals" 5 "Leisure and self-care" 6 "Sleep") ///
		rows(2) position(6) size(vsmall) symxsize(3) region(lcolor(white))) ///
		ytitle("Time spent (Hours/Day)") xtitle("Age (Years)")
		
		graph export "${sale}/todcat_ceros_p.pdf", replace
			
	restore
	
*******************************************
*** Graphs on the use of time - Gender ***
*******************************************
		
	preserve
	
		collapse (mean) CH CU MW NW1 NW2 NW3 CHc CUc MWc NW1c NW2c NW3c [pw=F_EXP], by(EDAD SEXO) // Revisar que si funcione
		reshape wide CH CU MW NW1 NW2 NW3 CHc CUc MWc NW1c NW2c NW3c, i(EDAD) j(SEXO)
		foreach i in CH CU MW NW1 NW2 NW3 CHc CUc MWc NW1c NW2c NW3c{
			gen `i'm = `i'1-`i'0
		}
			
		* 1.1 With missings
		twoway line NW3m EDAD, color(ebblue) lpattern(dash) /// 	
		|| line MWm EDAD, color(gold) ///	
		|| line CHm EDAD, color(purple) lpattern(shortdash) ///
		|| line CUm EDAD, color(black) lpattern(dot) ///
		|| line NW1m EDAD, color(black) ///
		|| line NW2m EDAD, color(green) lpattern(longdash_dot) ///
		graphregion(color(gs16)) xsize(7) xlabel(14(2)28) ///
		legen(order(1 "Education" 2 "Labour market" 3 "Household activities" 4 "Care of individuals" 5 "Leisure and self-care" 6 "Sleep") ///
		cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) ///
		ytitle("Female-Male Difference (Hours/Day)") xtitle("Age (Years)")
	
		graph export "${sale}/todcat_missd.pdf", replace
				
		* 1.2 With zeros
		twoway line NW3cm EDAD, color(ebblue) lpattern(dash) ///  
		|| line MWcm EDAD, color(gold) ///	   
		|| line CHcm EDAD, color(purple) lpattern(shortdash) ///      
		|| line CUcm EDAD, color(black) lpattern(dot) ///      
		|| line NW1cm EDAD, color(black) ///     
		|| line NW2cm EDAD, color(green) lpattern(longdash_dot) ///     
		graphregion(color(gs16)) xsize(7) xlabel(14(2)28) ///
		legen(order(1 "Education" 2 "Labour market" 3 "Household activities" 4 "Care of individuals" 5 "Leisure and self-care" 6 "Sleep") ///
		cols(1) position(3) size(small) symxsize(3) region(lcolor(white))) ///
		ytitle("Female-Male Difference (Hours/Day)") xtitle("Age (Years)")
		
		graph export "${sale}/todcat_cerosd.pdf", replace
			
		* 1.3 With zeros (presentation)
		twoway line NW3cm EDAD, color(ebblue) lpattern(dash) ///      
		|| line MWcm EDAD, color(gold) ///	
		|| line CHcm EDAD, color(purple) lpattern(shortdash) ///      
		|| line CUcm EDAD, color(black) lpattern(dot) ///      
		|| line NW1cm EDAD, color(black) ///     
		|| line NW2cm EDAD, color(green) lpattern(longdash_dot) ///     
		graphregion(color(gs16)) xsize(4) xlabel(14(2)28) ///
		legen(order(1 "Education" 2 "Labour market" 3 "Household activities" 4 "Care of individuals" 5 "Leisure and self-care" 6 "Sleep") ///
		rows(2) position(6)  size(vsmall) symxsize(3) region(lcolor(white))) ///
		ytitle("Female-Male Difference (Hours/Day)") xtitle("Age (Years)")
		
		graph export "${sale}/todcat_cerosd_p.pdf", replace
	
	restore

*******************************************
*** Table proportion of zeros ***
*******************************************

	file open latex0 using "${sale}/zeros.txt", write replace text
	file write latex0 "\begin{tabular}{l c c c c c} \\ \hline \hline" _n
	file write latex0 "\large" _n
	file write latex0 "& \multicolumn{2}{c}{Frequency} && \multicolumn{2}{c}{Proportion} \\ \cline{2-3} \cline{5-6}" _n
	file write latex0 "& $>$ 0 & = 0 && $>$ 0 & = 0 \\" _n
	file write latex0 " & (1) & (2) && (3) & (4) \\ \hline" _n

	foreach i in $out {
		
		* Count
		count if `i'c > 0
		global n1_`i' : di %10.0f `= r(N)'
		
		count if `i'c == 0
		global n2_`i' : di %10.0f `= r(N)'
		
		* Total observations
		count 
		global ntot_`i' : di %10.0f `= r(N)'
		
		* Proportion
		global p1_`i' : di %6.2f `= ${n1_`i'} / ${ntot_`i'}'
		global p2_`i' : di %6.2f `= ${n2_`i'} / ${ntot_`i'}'
			
		local lab: variable label `i'
		
	file write latex0 "`lab' & ${n1_`i'} & ${n2_`i'} && ${p1_`i'} & ${p2_`i'} \\" _n
		}
		
	file write latex0 "\hline \hline" _n
	file write latex0 "\end{tabular}" _n
	file close latex0	

*******************************************
*** Descriptive Stats ***
*******************************************

	* Labelling
	label var CONFLICT "Conflict (1 = FARC-affected municipality) "
	label var TIME "Time (1 = Years after 2014)"
	label var EDAD "Age (Years)"
	label var SEXO "Gender (1 = Female)"
	label var ingdummy "Household asset ownership (1 = High)"
	label var edu1 "No education"
	label var edu2 "Preschool/Elementary"
	label var edu3 "Middle/High school"
	label var edu4 "Under/Postgraduate"

	* Stats
	file open latex using "${sale}/estad.txt", write replace text
	file write latex "\begin{tabular}{l c c c c c c} \\ \hline \hline" _n
	file write latex "Variable & N & Mean & Median & Std. Dev. & Min & Max \\" _n
	file write latex " & (1) & (2) & (3) & (4) & (5) & (6) \\ \hline " _n
	foreach i in CONFLICT TIME EDAD SEXO ingdummy {	
					
		sum `i', d 
		global o1_`i': di %10.0f `= r(N)'
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(p50)'
		global sd1_`i': di %10.2f `= r(sd)'
		global min1_`i': di %10.2f `= r(min)'
		global max1_`i': di %10.2f `= r(max)'
						
			local lab: variable label `i' 
					
	file write latex "`lab' & ${o1_`i'} & ${m1_`i'} & ${p1_`i'}  & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}	
	file write latex "Household head's education (1 = Highest level achieved) &&&&&& \\" _n
	foreach i in edu1 edu2 edu3 edu4 {	
					
		sum `i', d 
		global o1_`i': di %10.0f `= r(N)'
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(p50)'
		global sd1_`i': di %10.2f `= r(sd)'
		global min1_`i': di %10.2f `= r(min)'
		global max1_`i': di %10.2f `= r(max)'
						
			local lab: variable label `i' 
					
	file write latex "\hspace{3mm} `lab'  & ${o1_`i'} & ${m1_`i'} & ${p1_`i'}  & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}	
	file write latex " \\ " _n
	file write latex "Panel A. Extensive margin &&&&&& \\ " _n
	foreach i in $dummys {	
					
		sum `i', d 
		global o1_`i': di %10.0f `= r(N)'
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(p50)'
		global sd1_`i': di %10.2f `= r(sd)'
		global min1_`i': di %10.2f `= r(min)'
		global max1_`i': di %10.2f `= r(max)'
						
			local lab: variable label `i' 
					
	file write latex "\hspace{3mm} `lab'  & ${o1_`i'} & ${m1_`i'} & ${p1_`i'} & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}
	file write latex " \\ " _n
	file write latex "Panel B. Intensive margin &&&&&& \\ " _n
	foreach i in $ceros {	
						
		sum `i', d 
		global o1_`i': di %10.0f `= r(N)'
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(p50)'
		global sd1_`i': di %10.2f `= r(sd)'
		global min1_`i': di %10.2f `= r(min)'
		global max1_`i': di %10.2f `= r(max)'
					
		local lab: variable label `i' 
				
	file write latex "\hspace{3mm} `lab'  & ${o1_`i'} & ${m1_`i'} & ${p1_`i'} & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}
	file write latex " \\ " _n
	file write latex "Panel C. Intensive margin (If time spent) &&&&&& \\ " _n
	foreach i in $ceros {	
						
		sum `i' if `i' >0, d
		global o1_`i': di %10.0f `= r(N)'
		global m1_`i': di %10.2f `= r(mean)'
		global p1_`i': di %10.2f `= r(p50)'
		global sd1_`i': di %10.2f `= r(sd)'
		global min1_`i': di %10.2f `= r(min)'
		global max1_`i': di %10.2f `= r(max)'
					
		local lab: variable label `i' 
				
	file write latex "\hspace{3mm} `lab'  & ${o1_`i'} & ${m1_`i'} & ${p1_`i'} & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
	
*******************************************
*** Descriptive Stats PW ***
*******************************************

	* Stats
	file open latex using "${sale}/estad.txt", write replace text
	file write latex "\begin{tabular}{l c c c c c c} \\ \hline \hline" _n
	file write latex "Variable & N & Mean & Median & Std. Dev. & Min & Max \\" _n
	file write latex " & (1) & (2) & (3) & (4) & (5) & (6) \\ \hline " _n
	foreach i in CONFLICT TIME EDAD SEXO ingdummy {	
					
		mean `i' [pw=F_EXP]
		scalar m1 = e(b)[1,1]
		scalar sd1 = e(sd)[1,1]
		scalar N1 = e(_N)[1,1]
		
		global o1_`i': di %10.0f N1
		global m1_`i': di %10.2f m1
		global sd1_`i': di %10.2f sd1
		
		_pctile `i' [pw=F_EXP], p(50)
		scalar med1 = r(r1)
		
		_pctile `i' [pw=F_EXP], p(0 100)
		scalar min1 = r(r1)
		scalar max1 = r(r2)

		global p1_`i': di %10.2f med1
		global min1_`i': di %10.2f min1
		global max1_`i': di %10.2f max1
						
			local lab: variable label `i' 
					
	file write latex "`lab' & ${o1_`i'} & ${m1_`i'} & ${p1_`i'}  & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}	
	file write latex "Household head's education (1 = Highest level achieved) &&&&&& \\" _n
	foreach i in edu1 edu2 edu3 edu4 {	
					
		mean `i' [pw=F_EXP]
		scalar m1 = e(b)[1,1]
		scalar sd1 = e(sd)[1,1]
		scalar N1 = e(_N)[1,1]
		
		global o1_`i': di %10.0f N1
		global m1_`i': di %10.2f m1
		global sd1_`i': di %10.2f sd1
		
		_pctile `i' [pw=F_EXP], p(50)
		scalar med1 = r(r1)
		
		_pctile `i' [pw=F_EXP], p(0 100)
		scalar min1 = r(r1)
		scalar max1 = r(r2)

		global p1_`i': di %10.2f med1
		global min1_`i': di %10.2f min1
		global max1_`i': di %10.2f max1
						
			local lab: variable label `i' 
					
	file write latex "\hspace{3mm} `lab'  & ${o1_`i'} & ${m1_`i'} & ${p1_`i'}  & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}	
	file write latex " \\ " _n
	file write latex "Panel A. Extensive margin &&&&&& \\ " _n
	foreach i in $dummys {	
					
		mean `i' [pw=F_EXP]
		scalar m1 = e(b)[1,1]
		scalar sd1 = e(sd)[1,1]
		scalar N1 = e(_N)[1,1]
		
		global o1_`i': di %10.0f N1
		global m1_`i': di %10.2f m1
		global sd1_`i': di %10.2f sd1
		
		_pctile `i' [pw=F_EXP], p(50)
		scalar med1 = r(r1)
		
		_pctile `i' [pw=F_EXP], p(0 100)
		scalar min1 = r(r1)
		scalar max1 = r(r2)

		global p1_`i': di %10.2f med1
		global min1_`i': di %10.2f min1
		global max1_`i': di %10.2f max1
						
			local lab: variable label `i' 
					
	file write latex "\hspace{3mm} `lab'  & ${o1_`i'} & ${m1_`i'} & ${p1_`i'} & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}
	file write latex " \\ " _n
	file write latex "Panel B. Intensive margin &&&&&& \\ " _n
	foreach i in $ceros {	
						
		mean `i' [pw=F_EXP]
		scalar m1 = e(b)[1,1]
		scalar sd1 = e(sd)[1,1]
		scalar N1 = e(_N)[1,1]
		
		global o1_`i': di %10.0f N1
		global m1_`i': di %10.2f m1
		global sd1_`i': di %10.2f sd1
		
		_pctile `i' [pw=F_EXP], p(50)
		scalar med1 = r(r1)
		
		_pctile `i' [pw=F_EXP], p(0 100)
		scalar min1 = r(r1)
		scalar max1 = r(r2)

		global p1_`i': di %10.2f med1
		global min1_`i': di %10.2f min1
		global max1_`i': di %10.2f max1
					
		local lab: variable label `i' 
				
	file write latex "\hspace{3mm} `lab'  & ${o1_`i'} & ${m1_`i'} & ${p1_`i'} & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}
	file write latex " \\ " _n
	file write latex "Panel C. Intensive margin (If time spent) &&&&&& \\ " _n
	foreach i in $ceros {	
		
		mean `i' [pw=F_EXP] if `i' >0
		scalar m1 = e(b)[1,1]
		scalar sd1 = e(sd)[1,1]
		scalar N1 = e(_N)[1,1]
		
		global o1_`i': di %10.0f N1
		global m1_`i': di %10.2f m1
		global sd1_`i': di %10.2f sd1
		
		_pctile `i' [pw=F_EXP] if `i' >0, p(50)
		scalar med1 = r(r1)
		
		_pctile `i' [pw=F_EXP] if `i' >0, p(0 100)
		scalar min1 = r(r1)
		scalar max1 = r(r2)

		global p1_`i': di %10.2f med1
		global min1_`i': di %10.2f min1
		global max1_`i': di %10.2f max1
					
		local lab: variable label `i' 
				
	file write latex "\hspace{3mm} `lab'  & ${o1_`i'} & ${m1_`i'} & ${p1_`i'} & ${sd1_`i'} & ${min1_`i'} & ${max1_`i'} \\" _n
	}
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
	
*******************************************
*** Map Colombia municipalities ***
*******************************************

	* Importing shapefiles
	shp2dta using "${data}/mpio.shp", database(col_mpios) coordinates(col_coord) genid(id) replace // This database must be sent to DANE******** (4)

	use col_mpios, clear
	destring MPIOS, gen(MUNICIPIO)
	describe
	list id MUNICIPIO in 1/5
	save col_mpios, replace
	
	* Mergin with conflict database
	use "${data}/coded/enut/ENUT_FARC_ALL.dta", clear
	keep MUNICIPIO CONFLICT REGION
	duplicates drop MUNICIPIO, force
	
	merge 1:m MUNICIPIO using col_mpios
	drop _merge
	
	* Regions
	drop REGION
	gen REGION = .
	replace REGION = 1 if DPTO == "08" | DPTO == "13" | DPTO == "20" | DPTO == "23" | DPTO == "44" | DPTO == "47" | DPTO == "70"
	replace REGION = 2 if DPTO == "05" | DPTO == "17" | DPTO == "18" | DPTO == "41" | DPTO == "63" | DPTO == "66" | DPTO == "73"
	replace REGION = 3 if DPTO == "15" | DPTO == "25" | DPTO == "50" | DPTO == "54" | DPTO == "68"
	replace REGION = 4 if DPTO == "19" | DPTO == "27" | DPTO == "52" | DPTO == "76"
	*replace REGION = 5 if DPTO == "11"
	*replace REGION = 6 if DPTO == "88"
		
	* Creating the map and exporting
	spmap CONFLICT using col_coord, id(id) fcolor(Accent) ///
	legend(label(2 "No conflict") label(3 "Conflict"))

	graph export "${sale}/map.pdf", replace
	
/*
	* Creating a Regions map
	spmap REGION using col_coord, id(id) fcolor(Accent) clnum(5) ///
	clmethod(unique) legend(label(1 "No data") label(2 "Atlantic") label(3 "Central") label(4 "Eastern") label(5 "Pacific")) 
	graph export "${sale}/map_regions.pdf", replace
	*/
	
*******************************************
*** Mean and SD for main samples ***
*******************************************

	file open latex using "${sale}/m_sd_main.txt", write replace text
	file write latex "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
	file write latex "\begin{tabular}{l c c c c c c c c c c c} \\ \hline \hline" _n
	
	file write latex "& \multicolumn{5}{c}{\textbf{Extensive margin}} && \multicolumn{5}{c}{\textbf{Intensive margin}} \\" _n
	file write latex "& \multicolumn{2}{c}{\textit{Treatment}} && \multicolumn{2}{c}{\textit{Control}} && \multicolumn{2}{c}{\textit{Treatment}} && \multicolumn{2}{c}{\textit{Control}} \\ \cline{2-3} \cline{5-6} \cline{8-9} \cline{11-12} " _n
	file write latex "& Mean & Std. Dev. && Mean & Std. Dev. && Mean & Std. Dev. && Mean & Std. Dev. \\ " _n
	file write latex "& (1) & (2) && (3) & (4) && (5) & (6) && (7) & (8) \\ \hline" _n

	* Main results sample
	file write latex "\multicolumn{9}{l}{Panel A. Main results sample} \\ " _n
	foreach i in $out {
		
		foreach a of numlist 0/1 {
			sum `i'd if TIME==0 & CONFLICT==`a', d 
			global m_d`a'_`i': di %10.2f `= r(mean)'
			global sd_d`a'_`i': di %10.2f `= r(sd)'
			
			sum `i'c if TIME==0 & CONFLICT==`a', d 
			global m_c`a'_`i': di %10.2f `= r(mean)'
			global sd_c`a'_`i': di %10.2f `= r(sd)'
		}
		
		local lab: variable label `i'
		file write latex " \hspace{3mm} `lab' & ${m_d1_`i'} & ${sd_d1_`i'} && ${m_d0_`i'} & ${sd_d0_`i'} && ${m_c1_`i'} & ${sd_c1_`i'} && ${m_c0_`i'} & ${sd_c0_`i'} \\" _n
	}
	file write latex "\\" _n	
	
	* Alternative conflict measure sample	
	file write latex " \multicolumn{9}{l}{Panel B. Alternative conflict measure sample} \\" _n
	foreach i in $out {
		
		foreach a of numlist 0/1 {
			sum `i'd if TIME==0 & CONFLICT1==`a', d 
			global m_d`a'_`i': di %10.2f `= r(mean)'
			global sd_d`a'_`i': di %10.2f `= r(sd)'
			
			sum `i'c if TIME==0 & CONFLICT1==`a', d 
			global m_c`a'_`i': di %10.2f `= r(mean)'
			global sd_c`a'_`i': di %10.2f `= r(sd)'
		}
		
		local lab: variable label `i'
		file write latex " \hspace{3mm} `lab' & ${m_d1_`i'} & ${sd_d1_`i'} && ${m_d0_`i'} & ${sd_d0_`i'} && ${m_c1_`i'} & ${sd_c1_`i'} && ${m_c0_`i'} & ${sd_c0_`i'} \\" _n
	}
	file write latex "\\" _n		
	
	use "${data}/coded/enut/ENUT_FARC_PSM.dta", clear

	* PSM sample
	file write latex " \multicolumn{9}{l}{Panel C. Propensity score matching sample} \\" _n
	foreach i in $out {
		
		foreach a of numlist 0/1 {
			sum `i'd if TIME==0 & CONFLICT==`a', d 
			global m_d`a'_`i': di %10.2f `= r(mean)'
			global sd_d`a'_`i': di %10.2f `= r(sd)'
			
			sum `i'c if TIME==0 & CONFLICT==`a', d 
			global m_c`a'_`i': di %10.2f `= r(mean)'
			global sd_c`a'_`i': di %10.2f `= r(sd)'
		}
		
		local lab: variable label `i'
		file write latex " \hspace{3mm} `lab' & ${m_d1_`i'} & ${sd_d1_`i'} && ${m_d0_`i'} & ${sd_d0_`i'} && ${m_c1_`i'} & ${sd_c1_`i'} && ${m_c0_`i'} & ${sd_c0_`i'} \\" _n
	}
	
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
	
*******************************************
*** Mean and SD for main samples PW ***
*******************************************

	file open latex using "${sale}/m_sd_main.txt", write replace text
	file write latex "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
	file write latex "\begin{tabular}{l c c c c c c c c c c c} \\ \hline \hline" _n
	
	file write latex "& \multicolumn{5}{c}{\textbf{Extensive margin}} && \multicolumn{5}{c}{\textbf{Intensive margin}} \\" _n
	file write latex "& \multicolumn{2}{c}{\textit{Treatment}} && \multicolumn{2}{c}{\textit{Control}} && \multicolumn{2}{c}{\textit{Treatment}} && \multicolumn{2}{c}{\textit{Control}} \\ \cline{2-3} \cline{5-6} \cline{8-9} \cline{11-12} " _n
	file write latex "& Mean & Std. Dev. && Mean & Std. Dev. && Mean & Std. Dev. && Mean & Std. Dev. \\ " _n
	file write latex "& (1) & (2) && (3) & (4) && (5) & (6) && (7) & (8) \\ \hline" _n

	* Main results sample
	file write latex "\multicolumn{9}{l}{Panel A. Main results sample} \\ " _n
	foreach i in $out {
		
		foreach a of numlist 0/1 {
			
			mean `i'd [pw=F_EXP] if TIME==0 & CONFLICT==`a'
			scalar m1 = e(b)[1,1]
			scalar sd1 = e(sd)[1,1]
		
			global m_d`a'_`i': di %10.2f m1
			global sd_d`a'_`i': di %10.2f sd1
			
			mean `i'c [pw=F_EXP] if TIME==0 & CONFLICT==`a'
			scalar m2 = e(b)[1,1]
			scalar sd2 = e(sd)[1,1]
			
			global m_c`a'_`i': di %10.2f m2
			global sd_c`a'_`i': di %10.2f sd2
		}
		
		local lab: variable label `i'
		file write latex " \hspace{3mm} `lab' & ${m_d1_`i'} & ${sd_d1_`i'} && ${m_d0_`i'} & ${sd_d0_`i'} && ${m_c1_`i'} & ${sd_c1_`i'} && ${m_c0_`i'} & ${sd_c0_`i'} \\" _n
	}
	file write latex "\\" _n	
	
	* Alternative conflict measure sample	
	file write latex " \multicolumn{9}{l}{Panel B. Alternative conflict measure sample} \\" _n
	foreach i in $out {
		
		foreach a of numlist 0/1 {
			
			mean `i'd [pw=F_EXP] if TIME==0 & CONFLICT1==`a'
			scalar m1 = e(b)[1,1]
			scalar sd1 = e(sd)[1,1]
		
			global m_d`a'_`i': di %10.2f m1
			global sd_d`a'_`i': di %10.2f sd1
			
			mean `i'c [pw=F_EXP] if TIME==0 & CONFLICT1==`a'
			scalar m2 = e(b)[1,1]
			scalar sd2 = e(sd)[1,1]
			
			global m_c`a'_`i': di %10.2f m2
			global sd_c`a'_`i': di %10.2f sd2
			
		}
		
		local lab: variable label `i'
		file write latex " \hspace{3mm} `lab' & ${m_d1_`i'} & ${sd_d1_`i'} && ${m_d0_`i'} & ${sd_d0_`i'} && ${m_c1_`i'} & ${sd_c1_`i'} && ${m_c0_`i'} & ${sd_c0_`i'} \\" _n
	}
	file write latex "\\" _n		
	
	use "${data}/coded/enut/ENUT_FARC_PSM.dta", clear

	* PSM sample
	file write latex " \multicolumn{9}{l}{Panel C. Propensity score matching sample} \\" _n
	foreach i in $out {
		
		foreach a of numlist 0/1 {
			
			mean `i'd [pw=F_EXP] if TIME==0 & CONFLICT==`a'
			scalar m1 = e(b)[1,1]
			scalar sd1 = e(sd)[1,1]
		
			global m_d`a'_`i': di %10.2f m1
			global sd_d`a'_`i': di %10.2f sd1
			
			mean `i'c [pw=F_EXP] if TIME==0 & CONFLICT==`a'
			scalar m2 = e(b)[1,1]
			scalar sd2 = e(sd)[1,1]
			
			global m_c`a'_`i': di %10.2f m2
			global sd_c`a'_`i': di %10.2f sd2

		}
		
		local lab: variable label `i'
		file write latex " \hspace{3mm} `lab' & ${m_d1_`i'} & ${sd_d1_`i'} && ${m_d0_`i'} & ${sd_d0_`i'} && ${m_c1_`i'} & ${sd_c1_`i'} && ${m_c0_`i'} & ${sd_c0_`i'} \\" _n
	}
	
	file write latex "\hline \hline" _n
	file write latex "\end{tabular}" _n
	file close latex
	
