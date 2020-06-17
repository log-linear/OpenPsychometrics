#===============================================================================
# author:      Victor Faner
# author:      2020-05-13
# description: Script for parsing the Big 5 Scoring Guide into a useable format.
#
# The initial parsed input data (as piped in by the shell script) is formatted 
# as follows:
#
#   E,20,1,-6,11,-16, ...
#   A,14,-2,7, ...
#   C,14,3, ...
#   N, ...
#   O, ...
#
# where each column corresponds with one of the question items for that Big 
# Five trait, with negative numbers denoting items that lower the overall
# trait score
#             
# This script reshapes this data as follows:
#
#   trait,base_score,question_number,scoring_operation
#   E,20,1,+
#   A,14,2,-
#   C,14,3,+
#   ...
#
# where each row represents a single question number, alongside its 
# corresponding Big Five trait, base score, and scoring operation.
#===============================================================================
library(tidyverse)
library(here)

raw <- read_csv(file("stdin") , col_names = F)

big_5_scoring_guide <- raw %>% 
  select(-X13) %>%  # Unused extra column 
  rename(
    trait = X1,
    base_score = X2
  ) %>%

  # Handle weird escape character 
  mutate(trait = if_else(trait == "\fE", "E", trait)) %>%

  # Reshape into a tidy format
  pivot_longer(cols = contains("X"),
               values_to = "question_number") %>% 
  select(-name) %>% 

  # Separate out "-" signs from actual question numbers
  mutate(
    scoring_operation = if_else(question_number < 0, "-", "+"),
    question_number = abs(question_number)
  ) %>%
  
  arrange(question_number)

# Save to R/sysdata.rda
usethis::use_data(big_5_scoring_guide, internal = T, overwrite = T)
