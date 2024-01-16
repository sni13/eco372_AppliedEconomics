/* 	=============================================================
	This is the template do-file for Patrick Blanchenay's 
	ECO372 Assignment 4. Before anything else, rename this file, 
	changing "SURNAME" to your ACORN surname, and "Firstname" to 
	your ACORN first name. Use _ for spaces.
	
	For me, it would be: ECO372_Assignment4_BLANCHENAY_Patrick.do

	Comment your code, explain what steps you are doing. 
	You can insert comments before the instruction, or at the 
	end of lines.
	
	You should also use indentation to make your code easy to read.
	
	Remember that running this do-file does not save it.
	============================================================= */
log close _all 														// closes any previously opened log file	

/* =============================================================
	THINGS TO CHANGE
	============================================================= */

// Working directory:  This is the folder where your do-file and dataset are located
cd "/Users/nisailing/Desktop/ECO372/ECO372_A4/"

// SURNAME (Last name) as on ACORN (replace BLANCHENAY)
local surname NI // One word only

// First name as on ACORN (replace Patrick)
local firstname Sailing // Only the fist of your given names, as it appears on ACORN

// Student number, replace 12345678 by your student number, without quotes
local studentnumber 1004936019

																		
/* 	=============================================================
	Do not change these commands
	============================================================= */
cap log close
log using "ECO372_Assignment4_`surname'_`firstname'.log", replace text 	// This log file will regenerated everytime you run the do-file
set more off 	// This tells Stata to automatically continue if displays exceed screen capacity, instead of making user click
clear			// Removes any data from memory every time this script is run.
display "ECO372_Assignment4 " _n "`surname' `firstname' `studentnumber'" _n c(current_date) c(current_time)

/* 	=============================================================
	============ EXERCISE 1 ============
	============================================================= */

use "datasets/AganStarr2018.dta", clear			// If your files are placed correctly, you should not need to change that 
datasignature									// checks data integrity													

// YOUR COMMANDS FOR EXERCISE 1 GO HERE

//Question (b)
//Use table command to produce a table for characteristics
table post, contents(mean white mean crime mean ged mean empgap mean box)
//Use table command to produce a table for results
table post, contents(mean posresponse mean interview)

//Question (c)
// regress each characteristics on pre
reg white pre, robust
reg crime pre, robust
reg ged pre, robust
reg empgap pre, robust
reg box pre, robust

//Question (d)
// first, regress posresponse on all variables
// store regression result
reg posresponse white crime ged empgap pre i.center i.chain_id, cluster(chain_id)
estimates store model_1
// second, regress posresponse on all variables, condition BOX==1 specified
// store regression result
reg posresponse white crime ged empgap i.center i.chain_id if box == 1, cluster(chain_id)
estimates store model_2
// finally, establish table using model_1 and model_2
esttab model_1 model_2 using "result_d", ///
rtf replace se ///
stats(N, labels("N")) ///
drop(_cons *.center *.chain_id)


//Question (e)
// first, regress interview on all variables
// store regression result
reg interview white crime ged empgap pre i.center i.chain_id, cluster(chain_id)
estimates store model_3
// second, regress posresponse on all variables, condition BOX==1 specified
// store regression result
reg interview white crime ged empgap i.center i.chain_id if box == 1, cluster(chain_id)
estimates store model_4
// finally, establish table using model_1 and model_2
esttab model_3 model_4 using "result_e", ///
rtf replace se ///
stats(N, labels("N")) ///
drop(_cons *.center *.chain_id)

//Question (g)
tab balanced

//Question (h)
// gen interaction terms
gen boxwhite = box * white
gen prewhite = pre * white 
// do regression, clustered in chain, control for ged empgap
// col 1: control center, only pre-BTB
regress posresponse boxwhite white box ged empgap i.center if pre == 1, cluster(chain_id)
estimates store mod1
// col 2: only box remover and balanced observations
regress posresponse boxwhite white box ged empgap if remover == 1 & balanced == 1, cluster(chain_id)
estimates store mod2
// col 3: control center, only box remover
regress posresponse boxwhite white box ged empgap i.center if remover == 1, cluster(chain_id)
estimates store mod3
// col 4: prewhite, only box remover and balanced observations
regress posresponse prewhite white pre ged empgap if balanced == 1 & remover == 0, cluster(chain_id)
estimates store mod5
// gen table
esttab  mod1 mod2 mod3 mod5 using "result_h", ///
rtf replace se ///
stats(N, labels("N")) ///
drop(_cons *.center ged empgap)


//Question (i)
// do regression, clustered in chain, control for ged empgap
// col 1: control center, only pre-BTB
regress interview boxwhite white box ged empgap i.center if pre == 1, cluster(chain_id)
estimates store mod21
// col 2: only box remover and balanced observations
regress interview boxwhite white box ged empgap if remover == 1 & balanced == 1, cluster(chain_id)
estimates store mod22
// col 3: control center, only box remover
regress interview boxwhite white box ged empgap i.center if remover == 1, cluster(chain_id)
estimates store mod23
// col 4: prewhite, only box remover and balanced observations
regress interview prewhite white pre ged empgap if balanced == 1 & remover == 0, cluster(chain_id)
estimates store mod25
// gen table
esttab  mod21 mod22 mod23 mod25 using "result_i", ///
rtf replace se ///
stats(N, labels("N")) ///
drop(_cons *.center ged empgap)


//Question (j)

// do new tables to show the regression results with calculated t-test
// table d&e
esttab model_1 model_2, drop(_cons *.center *.chain_id)
esttab model_3 model_4, drop(_cons *.center *.chain_id)
// table h&i
esttab  mod1 mod2 mod3 mod5, drop(_cons *.center ged empgap)
esttab  mod21 mod22 mod23 mod25, drop(_cons *.center ged empgap)


/* 	=============================================================
	============ 	FINAL COMMANDS 	(do not change)	============
	============================================================= */
	
log close
graph close _all

/* 	=============================================================
	============ 			END OF SCRIPT			 ============
	============================================================= */
