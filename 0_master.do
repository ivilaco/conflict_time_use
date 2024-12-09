/*=========================================================================
Young people and household caring in the postwar
Code author: Ivonne Lara
--------------------------------------------------------------------------
0_master.do
=========================================================================*/

*******************************************
*** SET MAIN ENVIRONMENT ***
*******************************************

	clear all
	set more off
	
******** Working directory
	
	/* DANE (Verificar como estan construidas las carpetas en el DANE)
	glo main "/Users/ivonnelara/Documents/Working Papers/conflict_time_use"
	
	glo entra "${main}/ENTRA"
	glo enut "${main}/ENUT"
	glo sale "${main}/SALE"
	*/
		
	* Personal
	glo main "/Users/ivonnelara/Documents/Tesis/IVONNE LARA/ENTRA"
	glo desktop "/Users/ivonnelara/Dropbox/WORK/Working Papers/conflict_time_use"
	
	glo code "${main}/code"
	glo data "${desktop}/data"
	glo output "${desktop}/output"
	*
	
	cd "${main}"
	
	* Setting the ado path with required packages
	sysdir set PLUS "${main}/code/ado"
	
	/* Install packages
	ssc install spmap, replace
	ssc install shp2dta, replace
	ssc install mif2dta, replace
	ssc install psmatch2, replace
	*ssc install st0026_2, replace
	ssc install spmap, replace
	ssc install shp2dta, replace
	ssc install mif2dta, replace
	ssc install rwolf, replace
	ssc install rwolf2, replace
	ssc install parmest
	net install wyoung, from("https://raw.githubusercontent.com/reifjulian/wyoung/master")// ssc install wyoung, replace
	*/
		
	* Start log
	cap log close
	
*******************************************
*** ADDITIONAL GLOBALS ***
*******************************************
	
	* Independent variables
	glo mw "P1124S2A1 P1124S2A2 P1124S1A1 P1124S1A2 P1126S1A1 P1126S1A2 P1126S2A1 P1126S2A2 P1126S3A1 P1126S3A2 P1126S4A1 P1126S4A2 P1126S5A1 P1126S5A2 P1126S6A1 P1126S6A2 P1126S7A2 P1126S7A3 P1150S1 P1150S2 P1099S1 P1099S2 P6535S1A1 P6535S1A2 P6534S1 P6534S2"
	glo nw1 "P1166S2A1 P1166S2A2 P1166S1A1 P1166S1A2 P1153S1A1 P1153S1A2 P1153S2A1 P1153S2A2 P1153S4A1 P1153S4A2 P1153S5A1 P1153S5A2 P1113S1A1 P1113S1A2 P1113S2A1 P1113S2A2 P1111S1A1 P1111S1A2 P1112S1A1 P1112S1A2 P1112S2A1 P1112S2A2 P1111S2A1 P1111S2A2 P1110S1A1 P1110S1A2 P1110S2A1 P1110S2A2 P1110S3A1 P1110S3A2 P1110S4A1 P1110S4A2 P1110S5A1 P1110S5A2 P1110S6A1 P1110S6A2 P1110S7A1 P1110S7A2 P1110S8A1 P1110S8A2 P1111S3A1 P1111S3A2 P1111S4A1 P1111S4A2 P1144S6A1 P1144S6A2 P1111S5A1 P1111S5A2 P1153S6A1 P1153S6A2 P1144S2A1 P1144S2A2 P1144S3A1 P1144S3A2 P1144S4A1 P1144S4A2 P1144S5A1 P1144S5A2"
	glo nw2 "P1153S3A1 P1153S3A2 P1144S1A1 P1144S1A2"
	glo nw3 "P1159S1 P1159S2 P1155S1 P1155S2 P1161S1A1 P1161S1A2 P1161S2A1 P1161S2A2 P1161S3A1 P1161S3A2 P1161S4A1 P1161S4A2 P1161S5A2 P1161S5A3 P1160S1A1 P1160S1A2 P1156S1 P1156S2"
	glo ch "P1143S1A1 P1143S1A2 P1143S2A1 P1143S2A2 P1143S4A1 P1143S4A2 P1143S3A1 P1143S3A2 P1142S1A1 P1142S1A2 P1142S2A1 P1142S2A2 P1142S3A1 P1142S3A2 P1142S4A1 P1142S4A2 P1136S1A1 P1136S1A2 P1136S2A1 P1136S2A2 P1136S3A1 P1136S3A2 P1136S4A1 P1136S4A2 P1136S5A1 P1136S5A2 P1136S6A1 P1136S6A2 P1136S7A1 P1136S7A2 P1141S1A1 P1141S1A2 P1141S2A1 P1141S2A2 P1141S3A1 P1141S3A2 P1141S4A1 P1141S4A2 P1140S1A1 P1140S1A2 P1140S2A1 P1140S2A2 P1140S4A1 P1140S4A2 P1140S6A1 P1140S6A2 P1140S3A1 P1140S3A2 P1140S5A1 P1140S5A2 P1128S8A1 P1128S8A2 P1140S7A1 P1140S7A2 P1131S1A3 P1131S1A4 P1131S2A3 P1131S2A4 P1131S3A3 P1131S3A4 P1128S1A1 P1128S1A2 P1128S2A1 P1128S2A2 P1128S3A1 P1128S3A2 P1125S1A1 P1125S1A2 P1125S2A1 P1125S2A2 P1125S3A1 P1125S3A2 P1125S4A1 P1125S4A2 P1125S5A1 P1125S5A2 P1125S6A1 P1125S6A2 P1125S7A2 P1125S7A3 P6530S1A1 P6530S1A2"
	glo cu "P1139S1A1 P1139S1A2 P1139S2A1 P1139S2A2 P1139S3A1 P1139S3A2 P1137S1A1 P1137S1A2 P1137S2A1 P1137S2A2 P1137S3A1 P1137S3A2 P1135S1A1 P1135S1A2 P1135S2A1 P1135S2A2 P1135S3A1 P1135S3A2 P1134S1A1 P1134S1A2 P1134S2A1 P1134S2A2 P1134S3A1 P1134S3A2 P1133S1A1 P1133S1A2 P1133S2A1 P1133S2A2 P1133S3A1 P1133S3A2 P1132S1A1 P1132S1A2 P1132S2A1 P1132S2A2 P1132S3A1 P1132S3A2 P1131S1A1 P1131S1A2 P1131S2A1 P1131S2A2 P1131S3A1 P1131S3A2 P1114S1A1 P1114S1A2 P1114S2A1 P1114S2A2 P1114S3A1 P1114S3A2 P1114S4A1 P1114S4A2 P1128S4A1 P1128S4A2 P1128S5A1 P1128S5A2 P1128S6A1 P1128S6A2 P1128S7A1 P1128S7A2 P1127S1A1 P1127S1A2 P1127S3A1 P1127S3A2 P1127S4A1 P1127S4A2 P1127S2A1 P1127S2A2"
	glo otro "P1122S1A2 P1122S1A3 P1122S2A2 P1122S2A3 P1122S3A2 P1122S3A3"
	
	* Other variables
	glo out "MW NW1 NW2 NW3 CH CU"
	glo ceros "MWc NW1c NW2c NW3c CHc CUc"
	glo dummys "MWd NW1d NW2d NW3d CHd CUd"
	glo mecs "hht hhtm hhth hhthj hhta hhtk hdist"
	glo covs "gcaribe retro_pobl_rur pobl_rur dismdo disbogota mercado_cercano distancia_mercado pib_agricola pib_industria pib_servicios pib_total nbicabecera IPM_rur ipm_ledu_p ipm_templeof_p v9 v11 v18 v22 v23 v25 v26 v4 v20"
	global controls "v4_c v20_c"
	
*******************************************
*** CODE ***
*******************************************

	* Creates de covariables and additional variables for analysis from external databases
	do "${code}/1_covars.do" // Github
	
	* Cleans de ENUT databases and merges them
	do "${code}/2_cleaning.do" // DANE
	
	* Creates variables of interest from ENUT database
	do "${code}/3_vars.do" // DANE

	* Merges the covariables with the ENUT to build the final databse
	do "${code}/4_final_database.do" // DANE

	* Creates stats on relevant variables
	do "${code}/5_stats.do" // DANE

	* Runs the main regressions
	do "${code}/6_regs_main.do" // DANE

	* Runs robustness
	do "${code}/7_robustness.do" // DANE
