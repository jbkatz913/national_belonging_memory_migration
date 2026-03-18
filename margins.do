*----------------------------------------------------------------------------
* Author: Jordan Katz
* Title: National Belonging, "Official" Memory Culture, and the Moderating Role of Ethnic Background in Germany 
* Post-Estimation - Predicted Values and AMEs
*----------------------------------------------------------------------------



clear

* import data
use "/analytic.dta"


* set working directory for exporting tables 
cd "/margins output"


********************************************************************************


* add variable and value labels 

label variable dv "Attitudes towards Jews"
label variable belong_avg "National Belonging"
label variable svyyear "Year"
label variable grade_qs "Grade"
label variable ever_muslim "Muslim" 
label variable gen12 "Migration Background"
label variable male "Male" 
label variable citizen "Citizen"
label variable rlgsty "Place of Worship"
label variable discrim "Discrimination"
label variable g1_1 "German Neighbors"
label variable g1_5 "Muslim Neighbors"
label variable g1_7 "Jewish Neighbors"



********************************************************************************


**************************
* Full sample 
**************************

* linear (M2)
mixed dv i.svyyear i.grade_qs male citizen discrim g1_7 gen12##c.g1_1 ever_muslim##c.g1_5 ever_muslim##c.rlgsty gen12##c.belong_avg i.id_s || id_p: belong_avg g1_1 g1_5 rlgsty, technique(nr bfgs)

* predicted values
margins gen12, at(belong_avg = (1(.25)5)) 
matrix T = r(table)
putexcel set "pp_controls.xlsx", replace
putexcel A1 = matrix(T), names


* ordinal (M4)
meologit dv i.svyyear i.grade_qs male citizen discrim g1_7 gen12##c.g1_1 ever_muslim##c.g1_5 ever_muslim##c.rlgsty gen12##c.belong_avg i.id_s || id_p:  

* AMEs
margins, dydx(belong_avg) at(gen12 = (0 1)) 
matrix T = r(table)
putexcel set "mrgns_controls_o.xlsx", replace
putexcel A1 = matrix(T), names

* grade AMEs for ordinal model
margins, dydx(grade_qs)
matrix T = r(table)
putexcel set "mrgns_grade.xlsx", replace
putexcel A1 = matrix(T), names




**************************
* Subgroup models 
**************************

* linear (M2)
mixed dv i.svyyear i.grade_qs male citizen discrim g1_7 g1_1 ever_muslim##c.g1_5 ever_muslim##c.rlgsty ever_muslim##c.belong_avg i.id_s || id_p: belong_avg g1_5 rlgsty if gen12==1 

* predicted values
margins ever_muslim, at(belong_avg = (1(.25)5)) 
matrix T = r(table)
putexcel set "pp_controls_s.xlsx", replace
putexcel A1 = matrix(T), names


* ordinal (M4)
meologit dv i.svyyear i.grade_qs male citizen discrim g1_7 g1_1 ever_muslim##c.g1_5 ever_muslim##c.rlgsty ever_muslim##c.belong_avg i.id_s if gen12==1  || id_p:

* AMEs
margins, dydx(belong_avg) at(ever_muslim = (0 1)) 
matrix T = r(table)
putexcel set "mrgns_controls_o_s.xlsx", replace
putexcel A1 = matrix(T), names

* grade AMEs for ordinal model
margins, dydx(grade_qs) 
matrix T = r(table)
putexcel set "mrgns_grade_sub.xlsx", replace
putexcel A1 = matrix(T), names




