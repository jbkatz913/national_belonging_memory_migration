# national_belonging_memory_migration

Replication package for the paper titled "National Belonging, 'Official' Memory Culture, and the Moderating Role of Ethnic Background in Germany

Author: Jordan Katz

Abstract: Whereas Jews were previously the target of state persecution, official German remembrance has recast the once “negative” other as a “positive” other—a process through which national belonging is made conditional on holding a favorable orientation to them. Moreover, the notion of Jews as a memory-mediated other features prominently in immigrant integration discussions, especially regarding Muslims. Accordingly, this paper examines the relationship between German national belonging and individual sentiment towards Jews, moderated by migration and religious background. Using a panel survey of students, analyses indicate that, among migrant background respondents, national belonging is positively associated with pro-Jewish sentiment; the effect being uniquely pronounced for Muslims. However, among the ethnic majority, the relationship is null, despite their higher overall levels of belonging and pro-Jewish sentiment. Results underscore the relationship between immigrant conceptualizations of national belonging and state-endorsed memory culture. Further, the intensity of this association systematically varies according to social location vis-à-vis the nation: the ethnic majority situated closest to the “core,” followed by non-Muslim minorities, and then Muslims. The paper theorizes how the precarity of one’s national membership informs how individuals cultivate a sense of national belonging in relation to memory-mediated others specifically, and perhaps state-endorsed cultural contents more broadly.

————————


Document purpose: outline materials in repository


Files: 

1. processing.r 
	- This R script processes the data, creating the analytic dataset, saving it as “analytic.dta”

2. heat_map.r
	- This R script uses analytic.dta to generate the heat map plot (figure 1) in the manuscript

3. descriptives.do 
	- This STATA script uses analytic.dta to create tables of descriptive statistics (appendix tables 1 and 2)

4.  models.do 
	- This STATA script uses analytic.dta to run the regression models in the manuscript (tables 1 and 2) 

5. margins.do 
	- This STATA script uses analytic.dta to calculate predicted values and average marginal effects for the national belonging x moderator interactions and grade coefficients 
	
6. plots_margins.r
	- This R script uses the results from margins.do to generate figures 2-5 in the manuscript  
	
7. fis_data_manual.pdf
	- This document provides information on the FiS survey design, including a codebook of all variables
 

Software: 
1. All .r files use R version 4.4.1 
2. All .do files use StataSE 18


Data accessibility statement: The data underlying this article (the Friendship and Identity in School survey) are available at the Research Data Center of the German Center for Integration and Migration Research (DeZIM) (Leszczensky et al., 2020): https://doi.org/10.34882/dezim.fis.download.1.1.0. These data are available by application, free of charge. All application materials and user guidelines/regulations are made available on the DeZIM website.

FiS Survey citation: Leszczensky, L., Pink, S., Kretschmer, D. & Kalter, F. 2020. 2020. Freundschaft und Identität in der Schule (Friendship and Identity in School). Datensatz. Version: 1.1.0. Berlin: Deutsches Zentrum für Integrations- und Migrationsforschung (DeZIM).
 
