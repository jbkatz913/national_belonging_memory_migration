*----------------------------------------------------------------------------
* Author: Jordan Katz
* Title: National Belonging, "Official" Memory Culture, and the Moderating Role of Ethnic Background in Germany 
* Manuscript Models 
*----------------------------------------------------------------------------

* NOTE: users must replace input and output filepaths 

clear

* import data
use "/analytic.dta"


* set working directory for exporting tables 
cd "[REPLACE]"


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


*****************************
* Linear models 
*****************************

* basic with random slope
mixed dv i.svyyear i.grade_qs male c.gen12##c.belong_avg i.id_s || id_p: belong_avg 
estimate store basic_rs
matrix A = e(N_g)
matrix B = (e(N))


* controls and random slope
mixed dv i.svyyear i.grade_qs male citizen discrim g1_7 c.gen12##c.g1_1 c.ever_muslim##c.g1_5 c.ever_muslim##c.rlgsty c.gen12##c.belong_avg i.id_s || id_p: belong_avg g1_1 g1_5 rlgsty, technique(nr bfgs)
estimate store controls_rs
matrix A = e(N_g) 
matrix B = (e(N))



**************************
* Subgroup linear models 
**************************

* basic with random slope
mixed dv i.svyyear i.grade_qs male c.ever_muslim##c.belong_avg i.id_s if gen12==1 || id_p: belong_avg 
estimate store basic_rs_s
matrix A = e(N_g)
matrix B = (e(N))


* controls and random slope 
mixed dv i.svyyear i.grade_qs male citizen discrim g1_7 g1_1 c.ever_muslim##c.g1_5 c.ever_muslim##c.rlgsty c.ever_muslim##c.belong_avg i.id_s if gen12==1 || id_p: belong_avg g1_5 rlgsty 
estimate store controls_rs_s
matrix A = e(N_g)
matrix B = (e(N))



**************************
* Ordinal models 
**************************


*** random intercepts do not converge with ordinal models ***

* basic 
meologit dv i.svyyear i.grade_qs male c.gen12##c.belong_avg i.id_s || id_p: 
estimate store basic_o
matrix A = e(N_g)
matrix B = (e(N))


* controls 
meologit dv i.svyyear i.grade_qs male citizen discrim g1_7 c.gen12##c.g1_1 c.ever_muslim##c.g1_5 c.ever_muslim##c.rlgsty c.gen12##c.belong_avg i.id_s || id_p:  
estimate store controls_o
matrix A = e(N_g)
matrix B = (e(N))



**************************
* subgroup ordinal models 
**************************

* basic 
meologit dv i.svyyear i.grade_qs male c.ever_muslim##c.belong_avg i.id_s if gen12==1 || id_p: 
estimate store basic_o_s
matrix A = e(N_g)
matrix B = (e(N))


* controls 
meologit dv i.svyyear i.grade_qs male citizen discrim g1_7 g1_1 c.ever_muslim##c.g1_5 c.ever_muslim##c.rlgsty c.ever_muslim##c.belong_avg i.id_s if gen12==1  || id_p:
estimate store controls_o_s
matrix A = e(N_g)
matrix B = (e(N))



********************************************************************************



********************************
* OUTPUT TABLES
********************************


* Full sample manuscript models 

* excel 
etable, estimates(basic_rs controls_rs basic_o controls_o) stars( .10 `"+"' .05 `"*"' .01 `"**"' .001 `"***"') varlabel fvlabel column(estimates) keep(svyyear grade_qs male citizen discrim ever_muslim##g1_5 gen12##g1_1 g1_7 ever_muslim##rlgsty gen12##belong_avg) title("Table 1: Full Sample Models") mstat(N, label("Observations") nformat(%9.0f)) mstat(N_g, label("Units") nformat(%9.0f)) export(manuscript_models.xlsx, sheet(full sample) modify)

* docx
etable, estimates(basic_rs controls_rs basic_o controls_o) stars( .10 `"+"' .05 `"*"' .01 `"**"' .001 `"***"') varlabel fvlabel column(estimates) keep(svyyear grade_qs male citizen discrim ever_muslim##g1_5 gen12##g1_1 g1_7 ever_muslim##rlgsty gen12##belong_avg) title("Table 1: Full Sample Models") mstat(N, label("Observations") nformat(%9.0f)) mstat(N_g, label("Units") nformat(%9.0f)) export(table1_models.docx, replace)



******


* Sub sample manuscript models 

* excel
etable, estimates(basic_rs_s controls_rs_s basic_o_s controls_o_s) stars( .10 `"+"' .05 `"*"' .01 `"**"' .001 `"***"') varlabel fvlabel column(estimates) keep(svyyear grade_qs male citizen discrim ever_muslim##g1_5 g1_1  g1_7 ever_muslim##rlgsty ever_muslim##belong_avg) title("Table 2: Sub-Sample Models") mstat(N, label("Observations") nformat(%9.0f)) mstat(N_g, label("Units") nformat(%9.0f)) export(manuscript_models.xlsx, sheet(subsample) modify)

* docx
etable, estimates(basic_rs_s controls_rs_s basic_o_s controls_o_s) stars( .10 `"+"' .05 `"*"' .01 `"**"' .001 `"***"') varlabel fvlabel column(estimates) keep(svyyear grade_qs male citizen discrim ever_muslim##g1_5 g1_1  g1_7 ever_muslim##rlgsty ever_muslim##belong_avg) title("Table 2: Sub-Sample Models") mstat(N, label("Observations") nformat(%9.0f)) mstat(N_g, label("Units") nformat(%9.0f)) export(table2_models.docx, replace)










