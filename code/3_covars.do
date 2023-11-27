/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
3_covars.do

This do file creates the covariables and additional variables needed for 
the analysis
=========================================================================*/

*******************************************
*** TREATMENT ***
*******************************************

	use "${data}/raw/FARC_presence_pre_ceasefire.dta", clear
	rename M_code MUNICIPIO
	
	* Conflict 1 (Santos dos periodos)
	gen CONFLICT = (UR_farc_santos1>0)
	rename UR_farc_santos1 UR_FARC_S
	
	*Conflict 2 (Uribe dos periodos)
	gen CONFLICT1 = (UR_farc_uribe1>0)
	rename UR_farc_uribe1 UR_FARC_U1
	
	keep MUNICIPIO CONFLICT CONFLICT1 UR_FARC_S UR_FARC_U1
	lab define b 1 "Conflict" 0 "No Conflict"
	lab values CONFLICT CONFLICT1 b
	
	save "${data}/coded/FARC.dta", replace
	
*******************************************
*** COVARIABLES PSM ***
*******************************************

	use "${data}/raw/PANEL_CARACTERISTICAS_GENERALES(2020).dta", clear
	rename codmpio MUNICIPIO
	merge m:1 MUNICIPIO using "${data}/coded/FARC.dta"
	keep if _merge==3
	drop if ano<2005
	gen TIME=1 if ano>2014
	replace TIME=0 if ano<2014
	drop if ano>2013
	
	* NEW VARS
	*glob hola2 "ao_crea gandina gcaribe gpacifica gorinoquia gamazonia retro_pobl_rur retro_pobl_urb retro_pobl_tot pobl_rur pobl_urb pobl_tot indrural areaoficialkm2 areaoficialhm2 altura discapital dismdo disbogota mercado_cercano distancia_mercado pib_cons pib_percapita_cons pib_agricola pib_industria pib_servicios pib_total pib_percapita gpc gini pobreza nbi nbicabecera nbiresto minorias parques religioso estado otras IPM IPM_urb IPM_rur ipm_ledu_p ipm_analf_p ipm_asisescu_p ipm_rezagoescu_p ipm_serv_pinf_p ipm_ti_p ipm_tdep_p ipm_templeof_p ipm_assalud_p ipm_accsalud_p ipm_accagua_p ipm_excretas_p ipm_pisos_p ipm_paredes_p ipm_hacinam_p"
	
	glob hola "gcaribe retro_pobl_rur pobl_rur dismdo disbogota mercado_cercano distancia_mercado pib_agricola pib_industria pib_servicios pib_total nbicabecera IPM_rur ipm_ledu_p ipm_templeof_p"
	keep $hola
	
	local j = 0
	foreach i in $hola {
		local j = `j'+1
		preserve
		keep `i' MUNICIPIO ano CONFLICT
		sort MUNICIPIO ano
		gen cont=_n
		drop if missing(`i')
		bys MUNICIPIO : egen ano2=max(ano)
		keep if ano2==ano
		keep `i' MUNICIPIO CONFLICT ano2 ano
			if `j' == 1 {
			tempfile w1
			save `w1', replace
			save "${data}/coded/new_vars.dta", replace
			} 
			else if `j'!=1 {
			merge 1:1 MUNICIPIO using `w1', gen(_merge)
			drop _merge
			save `w1', replace
			save "${data}/coded/new_vars.dta", replace
			}
		restore
	}
	
	use "${data}/coded/new_vars.dta", clear // Este archivo se debe mandar al DANE********
	
	drop CONFLICT ano ano2
	logit CONFLICT $hola
	
	* A. Covs
	foreach i of numlist 1 8/12 18/20 22/27 29 {
	import excel "${data}/raw/PSM_covariables.xlsx", sheet("`i'") firstrow clear
	rename cod_ent cod_mpio	
	destring cod_mpio v`i' year, replace
	drop if v`i'==.
	*drop if year>2014
	*drop if year<2000 
	*reshape wide v`i', i(cod_mpio) j(year)
	*egen v`i'_ = rowmean(v`i'20*)
	keep cod_mpio v`i' year
	drop if year<2005
	rename cod_mpio MUNICIPIO
	drop if year==2014
	gen TIME=1 if year>2014
	replace TIME=0 if year<2014	
	keep year v`i' MUNICIPIO TIME
	drop if v`i'==.
	bys MUNICIPIO : egen maximo=max(year) if TIME==0
	bys MUNICIPIO : egen minimo=min(year) if TIME==1
	drop if year!=maximo & TIME==0
	drop if year!=minimo & TIME==1
	drop year maximo minimo
	save "${data}/coded/v`i'.dta", replace
	}

	/* B. IPM (Índice de Pobreza Multidimensional 2005) TerriData DNP
	import excel "$cov/PSM_covariables.xlsx", sheet("4") firstrow clear
	destring cod_dpto cod_ent v4 year, replace
	drop if depto=="Colombia"
	rename cod_ent cod_mpio
	keep v4 cod_mpio
	save "$cov/v4.dta", replace */
	
	use "${enut}/COVS.dta", replace // De donde sale este? :(
	keep IPM ano codmpio
	rename ano year
	rename codmpio cod_mpio
	rename IPM v4
	drop if year<2005
	rename cod_mpio MUNICIPIO
	drop if year==2014
	gen TIME=1 if year>2014
	replace TIME=0 if year<2014
	keep year v4 MUNICIPIO TIME
	drop if v4==.
	bys MUNICIPIO : egen maximo=max(year) if TIME==0
	bys MUNICIPIO : egen minimo=min(year) if TIME==1
	drop if year!=maximo & TIME==0
	drop if year!=minimo & TIME==1
	drop year maximo minimo
	save "${data}/coded/v4.dta", replace
	
	* Pegamos las variables
	use "${data}/coded/v4.dta", clear
	foreach i of numlist 1 8/12 18/20 22/27 29 {
	merge 1:1 MUNICIPIO TIME using "${data}/coded/v`i'.dta"
	*drop if _merge==2
	drop _merge
	}
	save "${data}/coded/COVS.dta", replace
	
	* Probamos las variables con el tratamiento
	use "${data}/coded/COVS.dta", clear
	merge m:1 MUNICIPIO using "${data}/coded/FARC.dta"
	keep if _merge==3
	drop _merge	
	save "${data}/coded/FARC_final.dta", replace // Este archivo se debe mandar al DANE********
	
*******************************************
*** VARIABLES CEDE CONFLICT ***
*******************************************

	use "${data}/raw/PANEL_CONFLICTO_Y_VIOLENCIA(2020).dta", clear
	
	keep desplazados_expulsion desplazados_recepcion codmpio ano
	rename codmpio MUNICIPIO
	drop if ano<2010
	merge n:1 MUNICIPIO using "${data}/coded/FARC.dta"
	keep if _merge==3
	gen TIME = (ano>2014)
	drop _merge
	merge 1:1 MUNICIPIO ano using "${data}/raw/poblacion.dta"
	keep if _merge==3

	gen conflict_time = TIME*CONFLICT
	gen prop_desp_recep = (desplazados_recepcion/pobl_tot)*100
	gen prop_desp_expul = (desplazados_expulsion/pobl_tot)*100
	
	sum prop_desp_recep prop_desp_expul
	
	* Regresion
	file open latexm2 using "${output}/mig.txt", write replace text
	file write latexm2 "\begin{tabular}{l c c} \\ \hline \hline" _n
	file write latexm2 "& Received & Expelled \\ " _n
	file write latexm2 "& (1) & (2) \\ \hline" _n

	foreach i in prop_desp_recep prop_desp_expul {
		
		reg `i' conflict_time i.MUNICIPIO i.ano
		local b: di %4.3f `= _b[conflict_time]'
		global seb_`i': di %4.3f `= _se[conflict_time]'
		local tb=_b[conflict_time]/_se[conflict_time]
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
	
	file write latexm2 " Conflict x Time & ${bb_prop_desp_recep} & ${bb_prop_desp_expul} \\" _n
	file write latexm2 "  & (${seb_prop_desp_recep}) & (${seb_prop_desp_expul}) \\" _n

	file write latexm2 " Observations & ${N_prop_desp_recep} & ${N_prop_desp_expul}\\" _n
	file write latexm2 " R-squared & ${r2_prop_desp_recep} & ${r2_prop_desp_expul} \\" _n
	file write latexm2 "\hline" _n

	file write latexm2 "Mean & ${m1_prop_desp_recep} & ${m1_prop_desp_expul} \\" _n
	file write latexm2 "Standard Deviation & ${p1_prop_desp_recep} & ${p1_prop_desp_expul}  \\" _n		
	file write latexm2 "Year FE & $\checkmark$ & $\checkmark$ \\" _n	
	file write latexm2 "Municipality FE & $\checkmark$ & $\checkmark$ \\" _n	
	file write latexm2 "\hline \hline" _n
	file write latexm2 "\end{tabular}" _n
	file close latexm2
	
	reg prop_desp_recep conflict_time i.MUNICIPIO i.ano // i.MUNICIPIO i.ano - después de agregar efectos fijos se vuelve significativo
	reg prop_desp_expul conflict_time i.MUNICIPIO i.ano // i.MUNICIPIO i.ano
	
*******************************************
*** CENSUS ***
*******************************************

	foreach i in 05 08 11 13 15 17 18 19 20 23 25 27 41 44 47 50 52 54 63 66 68 70 73 76 81 85 86 88 91 94 95 97 99 {
	
	use "${data}/raw/CNPV2018_5PER_A2_`i'.DTA", clear
	
	keep u_mpio p_nrohog p_nro_per pa_vivia_5anos pa_vivia_1ano p_edadr u_dpto
	gen unos=1
	gen MUNICIPIO = u_dpto + u_mpio
	destring MUNICIPIO, replace
	
	merge m:1 MUNICIPIO using "$v/FARC.dta"
	
	keep if _merge==3

	drop u_mpio p_nrohog p_nro_per u_dpto
	save "${data}/coded/censo_depto_`i'.dta", replace
	}
	
	use "${data}/coded/censo_depto_05.dta", clear
	foreach i in 08 11 13 15 17 18 19 20 23 25 27 41 44 47 50 52 54 63 66 68 70 73 76 81 85 86 88 91 94 95 97 99 {
		append using "${data}/coded/censo_depto_`i'.dta"
	}
	
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
	
	use "${data}/coded/censo_depto_total.dta", clear
	
	* Regresion
	file open latexm1 using "${output}/censo.txt", write replace text
	file write latexm1 "\begin{tabular}{l c c c c} \\ \hline \hline" _n
	file write latexm1 "& \multicolumn{2}{c}{Total population} & \multicolumn{2}{c}{Young population} \\ \cline{2-5}" _n
	file write latexm1 "& Five years back & One year back & Five years back & One year back \\ " _n
	file write latexm1 "& (1) & (2) & (3) & (4) \\ \hline" _n

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
	
	file write latexm1 " Conflict & ${bb_vivia_5} & ${bb_vivia_1} & ${bb_vivia_5y} & ${bb_vivia_1y} \\" _n
	file write latexm1 "  & (${seb_vivia_5}) & (${seb_vivia_1}) & (${seb_vivia_5y}) & (${seb_vivia_1y}) \\" _n

	file write latexm1 " Observations & ${N_vivia_5} & ${N_vivia_1} & ${N_vivia_5y} & ${N_vivia_1y} \\" _n
	file write latexm1 " R-squared & ${r2_vivia_5} & ${r2_vivia_1} & ${r2_vivia_5y} & ${r2_vivia_1y} \\" _n
	file write latexm1 "\hline" _n

	file write latexm1 "Mean & ${m1_vivia_5} & ${m1_vivia_1} & ${m1_vivia_5y} & ${m1_vivia_1y} \\" _n
	file write latexm1 "Standard Deviation & ${p1_vivia_5} & ${p1_vivia_1} & ${p1_vivia_5y} & ${p1_vivia_1y} \\" _n		
	file write latexm1 "Municipality FE & $\checkmark$ & $\checkmark$ & $\checkmark$ & $\checkmark$ \\" _n	
	file write latexm1 "\hline \hline" _n
	file write latexm1 "\end{tabular}" _n
	file close latexm1
