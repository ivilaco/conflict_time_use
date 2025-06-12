/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
4_final_database.do

This do creates the final database for analysis
=========================================================================*/

	foreach j in J ALL {

		* Pego con el tratamiento
		use "$entra/FARC_final.dta", clear
		merge 1:m MUNICIPIO TIME using "$enut/ENUT_TOTAL_`j'.dta", gen(_merge7)
		keep if _merge7==3 // Se van las capitales JFV. Obs: 42,281
		
		* Pego covariables
		merge m:1 MUNICIPIO using "$entra/new_vars.dta", gen(_merge2)

		*unique MUNICIPIO // 202 mpios 
		*tab CONFLICT // No conflict: 33,549 (79.3%) Conflict: 8,732 (20.6%)
		*tab CONFLICT1 // No conflict: 17,064 (40.3%) Conflict: 25,217 (59.6%)

		* Miro cuandos municipios finales tengo para cada tratamiento
		preserve
		keep CONFLICT MUNICIPIO CONFLICT1
		duplicates drop MUNICIPIO, force
		save "$enut/MUNS_finales_`j'.dta", replace
		tab CONFLICT // No conflict (mpios): 166 (82.2%) Conflict (mpios): 36 (17.8%)
		tab CONFLICT1 // No conflict (mpios): 81 (40.1%) Conflict (mpios): 121 (59.9%)
		restore
		
		* Creo el tratamiento interactuado
		gen conflict_time = CONFLICT*TIME
		gen conflict_time2016 = CONFLICT*TIME2016
		gen conflict_time2020 = CONFLICT*TIME2020
		gen conflict_time1 = CONFLICT1*TIME
		gen conflict_time12016 = CONFLICT1*TIME2016
		gen conflict_time12020 = CONFLICT1*TIME2020
		
		* Variables de interes
		keep conflict_time* CONFLICT* TIME* ANNO* MUNICIPIO $out $ceros $dummys ingdummy INGRESO EDAD EDU SEXO DIRECTORIO SECUENCIA_P ORDEN personid idhogar SEXO REGION unos $covs DIS $mecs SALUD salud P1174 P1172 jefe P425
		
		* Modifico var municipio
		tostring MUNICIPIO, replace
		replace MUNICIPIO = "0" + MUNICIPIO if length(MUNICIPIO) == 4
		gen DEPTO = substr(MUNICIPIO,1,2)
		destring MUNICIPIO DEPTO, replace
		
		* Variables por hogar
		rename (P1174 P1172) (compa_jef conyuge_hogar)
		bys idhogar TIME : egen htot1=count(unos) if CONFLICT==1
		bys idhogar TIME : egen htot0=count(unos) if CONFLICT==0
		forvalues i=0/1 {
			bys idhogar TIME : egen hdis`i'=count(unos) if DIS==1 & CONFLICT==`i'
			gen hdis_p`i' = (hdis`i'/htot`i')*100
		}

		forvalues i=0/1 {
			bys idhogar TIME : egen hh`i'=count(unos) if SEXO==0 & CONFLICT==`i'
			bys idhogar TIME : egen hhcu`i'=count(unos) if SEXO==0 & CUd==1 & CONFLICT==`i'
			bys idhogar TIME : egen hhch`i'=count(unos) if SEXO==0 & CHd==1 & CONFLICT==`i'
			gen hh_p`i' = (hh`i'/htot`i')*100
			gen hhcu_p`i' = (hhcu`i'/hh`i')*100
			gen hhch_p`i' = (hhch`i'/hh`i')*100
		}
		
		tab EDU, gen(edu)
	
		* Controls
			foreach i in v4 v20 {
			gen `i'_c=`i'*TIME
		}
	
		* Guardo base final
		save "$enut/ENUT_FARC_`j'.dta", replace
	}

* ----------------------------------------------------------------------*
* IV. Additional variables for analysis (REVISAR SI SE NECESITA)
* ----------------------------------------------------------------------*/

	use "$enut/ENUT_FARC_ALL.dta", clear
		
		* Porcentaje de hogares donde la mujer es jefe del hogar
		bys ANNO MUNICIPIO : egen hhs_j = sum(jefe) // Tomamos en cuenta los hogares que tienen jefe del hogar
		bys ANNO MUNICIPIO : egen hhs_jm = sum(jefe) if SEXO == 1
		
		* Porcentaje de hogares donde el conyuge esta presente
		bys ANNO MUNICIPIO : egen hhs_c = sum(jefe) if conyuge_hogar == 1
		
		* Mecanismo 2 - Household Re-Composition
		gen p_hhth = (hhth/hht)*100
		gen p_hhthj = (hhthj/hht)*100
		gen p_hdist = (hdist/hht)*100
		gen p_hhs_jm = (hhs_jm/hhs_j)*100	
		gen p_hhs_c = (hhs_c/hhs_j)*100	
		
	save "$enut/ENUT_FARC_ALL.dta", replace
	