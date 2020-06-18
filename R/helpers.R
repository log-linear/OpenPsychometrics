#===============================================================================
# author: Victor Faner
# description: Miscellaneous helper functions for analyzing datasets
#===============================================================================

calc_big_five <- function(dataset) {
  load(here::here("R/sysdata.rda"))
  
  big_5_scores <- dataset %>%
    
    # Create a locally-scoped variable to uniquely ID each row
    dplyr::mutate(`_id` = dplyr::row_number()) %>% 
    
    # Pivot into a long format
    tidyr::pivot_longer(cols = tidyselect::matches("\\w\\d+"),
                        names_to = c("trait", "question_number"),
                        names_pattern = "(\\w)(\\d+)") %>%
    dplyr::mutate(question_number = as.numeric(question_number)) %>%
    dplyr::filter(
      
      # Filter down to Big Five traits
      (  trait == "O"
       | trait == "C"
       | trait == "E"
       | trait == "A"
       | trait == "N")
      &
      # Account for datasets with non-Big Five responses
      (  value == 1
       | value == 2
       | value == 3
       | value == 4
       | value == 5)
    ) %>%
    
    # Join in Big 5 scoring guide
    dplyr::left_join(
      big_5_scoring_guide
    ) %>%

    # Convert item-level response values according to scoring guide
    dplyr::mutate(value = value * ifelse(scoring_operation == "+", 1, -1)) %>%

    # Calculate scores for each Big 5 trait
    dplyr::group_by(`_id`, trait) %>%
    dplyr::mutate(trait_score = base_score + sum(value)) %>%
    dplyr::ungroup() %>% 
    dplyr::select(-question_number, 
                  -scoring_operation, 
                  -value, 
                  -base_score) %>% 
    dplyr::distinct() %>% 
    tidyr::pivot_wider(names_from = trait, 
                       values_from = trait_score) %>% 
    dplyr::select(-`_id`) %>% 
    dplyr::left_join(dataset)
  
  return(big_5_scores)
}
