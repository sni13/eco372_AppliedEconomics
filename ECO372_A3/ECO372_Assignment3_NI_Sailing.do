/* 	=============================================================
	This is the template do-file for Patrick Blanchenay's 
	ECO372 Assignment 3. Before anything else, rename this file, 
	changing "SURNAME" to your ACORN surname, and "Firstname" to 
	your ACORN first name. Use _ for spaces.
	
	For me, it would be: ECO372_Assignment2_BLANCHENAY_Patrick.do

	Comment your code, explain what steps you are doing. 
	You can insert comments before the instruction, or at the 
	end of lines.
	
	You should also use indentation to make your code easy to read.
	
	Remember that running this do-file does not save it.
	============================================================= */
	
											
/* =============================================================
	THINGS TO CHANGE
	============================================================= */

// Working directory:  This is the folder where your do-file and dataset are located
cd "/Users/nisailing/Desktop/ECO372/ECO372_A3/"

// SURNAME (Last name) as on ACORN (replace BLANCHENAY)
local surname NI // One word only

// First name as on ACORN (replace Patrick)
local firstname Sailing // Only the fist of your given names, as it appears on ACORN

// Student number, replace 12345678 by your student number, without quotes
local studentnumber 1004936019

/* 	=============================================================
	Do not change the following commands
	============================================================= */
cap log close _all // closes any previously opened log files
set seed `studentnumber'
log using "ECO372_Assignment3_`surname'_`firstname'.log", replace text 	// This log file will be regenerated everytime you run the do-file
set more off 	// This tells Stata to automatically continue if displays exceed screen capacity, instead of making user click
clear			// Removes any data from memory every time this script is run.
display "ECO372_Assignment3 " _n "`surname' `firstname' `studentnumber'" _n c(current_date) c(current_time)
																		


/* 	====================================
	============ EXERCISE  1  ============
	==================================== */

use "datasets/Angrist_etal_Columbia2002_1.dta", clear		// Loads the file
datasignature												// checks data integrity			

// your code for the Exercise questions a-e goes here
ssc install estout
// Question (a) 
count 

// Question (b) 
summarize math reading writing

// Question (c) 

//firstly, regress separately and create estimates
reg totalpts vouch0 i.t_site, robust
estimates store regression1

reg math vouch0 i.t_site, robust
estimates store regression2

reg reading vouch0 i.t_site, robust
estimates store regression3

reg writing vouch0 i.t_site, robust
estimates store regression4

//secondly, using esttable to construct a table
esttab regression1 regression2 regression3 regression4 using "result_C", ///
rtf replace se ///
mtitles("totalpts" "math" "reading" "writing") ///
stats(N r2 F, labels("Observations" "R-squared" "F-stat")) ///
drop(_cons *.t_site)


// Question (d) 
//firstly, regress totalpts on vouch0 with all control variables
reg totalpts vouch0 i.t_site age sex dad_sch mom_sch strata svy hsvisit, robust
estimates store model


//secondly, using esttable to construct a table
esttab model using "result_D", ///
rtf replace se ///
mtitles("totalpts with covariates") ///
stats(N r2 F, labels("Observations" "R-squared" "F-stat")) ///
drop(_cons *.t_site age sex dad_sch mom_sch strata svy hsvisit)

// Question (e) 

clear
use "datasets/Angrist_etal_Columbia2002_2.dta", clear		// Loads the file
datasignature												// checks data integrity			

// your code for the Exercise questions f-l goes here

// Question (f)
count

// Question (g)
// first, both strata and month are categorical variable 
tabulate strata
tabulate month
// regress highest grade on vouch0
reg scyfnsh vouch0 svy hsvisit age sex i.strata i.month, robust
estimates store model_grade
// regress in-school on vouch 0
reg inschl vouch0 svy hsvisit age sex i.strata i.month, robust
estimates store model_inschool

//secondly, using esttable to construct a table
esttab model_grade model_inschool using "result_G", ///
rtf replace se ///
mtitles("scyfnsh" "inschl") ///
stats(N r2 F, labels("Observations" "R-squared" "F-stat")) ///
drop(_cons svy hsvisit age sex *.strata *.month)


// Question (j)
// regress ols - highest grade on vouch0
reg scyfnsh usesch svy hsvisit age sex i.strata i.month, robust
estimates store model_ols
// regress 2sls - highest grade on vouch0
ivregress 2sls scyfnsh (usesch=vouch0) svy hsvisit age sex i.strata i.month, robust
estimates store model_2sls
//then, using esttable to construct a table
esttab model_ols model_2sls using "result_J", ///
rtf replace se ///
mtitles("scyfnsh-ols" "scyfnsh-2sls") ///
drop(_cons svy hsvisit age sex *.strata *.month)


// Question (k)

// Question (l)
// regress 2sls - in school at time of survey
ivregress 2sls inschl (usesch=vouch0) svy hsvisit age sex i.strata i.month, robust
estimates store model_2sls_inschl
//then, using esttable to construct a table
esttab model_2sls_inschl using "result_L", ///
rtf replace se ///
mtitles("inschl-2sls") ///
drop(_cons svy hsvisit age sex *.strata *.month)








/* 	=============================================================
	============ 	FINAL COMMANDS 	(do not change)	============
	============================================================= */
log close				// closes your log file
/* 	=============================================================
	============ 			END OF SCRIPT			 ============
	============================================================= */
