*******************************************
*** CREATING QJPS TABLES AND FIGURES
*** Last edited May 3, 2021 by KB
******************************************

**************************************************************************
*** TABLE 1. COMPARING VILLAGE CHIEFS TO ADVISORS AND CIVIL SOCIETY LEADERS
**************************************************************************


*** Column 1: VCs

use "/Onedrive/julia/Documents/GitHub/HP500-Demo/Demoproject/data/VHdata_QJPS_labeled.dta", clear

local 	vars				///
		womenVH 			///
		age 				///
		moreprimary 		///
		logcattlewealth 	///
		VH_bornvillage 		///
		ZANUPF_para 		///
		wantmorepowerdare 	///
		testattitudes 		///
		testknowledge		
		
eststo Table1a: estpost sum  `vars' if VH_treat==0
esttab Table1a using "/Users/jonas/Documents/GitHub/HP500-Demo/Demoproject/outputs/tables/Table1a", tex replace cells("mean(fmt(a3))" sd(par fmt(a3))) label nodepvar noobs onecell

*** Column 2: Existing advisers

use "/Onedrive/julia/Documents/GitHub/HP500-Demo/Demoproject/data/CLdata_QJPS_labeled.dta", clear

local 	vars				///
		female 				///
		O2 					///
		finishedprim 		///
		logcattlewealth 	///
		bornvillage 		///
		VHethnicmatch 		///
		relative 			///
		sign 				///
		morepowerdare 		///
		testattitudesCL 	///
		testknowledgeCL 
		
eststo Table1b1: estpost sum `vars' if dare==1 & VH_treat==0

*** Column 3: Other Civil Society Leaders
eststo Table1b2: estpost sum `vars' if dare==0 & VH_treat==0

esttab Table1b1 Table1b2 using "/Users/jonas/Documents/GitHub/HP500-Demo/Demoproject/outputs/tables/Table1b", tex replace cells("mean(fmt(a3))" sd(par fmt(a3))) label nodepvar noobs onecell

**************************************************************************
*** TABLE 2
**************************************************************************

// Table 2, column 1 from administrative data (No replication data available)

// Notes: Table 2, rows 1-6: Output from tabulations below, not automated
// Only rows 1-8 in columns 2-4 are automated

use "/Users/jonas/Documents/GitHub/HP500-Demo/Demoproject/data/CLdata_QJPS_labeled.dta", clear
tab X1 if dare!=1

eststo E1a: estpost sum female if dare!=1
sum relative if dare!=1
local pat_relative = r(mean)/2
estadd loc paternalrelative "`pat_relative'"

**Table 2, column 3:
tab X1 if dare==1

eststo E1b: estpost sum female if dare==1
sum relative if dare==1
local pat_relative = r(mean)/2
estadd loc paternalrelative "`pat_relative'"

**Table 2, column 4:

use "/Users/jonas/Documents/GitHub/HP500-Demo/Demoproject/data/HHdata_QJPS_labeled.dta", clear

eststo E1c: estpost sum female if D37!=1
sum VHfam if D37!=1
local pat_relative = r(mean)/2
estadd loc paternalrelative "`pat_relative'"

esttab E1a E1b E1c using "/Users/jonas/Documents/GitHub/HP500-Demo/Demoproject/outputs/tables/TableE1", tex replace cells("mean(fmt(a3))" sd(par fmt(a3))) stats(paternalrelative) label nodepvar noobs onecell

**************************************************************************
*** FIGURE 3 - The following code creates Figure 3 in the Paper
**************************************************************************

use "/Users/jonas/Documents/GitHub/HP500-Demo/Demoproject/data/VHdata_QJPS_labeled.dta", clear

* generate a variable that is uniformly distributed

gen test_var = runiform()

reg st_proceduresindex VH_treat cl i.block test_var

matrix est=e(b)
gen VHhat =est[1,1]
gen CLhat = est[1,2]
matrix var=e(V)
gen VHse =sqrt(var[1,1])
gen CLse = sqrt(var[2,2])
lincom VH_treat + cl
gen VHCLhat = `r(estimate)'
gen VHCLse = `r(se)'

gen VHupper=VHhat + 1.96*VHse
gen VHlower=VHhat - 1.96*VHse

gen CLupper=CLhat + 1.96*CLse
gen CLlower=CLhat - 1.96*CLse

gen VHCLupper=VHCLhat + 1.96*VHCLse
gen VHCLlower=VHCLhat - 1.96*VHCLse

// Generate a 3-obs dataset for creating plot

keep if _n<4
gen coefficientname = ""
replace coefficientname="Effect of Workshop for VC" if _n==1
replace coefficientname="Effect of Workshop for VC + CL" if _n==2
replace coefficientname="Effect of CL" if _n==3

gen ordering = _n

gen coef = VHhat if coefficientname=="Effect of Workshop for VC"
replace coef = VHCLhat if coefficientname=="Effect of Workshop for VC + CL"
replace coef = CLhat if coefficientname =="Effect of CL"

gen upper = VHupper if coefficientname=="Effect of Workshop for VC"
replace upper = VHCLupper if coefficientname=="Effect of Workshop for VC + CL"
replace upper = CLupper if coefficientname == "Effect of CL"

gen lower = VHlower if coefficientname=="Effect of Workshop for VC"
replace lower = VHCLlower if coefficientname=="Effect of Workshop for VC + CL"
replace lower = CLlower if coefficientname == "Effect of CL"

twoway (dot coef ordering, ndots(1) mcolor(gs2))(rcap upper lower ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.4(.2) 1,nogrid)/*
*/   yscale(range(-.4 1)) yline(0) title("Inclusive decision-making" "index") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/procedures.png", replace

graph export "${figures}/procedures.pdf", replace

**************************************************************************
*** FIGURE 4 - This section of code creates Figure 4 in the Paper
**************************************************************************


use "/Users/jonas/Documents/GitHub/HP500-Demo/Demoproject/data/HHdata_QJPS_labeled.dta", clear

reg biasindex VH_treat cl i.block if diffview==1 & postremoval==0, cluster(cc)

matrix est=e(b)
gen VHhat1 =est[1,1]
gen CLhat1 = est[1,2]
matrix var=e(V)
gen VHse1 =sqrt(var[1,1])
gen CLse1 = sqrt(var[2,2])
lincom VH_treat + cl
gen VHCLhat1 = `r(estimate)'
gen VHCLse1 = `r(se)'

reg resolvedindex VH_treat cl i.block, cluster(cc)

matrix est2=e(b)
gen VHhat2 =est2[1,1]
gen CLhat2 = est2[1,2]
matrix var2=e(V)
gen VHse2 =sqrt(var2[1,1])
gen CLse2 = sqrt(var2[2,2])
lincom VH_treat + cl
gen VHCLhat2 = `r(estimate)'
gen VHCLse2 = `r(se)'

reg st_legitimacyindex VH_treat cl i.block, cluster(cc)

matrix est3=e(b)
gen VHhat3 =est3[1,1]
gen CLhat3 = est3[1,2]
matrix var3=e(V)
gen VHse3 =sqrt(var3[1,1])
gen CLse3 = sqrt(var3[2,2])
lincom VH_treat + cl
gen VHCLhat3 = `r(estimate)'
gen VHCLse3 = `r(se)'

forval i = 1/3{
	gen VHupper`i' =VHhat`i' + 1.96*VHse`i'
	gen VHlower`i' =VHhat`i' - 1.96*VHse`i'

	gen CLupper`i'=CLhat`i' + 1.96*CLse`i'
	gen CLlower`i'=CLhat`i' - 1.96*CLse`i'

	gen VHCLupper`i' =VHCLhat`i' + 1.96*VHCLse`i'
	gen VHCLlower`i' =VHCLhat`i' - 1.96*VHCLse`i'
}


keep if _n < 4
gen coefficientname = ""
replace coefficientname="Effect of Workshop for VC" if _n==1
replace coefficientname="Effect of Workshop for VC + CL" if _n==2
replace coefficientname="Effect of CL" if _n==3

gen ordering = _n

forval i = 1/3{

	gen coef`i' = VHhat`i' if coefficientname=="Effect of Workshop for VC"
	replace coef`i' = VHCLhat`i' if coefficientname=="Effect of Workshop for VC + CL"
	replace coef`i' = CLhat`i'	if coefficientname =="Effect of CL"

	gen upper`i' = VHupper`i' if coefficientname=="Effect of Workshop for VC"
	replace upper`i' = VHCLupper`i' if coefficientname=="Effect of Workshop for VC + CL"
	replace upper`i' = CLupper`i' if coefficientname == "Effect of CL"

	gen lower`i' = VHlower`i' if coefficientname=="Effect of Workshop for VC"
	replace lower`i' = VHCLlower`i' if coefficientname=="Effect of Workshop for VC + CL"
	replace lower`i' = CLlower`i' if coefficientname == "Effect of CL"

}

twoway (dot coef1 ordering, ndots(1) mcolor(gs2))(rcap upper1 lower1 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.2(.2) .4,nogrid)/*
*/   yscale(range(-.2 0.4)) yline(0) title("Impartiality" "index") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/impartiality.pdf", replace


twoway (dot coef2 ordering, ndots(1) mcolor(gs2))(rcap upper2 lower2 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.2(.2) .4,nogrid)/*
*/   yscale(range(-.2 .4)) yline(0) title("Problem management" "index") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/problemmanagement.pdf", replace

twoway (dot coef3 ordering, ndots(1) mcolor(gs2))(rcap upper3 lower3 ordering, lcolor(gs2)), 	///	
	xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  							///
	xsize(2.8) scale(1.4) ytitle("") ylabel(-.2(.2) .4,nogrid)									///
	yscale(range(-.2 .4)) yline(0) title("Legitimacy" "index") 									///
	graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/legitimacy.pdf", replace


**************************************************************************
*** FIGURE 5
**************************************************************************

use "/Users/jonas/Documents/GitHub/HP500-Demo/Demoproject/data/HHdata_QJPS_labeled.dta", clear

reg food_aid VH_treat cl i.block if diffview==1 & postremoval==0, cluster(cc)

matrix est4=e(b)
gen VHhat4 =est4[1,1]
gen CLhat4 = est4[1,2]
matrix var4=e(V)
gen VHse4 =sqrt(var4[1,1])
gen CLse4 = sqrt(var4[2,2])
lincom VH_treat + cl
gen VHCLhat4 = `r(estimate)'
gen VHCLse4 = `r(se)'

reg mostfair VH_treat cl i.block if diffview==1 & postremoval==0, cluster(cc)

matrix est5=e(b)
gen VHhat5 =est5[1,1]
gen CLhat5 = est5[1,2]
matrix var5=e(V)
gen VHse5 =sqrt(var5[1,1])
gen CLse5 = sqrt(var5[2,2])
lincom VH_treat + cl
gen VHCLhat5 = `r(estimate)'
gen VHCLse5 = `r(se)'

reg nofoodaidneed VH_treat cl i.block, cluster(cc)

matrix est6=e(b)
gen VHhat6 =est6[1,1]
gen CLhat6 = est6[1,2]
matrix var6=e(V)
gen VHse6 =sqrt(var6[1,1])
gen CLse6 = sqrt(var6[2,2])
lincom VH_treat + cl
gen VHCLhat6 = `r(estimate)'
gen VHCLse6 = `r(se)'

reg noconflicts VH_treat cl i.block, cluster(cc)

matrix est7=e(b)
gen VHhat7 =est7[1,1]
gen CLhat7 = est7[1,2]
matrix var7=e(V)
gen VHse7 =sqrt(var7[1,1])
gen CLse7 = sqrt(var7[2,2])
lincom VH_treat + cl
gen VHCLhat7 = `r(estimate)'
gen VHCLse7 = `r(se)'


forval i = 4/7{
	gen VHupper`i' =VHhat`i' + 1.96*VHse`i'
	gen VHlower`i' =VHhat`i' - 1.96*VHse`i'

	gen CLupper`i'=CLhat`i' + 1.96*CLse`i'
	gen CLlower`i'=CLhat`i' - 1.96*CLse`i'

	gen VHCLupper`i' =VHCLhat`i' + 1.96*VHCLse`i'
	gen VHCLlower`i' =VHCLhat`i' - 1.96*VHCLse`i'
}

keep if _n < 4
gen coefficientname = ""
replace coefficientname="Effect of Workshop for VC" if _n==1
replace coefficientname="Effect of Workshop for VC + CL" if _n==2
replace coefficientname="Effect of CL" if _n==3

gen ordering = _n

forval i = 4/7{
	gen coef`i' = VHhat`i' 			if coefficientname=="Effect of Workshop for VC"
	replace coef`i' = VHCLhat`i' 	if coefficientname=="Effect of Workshop for VC + CL"
	replace coef`i' = CLhat`i' 		if coefficientname =="Effect of CL"

	gen upper`i' = VHupper`i' 		if coefficientname=="Effect of Workshop for VC"
	replace upper`i' = VHCLupper`i' if coefficientname=="Effect of Workshop for VC + CL"
	replace upper`i' = CLupper`i' 	if coefficientname == "Effect of CL"

	gen lower`i' = VHlower`i' 		if coefficientname=="Effect of Workshop for VC"
	replace lower`i' = VHCLlower`i' if coefficientname=="Effect of Workshop for VC + CL"
	replace lower`i' = CLlower`i' 	if coefficientname == "Effect of CL"
}

twoway (dot coef4 ordering, ndots(1) mcolor(gs2))(rcap upper4 lower4 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.2(.2) .4,nogrid)/*
*/   yscale(range(-.2 0.4)) yline(0) title("Impartiality:" "Food aid receipt") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/impartiality1.pdf", replace

twoway (dot coef5 ordering, ndots(1) mcolor(gs2))(rcap upper5 lower5 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.2(.2) .4,nogrid)/*
*/   yscale(range(-.2 0.4)) yline(0) title("Impartiality:" "Fair court decisions") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/impartiality2.pdf", replace

twoway (dot coef6 ordering, ndots(1) mcolor(gs2))(rcap upper6 lower6 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.2(.2) .4,nogrid)/*
*/   yscale(range(-.2 0.4)) yline(0) title("Problem management:" "Food secure") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/problemmanagement1.pdf", replace

twoway (dot coef7 ordering, ndots(1) mcolor(gs2))(rcap upper7 lower7 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.2(.2) .4,nogrid)/*
*/   yscale(range(-.2 0.4)) yline(0) title("Problem management:" "No unresolved disputes") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/problemmanagement2.pdf", replace

**************************************************************************
*** FIGURE 6: CREATION OF FIGURE STARTS HERE
**************************************************************************

// Notes: Some of the outputs aren't generated*
// Until after figure 7 code starts

use "/Users/jonas/Documents/GitHub/HP500-Demo/Demoproject/data/VHdata_QJPS_labeled.dta", clear

reg st_proceduresindex VH_treat cl i.block if closehat_di==0

matrix est8=e(b)
gen VHhat8 =est8[1,1]
gen CLhat8 = est8[1,2]
matrix var8=e(V)
gen VHse8 =sqrt(var8[1,1])
gen CLse8 = sqrt(var8[2,2])
lincom VH_treat + cl
gen VHCLhat8 = `r(estimate)'
gen VHCLse8 = `r(se)'

reg st_proceduresindex VH_treat cl i.block if closehat_di==1

matrix est9=e(b)
gen VHhat9 =est9[1,1]
gen CLhat9 = est9[1,2]
matrix var9=e(V)
gen VHse9 =sqrt(var9[1,1])
gen CLse9 = sqrt(var9[2,2])
lincom VH_treat + cl
gen VHCLhat9 = `r(estimate)'
gen VHCLse9 = `r(se)'

****

reg testknowledge VH_treat cl i.block if closehat_di==0

matrix est10=e(b)
gen VHhat10 =est10[1,1]
gen CLhat10 = est10[1,2]
matrix var10=e(V)
gen VHse10 =sqrt(var10[1,1])
gen CLse10 = sqrt(var10[2,2])
lincom VH_treat + cl
gen VHCLhat10 = `r(estimate)'
gen VHCLse10 = `r(se)'

reg testknowledge VH_treat cl i.block if closehat_di==1

matrix est11=e(b)
gen VHhat11 =est11[1,1]
gen CLhat11 = est11[1,2]
matrix var11=e(V)
gen VHse11 =sqrt(var11[1,1])
gen CLse11 = sqrt(var11[2,2])
lincom VH_treat + cl
gen VHCLhat11 = `r(estimate)'
gen VHCLse11 = `r(se)'

reg testattitudes VH_treat cl i.block if closehat_di==0

matrix est12=e(b)
gen VHhat12 =est12[1,1]
gen CLhat12 = est12[1,2]
matrix var12=e(V)
gen VHse12 =sqrt(var12[1,1])
gen CLse12 = sqrt(var12[2,2])
lincom VH_treat + cl
gen VHCLhat12 = `r(estimate)'
gen VHCLse12 = `r(se)'

reg testattitudes VH_treat cl i.block if closehat_di==1

matrix est13=e(b)
gen VHhat13 =est13[1,1]
gen CLhat13 = est13[1,2]
matrix var13=e(V)
gen VHse13 =sqrt(var13[1,1])
gen CLse13 = sqrt(var13[2,2])
lincom VH_treat + cl
gen VHCLhat13 = `r(estimate)'
gen VHCLse13 = `r(se)'

forval i = 8/13{
	gen VHupper`i' =VHhat`i' + 1.96*VHse`i'
	gen VHlower`i' =VHhat`i' - 1.96*VHse`i'

	gen CLupper`i'=CLhat`i' + 1.96*CLse`i'
	gen CLlower`i'=CLhat`i' - 1.96*CLse`i'

	gen VHCLupper`i' =VHCLhat`i' + 1.96*VHCLse`i'
	gen VHCLlower`i' =VHCLhat`i' - 1.96*VHCLse`i'
}


keep if _n < 4
gen coefficientname = ""
replace coefficientname="Effect of Workshop for VC" if _n==1
replace coefficientname="Effect of Workshop for VC + CL" if _n==2
replace coefficientname="Effect of CL" if _n==3

gen ordering = _n

forval i = 8/13{
	gen coef`i' = VHhat`i' 			if coefficientname=="Effect of Workshop for VC"
	replace coef`i' = VHCLhat`i' 	if coefficientname=="Effect of Workshop for VC + CL"
	replace coef`i' = CLhat`i' 		if coefficientname =="Effect of CL"

	gen upper`i' = VHupper`i' 		if coefficientname=="Effect of Workshop for VC"
	replace upper`i' = VHCLupper`i' if coefficientname=="Effect of Workshop for VC + CL"
	replace upper`i' = CLupper`i' 	if coefficientname == "Effect of CL"

	gen lower`i' = VHlower`i' 		if coefficientname=="Effect of Workshop for VC"
	replace lower`i' = VHCLlower`i' if coefficientname=="Effect of Workshop for VC + CL"
	replace lower`i' = CLlower`i' 	if coefficientname == "Effect of CL"
}

twoway (dot coef8 ordering, ndots(1) mcolor(gs2))(rcap upper8 lower8 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-2.0(.5) 2.0,nogrid)/*
*/   yscale(range(-2.0 2.0)) yline(0) title("Inclusive decisionmaking:" "New CL") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/procedures_new.pdf", replace

twoway (dot coef9 ordering, ndots(1) mcolor(gs2))(rcap upper9 lower9 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-2.0(.5) 2.0,nogrid)/*
*/   yscale(range(-2.0 2.0)) yline(0) title("Inclusive decisionmaking:" "Existing adviser") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/procedures_existing.pdf", replace

twoway (dot coef10 ordering, ndots(1) mcolor(gs2))(rcap upper10 lower10 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-0.4(.2) 0.4,nogrid)/*
*/   yscale(range(-0.4 0.4)) yline(0) title("VC's Knowledge:" "New CL") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/knowledge_new.pdf", replace

twoway (dot coef11 ordering, ndots(1) mcolor(gs2))(rcap upper11 lower11 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-0.4(.2) 0.4,nogrid)/*
*/   yscale(range(-0.4 0.4)) yline(0) title("VC's Knowledge:" "Existing adviser") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/knowledge_existing.pdf", replace

twoway (dot coef12 ordering, ndots(1) mcolor(gs2))(rcap upper12 lower12 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-0.8(.4) 0.8,nogrid)/*
*/   yscale(range(-1 1)) yline(0) title("VC's Attitudes:" "New CL") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/attitudes_new.pdf", replace

twoway (dot coef13 ordering, ndots(1) mcolor(gs2))(rcap upper13 lower13 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-0.8(.4) 0.8,nogrid)/*
*/   yscale(range(-1 1)) yline(0) title("VC's Attitudes:" "Existing adviser") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/attitudes_existing.pdf", replace

****

use "/Users/jonas/Documents/GitHub/HP500-Demo/Demoproject/data/HHdata_QJPS_labeled.dta", clear

reg biasindex VH_treat cl i.block if diffview==1 & postremoval==0 & closehat_di==0, cluster(cc)

matrix est14=e(b)
gen VHhat14 =est14[1,1]
gen CLhat14 = est14[1,2]
matrix var14=e(V)
gen VHse14 =sqrt(var14[1,1])
gen CLse14 = sqrt(var14[2,2])
lincom VH_treat + cl
gen VHCLhat14 = `r(estimate)'
gen VHCLse14 = `r(se)'

reg biasindex VH_treat cl i.block if diffview==1 & postremoval==0 & closehat_di==1, cluster(cc)

matrix est15=e(b)
gen VHhat15 =est15[1,1]
gen CLhat15 = est15[1,2]
matrix var15=e(V)
gen VHse15 =sqrt(var15[1,1])
gen CLse15 = sqrt(var15[2,2])
lincom VH_treat + cl
gen VHCLhat15 = `r(estimate)'
gen VHCLse15 = `r(se)'

reg st_legitimacyindex VH_treat cl i.block if closehat_di==0, cluster(cc)

matrix est16=e(b)
gen VHhat16 =est16[1,1]
gen CLhat16 = est16[1,2]
matrix var16=e(V)
gen VHse16 =sqrt(var16[1,1])
gen CLse16 = sqrt(var16[2,2])
lincom VH_treat + cl
gen VHCLhat16 = `r(estimate)'
gen VHCLse16 = `r(se)'

reg st_legitimacyindex VH_treat cl i.block if closehat_di==1, cluster(cc)

matrix est17=e(b)
gen VHhat17 =est17[1,1]
gen CLhat17 = est17[1,2]
matrix var17=e(V)
gen VHse17 =sqrt(var17[1,1])
gen CLse17 = sqrt(var17[2,2])
lincom VH_treat + cl
gen VHCLhat17 = `r(estimate)'
gen VHCLse17 = `r(se)'

*****************************************************
*FIGURE 7: CREATION OF FIGURES STARTS HERE          *
*****************************************************

reg testknowledgeHH VH_treat cl i.block, cluster(cc)

matrix est18=e(b)
gen VHhat18 =est18[1,1]
gen CLhat18 = est18[1,2]
matrix var18=e(V)
gen VHse18 =sqrt(var18[1,1])
gen CLse18 = sqrt(var18[2,2])
lincom VH_treat + cl
gen VHCLhat18 = `r(estimate)'
gen VHCLse18 = `r(se)'

reg raisedissue VH_treat cl i.block, cluster(cc)

matrix est19=e(b)
gen VHhat19 =est19[1,1]
gen CLhat19 = est19[1,2]
matrix var19=e(V)
gen VHse19 =sqrt(var19[1,1])
gen CLse19 = sqrt(var19[2,2])
lincom VH_treat + cl
gen VHCLhat19 = `r(estimate)'
gen VHCLse19 = `r(se)'

forval i = 14/19{
	gen VHupper`i' =VHhat`i' + 1.96*VHse`i'
	gen VHlower`i' =VHhat`i' - 1.96*VHse`i'

	gen CLupper`i'=CLhat`i' + 1.96*CLse`i'
	gen CLlower`i'=CLhat`i' - 1.96*CLse`i'

	gen VHCLupper`i' =VHCLhat`i' + 1.96*VHCLse`i'
	gen VHCLlower`i' =VHCLhat`i' - 1.96*VHCLse`i'
}


keep if _n<4
gen coefficientname = ""
replace coefficientname="Effect of Workshop for VC" if _n==1
replace coefficientname="Effect of Workshop for VC + CL" if _n==2
replace coefficientname="Effect of CL" if _n==3

gen ordering = _n

forval i = 14/19{

	gen coef`i' = VHhat`i' if coefficientname=="Effect of Workshop for VC"
	replace coef`i' = VHCLhat`i' if coefficientname=="Effect of Workshop for VC + CL"
	replace coef`i' = CLhat`i' if coefficientname =="Effect of CL"

	gen upper`i' = VHupper`i' if coefficientname=="Effect of Workshop for VC"
	replace upper`i' = VHCLupper`i' if coefficientname=="Effect of Workshop for VC + CL"
	replace upper`i' = CLupper`i' if coefficientname == "Effect of CL"

	gen lower`i' = VHlower`i' if coefficientname=="Effect of Workshop for VC"
	replace lower`i' = VHCLlower`i' if coefficientname=="Effect of Workshop for VC + CL"
	replace lower`i' = CLlower`i' if coefficientname == "Effect of CL"

}

twoway (dot coef14 ordering, ndots(1) mcolor(gs2))(rcap upper14 lower14 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.8(.4) .8,nogrid)/*
*/   yscale(range(-.8 .8)) yline(0) title("Impartiality:" "New CL") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/impartiality_new.pdf", replace	  
	  
twoway (dot coef15 ordering, ndots(1) mcolor(gs2))(rcap upper15 lower15 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.8(.4) .8,nogrid)/*
*/   yscale(range(-.8 .8)) yline(0) title("Impartiality:" "Existing adviser") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	
graph export "${figures}/impartiality_existing.pdf", replace	
	
twoway (dot coef16 ordering, ndots(1) mcolor(gs2))(rcap upper16 lower16 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.8(.4) .8,nogrid)/*
*/   yscale(range(-.8 .8)) yline(0) title("Legitimacy:" "New CL") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)

graph export "${figures}/legitimacy_new.pdf", replace
	  
twoway (dot coef17 ordering, ndots(1) mcolor(gs2))(rcap upper17 lower17 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.8(.4) .8,nogrid)/*
*/   yscale(range(-.8 .8)) yline(0) title("Legitimacy:" "Existing adviser") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)

graph export "${figures}/legitimacy_existing.pdf", replace
	  
twoway (dot coef18 ordering, ndots(1) mcolor(gs2))(rcap upper18 lower18 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.2(.1) .2,nogrid)/*
*/   yscale(range(-.2 .2)) yline(0) title("HH's" "Knowledge") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)

graph export "${figures}/knowledge_HH.pdf", replace

twoway (dot coef19 ordering, ndots(1) mcolor(gs2))(rcap upper19 lower19 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.2(.1) .2,nogrid)/*
*/   yscale(range(-.2 .2)) yline(0) title("HH Raised Issue" "with VC") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)

graph export "${figures}/contact_HH.pdf", replace

*********

use "/Users/jonas/Documents/GitHub/HP500-Demo/Demoproject/data/VHdata_QJPS_labeled.dta", clear

reg indepgovt2 VH_treat cl i.block

matrix est20=e(b)
gen VHhat20 =est20[1,1]
gen CLhat20 = est20[1,2]
matrix var20=e(V)
gen VHse20 =sqrt(var20[1,1])
gen CLse20 = sqrt(var20[2,2])
lincom VH_treat + cl
gen VHCLhat20 = `r(estimate)'
gen VHCLse20 = `r(se)'

gen VHupper20 =VHhat20 + 1.96*VHse20
gen VHlower20 =VHhat20 - 1.96*VHse20

gen CLupper20=CLhat20 + 1.96*CLse20
gen CLlower20=CLhat20 - 1.96*CLse20

gen VHCLupper20 =VHCLhat20 + 1.96*VHCLse20
gen VHCLlower20 =VHCLhat20 - 1.96*VHCLse20

keep if _n<4
gen coefficientname = ""
replace coefficientname="Effect of Workshop for VC" if _n==1
replace coefficientname="Effect of Workshop for VC + CL" if _n==2
replace coefficientname="Effect of CL" if _n==3

gen ordering = _n

gen coef20 = VHhat20 			if coefficientname=="Effect of Workshop for VC"
replace coef20 = VHCLhat20 		if coefficientname=="Effect of Workshop for VC + CL"
replace coef20 = CLhat20 		if coefficientname =="Effect of CL"

gen upper20 = VHupper20 		if coefficientname=="Effect of Workshop for VC"
replace upper20 = VHCLupper20 	if coefficientname=="Effect of Workshop for VC + CL"
replace upper20 = CLupper20 	if coefficientname == "Effect of CL"

gen lower20 = VHlower20 		if coefficientname=="Effect of Workshop for VC"
replace lower20 = VHCLlower20 	if coefficientname=="Effect of Workshop for VC + CL"
replace lower20 = CLlower20 	if coefficientname == "Effect of CL"

	  
twoway (dot coef20 ordering, ndots(1) mcolor(gs2))(rcap upper20 lower20 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.8(.4) .8,nogrid)/*
*/   yscale(range(-.8 .8)) yline(0) title("VC's Independence" "from Government") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)

graph export "${figures}/independence_govt.pdf", replace

*************

use "/Users/jonas/Documents/GitHub/HP500-Demo/Demoproject/data/CLdata_QJPS_labeled.dta", clear

reg testknowledgeCL VH_treat cl i.block if dare!=1

matrix est21=e(b)
gen VHhat21 =est21[1,1]
gen CLhat21 = est21[1,2]
matrix var21=e(V)
gen VHse21 =sqrt(var21[1,1])
gen CLse21 = sqrt(var21[2,2])
lincom VH_treat + cl
gen VHCLhat21 = `r(estimate)'
gen VHCLse21 = `r(se)'

reg logexchangeinfo VH_treat cl i.block if dare!=1

matrix est22=e(b)
gen VHhat22 =est22[1,1]
gen CLhat22 = est22[1,2]
matrix var22=e(V)
gen VHse22 =sqrt(var22[1,1])
gen CLse22 = sqrt(var22[2,2])
lincom VH_treat + cl
gen VHCLhat22 = `r(estimate)'
gen VHCLse22 = `r(se)'

forval i = 21/22{
	gen VHupper`i' =VHhat`i' + 1.96*VHse`i'
	gen VHlower`i' =VHhat`i' - 1.96*VHse`i'

	gen CLupper`i'=CLhat`i' + 1.96*CLse`i'
	gen CLlower`i'=CLhat`i' - 1.96*CLse`i'

	gen VHCLupper`i' =VHCLhat`i' + 1.96*VHCLse`i'
	gen VHCLlower`i' =VHCLhat`i' - 1.96*VHCLse`i'
}

keep if _n<4
gen coefficientname = ""
replace coefficientname="Effect of Workshop for VC" if _n==1
replace coefficientname="Effect of Workshop for VC + CL" if _n==2
replace coefficientname="Effect of CL" if _n==3

gen ordering = _n

forval i = 21/22 {
	gen coef`i' = VHhat`i' 			if coefficientname=="Effect of Workshop for VC"
	replace coef`i' = VHCLhat`i' 	if coefficientname=="Effect of Workshop for VC + CL"
	replace coef`i' = CLhat`i' 		if coefficientname =="Effect of CL"

	gen upper`i' = VHupper`i' 		if coefficientname=="Effect of Workshop for VC"
	replace upper`i' = VHCLupper`i' if coefficientname=="Effect of Workshop for VC + CL"
	replace upper`i' = CLupper`i' 	if coefficientname == "Effect of CL"

	gen lower`i' = VHlower`i' 		if coefficientname=="Effect of Workshop for VC"
	replace lower`i' = VHCLlower`i' if coefficientname=="Effect of Workshop for VC + CL"
	replace lower`i' = CLlower`i' 	if coefficientname == "Effect of CL"
}

  
twoway (dot coef21 ordering, ndots(1) mcolor(gs2))(rcap upper21 lower21 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.2(.1) .2,nogrid)/*
*/   yscale(range(-.2 .2)) yline(0) title("CL's" "Knowledge") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/knowledge_CL.pdf", replace
	    
twoway (dot coef22 ordering, ndots(1) mcolor(gs2))(rcap upper22 lower22 ordering, lcolor(gs2)), /*
*/     xtitle("") xlabel(1 "VC Effect" 2 "VC + CL Effect" 3 "CL Effect")  xsize(2.8) scale(1.4) ytitle("") ylabel(-.8(.4) .8,nogrid)/*
*/   yscale(range(-.8 .8)) yline(0) title("CL's Information" "Exchange with VC") graphregion(margin (l+5 r+5) fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) legend(off)
	  
graph export "${figures}/contact_CL.pdf", replace

