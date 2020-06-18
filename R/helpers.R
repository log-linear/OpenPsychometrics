#===============================================================================
# author: Victor Faner
# description: Miscellaneous helper functions for analyzing datasets
#===============================================================================

calc_big_5 <- function(dataset) {
  # Load scoring guide
  load(here::here("R/sysdata.rda"))
  
  # Create a locally-scoped row ID column
  dataset <- dataset %>%  
    dplyr::mutate(`_id` = dplyr::row_number())
  
  # Calculate Big 5 trait scores
  big_5_scores <- dataset %>%
    
    # Reshape into a long format
    tidyr::pivot_longer(cols = tidyselect::matches("\\w\\d+"),
                        names_to = c("trait", "question_number"),
                        names_pattern = "(\\w)(\\d+)") %>%
    dplyr::mutate(question_number = as.numeric(question_number)) %>%
    dplyr::filter(
      
      # Filter down to Big Five questions
      (   trait == "O"
        | trait == "C"
        | trait == "E"
        | trait == "A"
        | trait == "N" )
      &
      # Account for datasets with non-Big Five responses. Note that some
      # datasets have response values of 0. These records will return NA for
      # their Big 5 trait scores
      (   value == 1
        | value == 2
        | value == 3
        | value == 4
        | value == 5 )
    ) %>%
    
    # Join in Big 5 scoring guide
    dplyr::left_join(big_5_scoring_guide) %>%

    # Convert item-level response values according to scoring guide
    dplyr::mutate(value = value * ifelse(scoring_operation == "+", 1, -1)) %>%

    # Calculate scores for each Big 5 trait
    dplyr::group_by(`_id`, trait, base_score) %>%
    dplyr::summarize(trait_score = sum(value)) %>%
    dplyr::ungroup() %>% 
    dplyr::mutate(trait_score = trait_score + base_score) %>% 
    dplyr::select(-base_score) %>% 
    
    # Reshape back to original format
    tidyr::pivot_wider(names_from = trait, 
                       values_from = trait_score) %>% 
    
    # Join Big 5 scores back onto original dataset
    dplyr::full_join(dataset) %>% 
    dplyr::select(-`_id`)
  
  return(big_5_scores)
}
