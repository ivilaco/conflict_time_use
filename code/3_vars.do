/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
2_vars.do

This do file creates the variables needed for the analisis from the unified
ENUT database
=========================================================================*/

	use "${data}/coded/enut/ENUT_TOTAL.dta", clear
	gen unos=1
	
*******************************************
*** Dummy year ***
*******************************************

	gen TIME = (ANNO == "2016-2017" | ANNO == "2020-2021")
	gen TIME2016 = (ANNO == "2016-2017")
	gen TIME2020 = (ANNO == "2020-2021")
	lab define c 1 "After ceasefire > 2014" 0 "Before ceasefire < 2014"
	lab values TIME c
	replace ANNO = "2012" if ANNO == "2012-2013"
	replace ANNO = "2016" if ANNO == "2016-2017"
	replace ANNO = "2020" if ANNO == "2020-2021"
	destring ANNO, replace
	
*******************************************
*** Identifiers ***
*******************************************

	* i. Identificador único de persona 
	*unique 	DIRECTORIO SECUENCIA_P ORDEN
	egen 	personid = group(DIRECTORIO SECUENCIA_P ORDEN)
			
	* ii. Identificador único de Hogar
	*unique	DIRECTORIO SECUENCIA_P	
	egen 	idhogar = group(DIRECTORIO SECUENCIA_P)
	
	* iii. Orden de Variables
	order 	idhogar personid DIRECTORIO ORDEN SECUENCIA_P 
	sort 	idhogar DIRECTORIO ORDEN SECUENCIA_P 

*******************************************
*** Sociodemographics ***
*******************************************

	* i. Sexo
	tab P6020, m
	recode P6020 (1 = 0) (2 = 1)
	label define sexo 1 "Female" 0 "Male"
	label value P6020 sexo
	label var P6020 "Sexo (1: Mujer)"
	rename P6020 SEXO
		
	* ii. Educación jefe del hogar
	replace P6210=2 if P6210==3
	replace P6210=3 if P6210==4		
	replace P6210=4 if P6210>4
		
	bys idhogar : gen EDU = P6210 if P425==1
	bys idhogar (EDU): replace EDU = EDU[1] if missing(EDU)
	bys idhogar (EDU): replace EDU = P6210[1] if missing(EDU)

	* iii. Edad
	tab P6040, nolabel
	label var P6040 "Edad en años"
	format P6040 %9.0g
	rename P6040 EDAD
		
	* iv. Asset holdings
	label define ing 1 "Si" 0 "No"
	foreach i in P1176S1 P1176S2 P1176S3 P1176S4 P1176S5 P1176S6 P1176S7 P1176S9 P1176S10 P1176S11 P1176S12 {
		destring `i', replace
		replace `i'=0 if `i'==2
		label value `i' ing
	}
	egen INGRESO = rowtotal(P1176S1 P1176S2 P1176S3 P1176S4 P1176S5 P1176S6 P1176S7 P1176S9 P1176S10 P1176S11 P1176S12), m
	sum INGRESO, d
	gen m_i = `= r(p50)'
	gen ingdummy=.
	replace ingdummy=1 if INGRESO>=m_i
	replace ingdummy=0 if INGRESO<m_i
		
	* v. Kids in the house
	bys idhogar ANNO : egen kids=count(unos) if EDAD<18
	
	* vi. Region
	label define region 1 "Caribe" 2 "Central" 3 "Oriental" 4 "Pacifica" 5 "Bogota" 6 "San Andres"
	label value REGION region
	
	* vii. Porcentage of hhs according to gender and head of household by municipality
	replace P425 = P425 - 1 if P425 >=6 & ANNO == 2020
	gen jefe = (P425 == 1)

*******************************************
*** Dependent variables ***
*******************************************

	* i. NON-NTTA dependent variables
	egen MW = rowtotal($mw P1129S1A1 P1129S1A2), m // labour market
	egen NW1 = rowtotal($nw1), m // Leisure & self-care
	egen NW2 = rowtotal($nw2), m // Sleep
	egen NW3 = rowtotal($nw3), m // Education
	
	* ii. NTTA dependent variables
	egen CH = rowtotal($ch), m // Housework
	egen CU = rowtotal($cu), m // Care

	* iii. Otros
	egen otro = rowtotal($otro), m
			
	* iv. Con ceros y dummys
	foreach i in MW NW1 NW2 NW3 CH CU otro{
		gen `i'c = `i'
		replace `i'c=0 if `i'c==.
		gen `i'd = 0
		replace `i'd = 1 if `i'>0 & !missing(`i')
	}

*******************************************
*** Labeling ***
*******************************************
	
	lab variable MW "Labour market"
	lab variable NW1 "Leisure and self-care"
	lab variable NW2 "Sleep"
	lab variable NW3 "Education"
	lab variable CH "Household activities"
	lab variable CU "Care of individuals"
	
	lab variable MWc "Labour market"
	lab variable NW1c "Leisure and self-care"
	lab variable NW2c "Sleep"
	lab variable NW3c "Education"
	lab variable CHc "Household activities"
	lab variable CUc "Care of individuals"
	
	lab variable MWd "Labour market"
	lab variable NW1d "Leisure and self-care"
	lab variable NW2d "Sleep"
	lab variable NW3d "Education"
	lab variable CHd "Household activities"
	lab variable CUd "Care of individuals"
	
*******************************************
*** Analysis vars for mechanisms ***
*******************************************

	* Acceso a salud
	rename P6090 SALUD
	destring SALUD, replace
	replace SALUD=. if SALUD!=1 & SALUD!=2	
	bys idhogar TIME: egen salud=count(unos) if SALUD==1
		
	* Discapacitados
	egen DIS = rowtotal(P1169S*)
	replace DIS=1 if DIS>0
		
	* Miemrbos del hogar
	bys idhogar TIME: egen hht=count(unos) 
	bys idhogar TIME: egen hhtm=count(unos) if SEXO==1 
	bys idhogar TIME: egen hhth=count(unos) if SEXO==0
	bys idhogar TIME: egen hhthj=count(unos) if SEXO==0 & EDAD>13 & EDAD<29
		
	bys idhogar TIME: egen hhta=count(unos) if EDAD>13 & EDAD<29
	bys idhogar TIME: egen hhtk=count(unos) if EDAD<13 
	bys idhogar TIME: egen hdist=count(unos) if DIS==1 
	
*******************************************
*** Removing outliers and unwanted obs ***
*******************************************

	* Removing percentile 99 and keeping all sample
	foreach i in $ceros {
		sum `i', d
		gen t_`i' = `= r(p99)'
		drop if `i' > t_`i'
	}
	save "${data}/coded/enut/ENUT_TOTAL_ALL.dta", replace

	* Removing percentile 99 y keeping only young population
	keep if EDAD>13 & EDAD<29 

	save "${data}/coded/enut/ENUT_TOTAL_J.dta", replace
	