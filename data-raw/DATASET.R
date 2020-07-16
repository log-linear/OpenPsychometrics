#===============================================================================
# author:      Victor Faner
# author:      2020-06-17
# description: Script for creating package data
#===============================================================================
library(tidyverse)
library(here)
library(usethis)

#===============================================================================
# Create Big 5 scoring guide
#===============================================================================
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

b5 <- read_csv(here("data-raw/big_five_personality.csv"), col_names = F)
big_5_scoring_guide <- b5 %>% 
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
  
  arrange(question_number) %>% 
  
  # Get question numbers by trait to match dataset numbering
  group_by(trait) %>%
  mutate(question_number = row_number()) %>%
  ungroup()

#===============================================================================
# Get ranges for the randomnumber dataset
#===============================================================================

# Download dataset into a temporary file
url <- "https://openpsychometrics.org/_rawdata/randomnumber.zip"
td <- tempdir()
tf <- tempfile(tmpdir = td, fileext = ".zip")
download.file(url, tf, quiet = T)

# Extract and read file
fname <- paste("randomnumber", "codebook.txt", sep = "/")
unzip(tf, files = fname, exdir = td, overwrite = T)
f <- file.path(td, fname)

rand_num_ranges <- read_tsv(f, col_names = F) %>% 
  
  # Limit to random number ranges
  filter(str_detect(X1, "R")) %>% 
  
  # Extract lower and upper ranges
  extract(col = X2, 
          into = c("lower", "upper"), 
          "([0-9]+) and ([0-9]+)") %>% 
  
  # Rename fields
  rename(question_number = X1) %>% 
  mutate(question_number = str_extract(question_number, "[0-9]+"))

unlink(td)
unlink(tf)

#===============================================================================
# Get ranges for the randomnumber dataset
#===============================================================================
npi_scoring_guide <- read_csv(here("data-raw/npi_guide.csv"), 
                col_names = c("question_number", "positive_response")) 

#===============================================================================
# Save to R/sysdata.rda
#===============================================================================
use_data(
  big_5_scoring_guide,
  rand_num_ranges,
  npi_scoring_guide,
  
  internal = T,
  overwrite = T
)
