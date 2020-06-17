#===============================================================================
# author: Victor Faner
#===============================================================================

calc_big_five <- function(raw) {
  # library(tidyverse)
  # library(here)
  # 
  # long <- raw %>% 
  #   pivot_longer(cols = matches("\\w\\d+"),
  #                names_to = c("question_type", "question_number"),
  #                names_pattern = "(\\w)(\\d+)") %>% 
  #   mutate(question_number = as.numeric(question_number))
  # 
  # big_5 <- long %>% 
  #   filter(question_type != "R") %>% 
  #   rename(trait = question_type) %>% 
  #   
  #   # Join in Big 5 scoring guide
  #   left_join(  
  #     read_csv(here("etc/big_five_scoring.csv")) %>% 
  #       
  #       # Get question numbers by trait to match dataset numbering
  #       group_by(trait) %>% 
  #       mutate(question_number = row_number()) %>%
  #       ungroup()
  #   ) %>%
  #   
  #   # Convert item-level response values according to scoring guide
  #   mutate(value = value * if_else(scoring_operation == "+", 1, -1)) %>%
  #   
  #   # Calculate scores for each Big 5 trait
  #   group_by(id, trait) %>% 
  #   mutate(trait_score = base_score + sum(value)) %>% 
  #   ungroup()
}
