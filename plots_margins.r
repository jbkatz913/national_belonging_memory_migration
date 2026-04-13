# Author: Jordan Katz

# Title: National Belonging, "Official" Memory Culture, and the 
#        Moderating Role of Ethnic Background in Germany 

# Post-Estimation Plots (using Stata margins output)

# -------------------------------------------------------------------------


# This script imports and cleans the post-estimation output from STATA for 
# each of the fully adjusted models (controls_rs, controls_o, controls_re_s, 
# and controls_o_s) and generates predicted values and AME plots for 
# the models that appear within the body of the R&R manuscript.  

# NOTE: users must replace all input and output filepaths 


# load packages -----------------------------------------------------------

# install.packages(c("tidyverse", "readxl"))

pacman::p_load(tidyverse, readxl)



# import data -------------------------------------------------------------

# update file path accordingly 
setwd("./margins output/")


pv_rs <- read_xlsx("./pp_controls.xlsx")                      # Predicted values: M2 - Ethnic Majority and Immigrant Minorities

ame_o <- read_xlsx("./mrgns_controls_o.xlsx", skip = 1)       # AME: M4 - Ethnic Majority and Immigrant Minorities

pv_rs_s <- read_xlsx("./pp_controls_s.xlsx")                  # Predicted values: M2 - Muslim and non-Muslim Minorities

ame_o_s <- read_xlsx("./mrgns_controls_o_s.xlsx", skip = 1)   # AME: M4 - Muslim and non-Muslim Minorities




# figure 2 ----------------------------------------------------------------

fig_2 <- pv_rs |>
  rename(stats = "...1") |>
  filter(stats %in% c("b", "se", "ll", "ul")) |>
  pivot_longer(!stats, names_to = "margins", values_to = "values") |>
  pivot_wider(names_from = stats, values_from = values) |>
  mutate(
    dv = b,
    belong_avg = rep(seq(1, 5, by = 0.25), each = 2),
    category = ifelse(str_detect(margins, "#0bn.gen12"),
                   "Ethnic Majority", "Migration Background"),
    category = factor(category,levels = c("Migration Background", "Ethnic Majority")),
    .after = margins) |>
  ggplot(aes(x = belong_avg, y = dv, group = category, linetype = category)) +
  geom_line() +
  geom_ribbon(aes(ymin = ll, ymax = ul, color = NULL), alpha = 0.1, show.legend = FALSE) +
  ylim(2.25, 3.75) +
  theme_classic() +
  labs(x = "National Belonging", y = "") +
  theme(
    legend.position = c(0.75, 0.15),
    legend.title = element_blank(),
    legend.key.size = unit(.5, "cm"),
    legend.text = element_text(size = 8),
    axis.title.x = element_text(hjust = 0.9, size = 8, margin = margin(t = 12)),
    plot.title = element_text(size = 8)
    )   


# export
ggsave(fig_2,
       height = 5.5, width = 5.5, units = "in",
       filename = "fig_2.jpg",
       path = "[REPLACE]",
       device = "jpg")


# figure 3 ----------------------------------------------------------------

pd <- position_dodge(width = 0.4)

fig_3 <- ame_o |>
  rename(stats = "...1") |>
  filter(stats %in% c("b", "se", "ll", "ul")) |>
  pivot_longer(!stats, names_to = "margins", values_to = "values") |>
  pivot_wider(names_from = stats, values_from = values) |>
  mutate(
    dv = str_extract(margins, "^."),
    dv_str = case_when(
      dv == 1 ~ "not at all",
      dv == 2 ~ "not much",
      dv == 3 ~ "neither nor",
      dv == 4 ~ "rather much",
      dv == 5 ~ "very much"),
    dv_str = factor(dv_str, 
                    levels = c("not at all", "not much", "neither nor",
                               "rather much", "very much")),
    category = ifelse(str_detect(margins, "#1bn._at"),
                      "Ethnic Majority", "Migration Background"),
    .after = margins)|>
  ggplot(aes(x = b, y = dv_str, group = category, color = category)) +
  geom_point(position = pd) +
  geom_errorbarh(aes(xmin = ll, xmax = ul), height = 0.1, position = pd) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "black", alpha = 0.5) +
  scale_x_continuous(
    breaks = c(-0.05, -0.025, 0, 0.025, 0.05),
    labels = function(x) round(x, 3),
    limits = c(-0.05, 0.05)) +
  theme_classic() +
  labs(x = "National Belonging (AME)", y = "", color = "") +
  theme(
    legend.position = c(0.8, 0.25),
    legend.title = element_blank(),
    legend.key.size = unit(.5, "cm"),
    legend.text = element_text(size = 8),
    axis.title.x = element_text(hjust = 1, size = 8, margin = margin(t = 12)),
    plot.title = element_text(size = 8)
  ) 

# export
ggsave(fig_3,
       height = 5.5, width = 5.5, units = "in",
       filename = "fig_3.jpg",
       path = "[REPLACE]",
       device = "jpg")


# figure 4 ----------------------------------------------------------------

fig_4 <- pv_rs_s |>
  rename(stats = "...1") |>
  filter(stats %in% c("b", "se", "ll", "ul")) |>
  pivot_longer(!stats, names_to = "margins", values_to = "values") |>
  pivot_wider(names_from = stats, values_from = values) |>
  mutate(
    dv = b,
    belong_avg = rep(seq(1, 5, by = 0.25), each = 2),
    category = ifelse(str_detect(margins, "#0bn.ever_muslim"),
                   "non-Muslim", "Muslim"),
    category = factor(category,levels = c("non-Muslim", "Muslim")),
    .after = margins) |>
  ggplot(aes(x = belong_avg, y = dv, group = category, linetype = category)) +
  geom_line() +
  geom_ribbon(aes(ymin = ll, ymax = ul, color = NULL), 
              alpha = 0.1, show.legend = FALSE) +
  ylim(1.75, 3.75) +
  theme_classic() +
  labs(x = "National Belonging", y = "") +
  theme(
    legend.position = c(0.75, 0.15),
    legend.title = element_blank(),
    legend.key.size = unit(.5, "cm"),
    legend.text = element_text(size = 8),
    axis.title.x = element_text(hjust = 0.9, size = 8, margin = margin(t = 12)),
    plot.title = element_text(size = 8))  # + 


# export
ggsave(fig_4,
       height = 5.5, width = 5.5, units = "in",
       filename = "fig_4.jpg",
       path = "[REPLACE]",
       device = "jpg")



# figure 5 ----------------------------------------------------------------

fig_5 <- ame_o_s |>
  rename(stats = "...1") |>
  filter(stats %in% c("b", "se", "ll", "ul")) |>
  pivot_longer(!stats, names_to = "margins", values_to = "values") |>
  pivot_wider(names_from = stats, values_from = values) |>
  mutate(
    dv = str_extract(margins, "^."),
    dv_str = case_when(
      dv == 1 ~ "not at all",
      dv == 2 ~ "not much",
      dv == 3 ~ "neither nor",
      dv == 4 ~ "rather much",
      dv == 5 ~ "very much"),
    dv_str = factor(dv_str, 
                    levels = c("not at all", "not much", "neither nor",
                               "rather much", "very much")),
    category = ifelse(str_detect(margins, "#1bn._at"),
                      "non-Muslim", "Musim"),
    .after = margins) |>
  ggplot(aes(x = b, y = dv_str, group = category, color = category)) +
  geom_point(position = pd) +
  geom_errorbarh(aes(xmin = ll, xmax = ul), height = 0.2, position = pd) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "black", alpha = 0.5) +
  theme_classic() +
  labs(x = "National Belonging (AME)", y = "", color = "") +
  theme(
    legend.position = c(0.25, 0.75),
    legend.title = element_blank(),
    legend.key.size = unit(.5, "cm"),
    legend.text = element_text(size = 8),
    axis.title.x = element_text(hjust = 1, size = 8, margin = margin(t = 12)),
    plot.title = element_text(size = 8)
  ) 


# export
ggsave(fig_5,
       height = 5.5, width = 5.5, units = "in",
       filename = "fig_5.jpg",
       path = "[REPLACE]",
       device = "jpg")






# END ---------------------------------------------------------------------


