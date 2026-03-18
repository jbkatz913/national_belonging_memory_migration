# Author: Jordan Katz

# Title: National Belonging, "Official" Memory Culture, and the 
#        Moderating Role of Ethnic Background in Germany 

# Data Processing Script


# -------------------------------------------------------------------------

# This script imports the raw FiS survey data, cleans/recodes variables
# used in the analyses, drops respondents who do not provide responses
# for all variables used in the "basic" models (M1 & M3), and exports
# the processed data as a .dta file. The script also calculates a
# Cronbach's alpha for the two-item national belonging measure. 


# NOTE: users must replace input and output filepaths 


# load packages -----------------------------------------------------------

# install.packages(c("haven", "tidyverse", "psych")) 

pacman::p_load(haven, tidyverse, psych)


# import data -------------------------------------------------------------

# these data are available by application (see data availability statement)

# note to update file path accordingly 
setwd("[REPLACE]")

d <- read_dta("./dezim_fis_c_110/fis_data/dezim_fis_long_c_110.dta")


# clean data --------------------------------------------------------------

d2 <- d |> 
  labelled::remove_labels() |>                    # remove labels to avoid errors 
  mutate(
    dv = case_when(                               # reverse scales so higher values equal pro-Jewish sentiment                               
      g2_7 == 1 ~ 5,                              # recode "don't know" responses to NA 
      g2_7 == 2 ~ 4,               
      g2_7 == 3 ~ 3,
      g2_7 == 4 ~ 2,
      g2_7 == 5 ~ 1,
      TRUE ~ NA),    
    dv_cat = as.factor(dv),                       # create ordinal version of DV
    gen12 = case_when(                            # flag for 1st or 2nd gen (migration background)
      ed_miggen_cils_wide == 1 |
        ed_miggen_cils_wide == 2 ~ 1,
      ed_miggen_cils_wide == 3 |
        ed_miggen_cils_wide == 4 ~ 0,
      TRUE ~ NA),
    male = case_when(
      a6 == 1 ~ 0,
      a6 == 2 ~ 1,
      TRUE ~ NA),
    relig = ifelse(                               # combine w1 & w2-w6 relig variable
      is.na(e1_w2),                               
      e1_w1_group,
      e1_w2),      
    citizen = case_when(                          # GR citizenship: if either citizen variable is coded as GR 
      ed_miggen_cils_wide == 4 ~ 1,               # ensures respondents identified as "native" (4th gen+) coded as citizens
      b6_mc_1 == 1 | b6_coded_group == 1 ~ 1,   
      (b6_mc_1 == 0 | is.na(b6_mc_1)) &
        (b6_coded_group >= 2 & b6_coded_group <= 18) ~ 0,
      b6_mc_1 == 0 & is.na(b6_coded_group) ~ 0,
      TRUE ~ NA),
    across(                                       # reverse scales so higher values equal higher national belonging 
      .cols = c(b2_3, b2_4), 
      .fns = ~ case_when(                      
        . == 1 ~ 5,
        . == 2 ~ 4, 
        . == 3 ~ 3, 
        . == 4 ~ 2,
        . == 5 ~ 1)),
    across(                                       # reverse scales so higher values equal more time spent in neighborhood        
      .cols = c(g1_1, g1_5, g1_7),              
      .fns = ~ case_when(                       
        . == 1 ~ 6,
        . == 2 ~ 5,
        . == 3 ~ 4,
        . == 4 ~ 3,
        . == 5 ~ 2, 
        . == 6 ~ 1)),
    rlgsty = ifelse(                              # rename religiosity variable and code non-religious as "never" visit place of worship
      is.na(e3) &
        relig == 1,
      1,
      e3),
    id_s = as.factor(id_s),                       # convert school ID to factor variable
    mus_flag = case_when(                         # flag rows where "Muslim" for counter variable (mus_count)
      relig == 4 ~ 1,
      relig %in% c(1,2,3,5) ~ 0,
      TRUE ~ NA)
    )|>
  group_by(id_p) |>                               # group by id to create time-invariant vars
  mutate( 
    mus_count = sum(mus_flag, na.rm = T),         # count number of waves where respondent identifies as Muslim
    ever_muslim1 = case_when(                     # use counter to create time-invariant Muslim variable
      all(is.na(relig)) ~ NA,
      mus_count >= 1 ~ 1,
      mus_count == 0 ~ 0,
      TRUE ~ NA)
    ) |>
  ungroup() |>
  mutate(
    ever_muslim = ifelse(                         # this returns ever_muslim values to NA on a row by row basis if respondent
      is.na(relig) & ever_muslim1 == 0,           # never indicated "Muslim" and therefore cannot assume that respondent would 
      NA,                                         # not identify as Muslim in this NA row; if respondent had previously entered 
      ever_muslim1)
    ) |>                                          # NA then it is okay to recode NAs to 1 for ever_muslim 
  rowwise() |>                                    # create composite measures by combining items across columns (within rows)
  mutate(
    discrim_orig = ifelse(                        # calculate mean of discrimination items  
      ed_miggen_cils_wide %in% c(1,2,3) &         
        (!is.na(c9_1) & !is.na(c9_2) & !is.na(c9_3)),
      mean(c(c9_1, c9_2, c9_3)),
      NA),
    discrim_gr = ifelse(
      ed_miggen_cils_wide == 4 &
        (!is.na(d8_1) & !is.na(d8_2) & !is.na(d8_3)),
      mean(c(d8_1, d8_2, d8_3)), 
      NA),                                         
    discrim = case_when(                         # combine mean discrimination across origins
      ed_miggen_cils_wide %in% c(1,2,3) ~ discrim_orig,
      ed_miggen_cils_wide == 4 ~ discrim_gr,
      TRUE ~ NA),
    belong_avg = ifelse(                         # calculate average national belonging score 
      (!is.na(b2_3) & !is.na(b2_4)),
      mean(c(b2_3, b2_4)),
      NA)     
  )


# finalize analytic file --------------------------------------------------

analytic_df <- d2 |>
  drop_na(dv, b2_3, b2_4, gen12,                 # drop NA rows for variables used in basic models (M1 & M3) 
          ever_muslim, male) |>
  select(                                        # select necessary variables
    id_p, id_s, wave, svyyear, grade_qs, dv, 
    dv_cat, belong_avg, gen12, male, ever_muslim,
    rlgsty, citizen, g1_1, g1_5, g1_7, discrim,
    ed_miggen_cils_wide)
  


# Export processed data ---------------------------------------------------

write_dta(analytic_df, "/analytic.dta")



# Cronbach's alpha --------------------------------------------------------

# national belonging items 

cronbach_df <- d2 |> 
  drop_na(dv, b2_3, b2_4, gen12, ever_muslim, male)   # drop NA rows for variables used in basic models (M1 & M3) 

psych::alpha(cronbach_df[,c("b2_3", "b2_4")])




# END ---------------------------------------------------------------------


