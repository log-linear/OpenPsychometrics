#===============================================================================
# author: Victor Faner
# description: Miscellaneous helper functions
#===============================================================================

get_rand_ranges <- function() {
  url <- "https://openpsychometrics.org/_rawdata/randomnumber.zip"
  td <- tempdir()
  tf <- tempfile(tmpdir = td, fileext = ".zip")
  download.file(url, tf, quiet = T)
  fname <- paste(dataset, "codebook.txt", sep = "/")
  unzip(tf, files = fname, exdir = td, overwrite = T)
  f <- file.path(td, fname)
  d <- data.table::fread(f, sep = "\t", header = F)
  d <- dplyr::filter(d, stringr::str_detect(V1, "R"))
  d <- data.frame(stringr::str_extract_all(d$V2, 
                                           "[0-9]+", 
                                           simplify = T))
  d <- dplyr::mutate(d,
                     question_number = dplyr::row_number(),
                     lower = X1,
                     upper = X2)
  d <- dplyr::select(d, -X1, -X2)
  
  return(d)
}

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
