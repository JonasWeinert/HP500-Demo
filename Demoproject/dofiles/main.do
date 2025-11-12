********************************************************************************
* PROJECT: 
* TITLE:
/*******************************************************************************

*** Outline:
		Part 0: 	
		Part 1: 	   
		Part 2: 	   
		Part 3: 	  

*** OBSERVATIONS:	

*** ID VAR (HOUSEHOLD):

*** WRITTEN BY:

*** LAST TIME MODIFIED:

********************************************************************************
* 					PART 0: Set initial configurations and globals
*******************************************************************************/

	ssc install ietoolkit

	ieboilstart, version(14.0)
	`r(version)'
	
*** Setting up users
	global project		"/Users/paulinepearcy/Documents/PhD/HP500/HP500-Demo"
	
	
**** Setting up folders
	global data			"${project}/data"
	global dofiles		"..."
	global outputs		"..."
	global tables		"..."
	global figures		"${project}/outputs/figures"
	
	// Esttab options
	global stars1		"label nolines nogaps fragment nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01) collabels(none) booktabs"
	global stars2		"label nolines nogaps fragment nomtitle nonumbers nodep star(* 0.10 ** 0.05 *** 0.01) collabels(none) booktabs r2"		

	global main_tables        1   /// See switch

	
	// sysdir set PLUS "{project}/ado"
	
	
*** Install required packages
	local install_packages 	1

	if `install_packages' {
		ssc install estout, replace
		ssc install outreg2, replace
		ssc install lassopack, replace
		ssc install ietoolkit, replace
	}

********************************************************************************
*	Part 1:  
********************************************************************************

*** Creating easy to read long versions of datasets
	*** Execute dofiles
	if (${main_tables} == 1) {
		do "{project}/QJPS_Figures_Table_Replication_Code.do"
	}




