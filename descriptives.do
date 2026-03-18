*----------------------------------------------------------------------------
* Author: Jordan Katz
* Title: National Belonging, "Official" Memory Culture, and the Moderating Role of Ethnic Background in Germany 
* Descriptive Tables
*----------------------------------------------------------------------------

* NOTE: users must replace input and output filepaths 


clear


* import data
use "/analytic.dta"


* set working directory for exporting tables 
cd "[REPLACE]"


********************************************************************************


* add variable and value labels
 
label variable dv "Attitudes towards Jews (avg)"
label variable dv_cat "Attitudes towards Jews (%)"
label variable belong_avg "National Belonging"
label variable wave "Wave"
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


label define lab_wave 1 "W1" 2 "W2" 3 "W3" 4 "W4" 5 "W5" 6 "W6"
label values wave lab_wave

label define lab_dv 1 "Not at all" 2 "Not much" 3 "Neither nor" 4 "Rather much" 5 "Very much"
label values dv_cat lab_dv


********************************************************************************

* by wave

* excel
dtable i.dv_cat dv belong_avg gen12 ever_muslim male citizen rlgsty g1_1 g1_5 g1_7 discrim i.grade_qs, by(wave, nototals)  sample(, place(seplabels)) nformat(%16.2fc mean sd) title("APPENDIX: Table 1 - Descriptives by Wave") export(descriptives.xlsx, sheet("Survey Wave") replace) 

* docx
dtable i.dv_cat dv belong_avg gen12 ever_muslim male citizen rlgsty g1_1 g1_5 g1_7 discrim i.grade_qs, by(wave, nototals)  sample(, place(seplabels)) nformat(%16.2fc mean sd) title("APPENDIX: Table 1 - Descriptives by Wave") export(descriptives_table1.docx, replace) 

********************************************************************************

* by analytic category

* first create grouping variable
generate category = .
replace category = 1 if gen12 == 0
replace category = 2 if gen12 == 1 & ever_muslim == 0
replace category = 3 if gen12 == 1 & ever_muslim == 1

label define lab_category 1 "Ethnic Majority" 2 "non-Muslim Minority" 3 "Muslim"
label values category lab_category

label variable category ""

* excel
dtable i.dv_cat dv belong_avg male citizen ever_muslim rlgsty g1_1 g1_5 g1_7 discrim i.grade_qs, by(category, nototals)  sample(, place(seplabels)) nformat(%16.2fc mean sd) title("APPENDIX: Table 2 - Descriptives by Analytic Category") export(descriptives.xlsx, sheet("Analytic Category") modify) 

* docx
dtable i.dv_cat dv belong_avg male citizen rlgsty g1_1 g1_5 g1_7 discrim i.grade_qs, by(category, nototals)  sample(, place(seplabels)) nformat(%16.2fc mean sd) title("APPENDIX: Table 2 - Descriptives by Analytic Category") export(descriptives_table2.docx, replace) 



















