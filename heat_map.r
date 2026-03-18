# Author: Jordan Katz

# Title: National Belonging, "Official" Memory Culture, and the 
#        Moderating Role of Ethnic Background in Germany 

# Heat Map Script


# -------------------------------------------------------------------------


# This script uses the analytic.dta file to generate a heat map plot
# of the DV and IV across grades and analytic groups.

# NOTE: users must replace inout and output filepaths


# load packages -----------------------------------------------------------

# install.packages(c("haven", "tidyverse", "ggthemes"))

pacman::p_load(haven, tidyverse, ggthemes)



# import data -------------------------------------------------------------

# note to update file path accordingly 
setwd("[REPLACE]")

d <- read_dta("./analytic.dta")



# prepare data ------------------------------------------------------------


d_heat <- d |>
  select(id_p, dv_cat, belong_avg, grade_qs, gen12, ever_muslim) |>
  mutate(
    grade = paste0("G", grade_qs),
    grade = factor(grade,
                   levels = c("G5", "G6", "G7", "G8", "G9", "G10")),
    cat3 = case_when(
      ever_muslim == 1 ~ "Muslim",
      gen12 == 1 & ever_muslim == 0 ~ "non-Muslim",
      gen12 == 0 & ever_muslim == 0 ~ "Majority"),
    cat3 = factor(cat3, 
                  levels = c("Majority", "non-Muslim", "Muslim"))
    ) |>
  group_by(grade, cat3, dv_cat, belong_avg) |>
  summarise(count = n(), .groups = "drop") %>%
  group_by(grade, cat3) %>%
  mutate(prop = count / sum(count)) %>%
  ungroup()



# plot --------------------------------------------------------------------

# first define category colors
category_colors <- c(
  "Muslim" = "black",
  "non-Muslim" = "black",
  "Majority" = "black")


# plot
heat_map <- ggplot(d_heat, aes(x = belong_avg, y = dv_cat, alpha = prop)) +
  geom_tile() +
  scale_fill_manual(
     values = "category_colors",
     name = "") +
   scale_alpha_continuous(
     range = c(0.1, 1.5),
     guide = "none") +
  labs(
    y = "How much do you like Jews?",
    x = "National Belonging"
   ) +
  facet_grid(
    rows = vars(cat3),
    cols = vars(grade)) +
  theme_classic() +
  theme(
    plot.title = element_text(size = 12),
    panel.grid = element_blank(),
    strip.background = element_blank(),
    strip.text.y = element_text(size = 12),           
    strip.text.x = element_text(size = 12),     
    axis.title.x = element_text(hjust = 0.9, 
                                margin = margin(t = 10), size = 12),
    axis.title.y = element_text(angle = 90, vjust = 1.5, hjust = 0.9,
                                margin = margin(r = 10), size = 12))

# export
ggsave(heat_map, 
       height = 6, 
       width = 12,
       dpi = 400, 
       device = "png",
       units = "in",
       filename = "/fig_1.jpg")






