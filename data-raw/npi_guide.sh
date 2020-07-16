#!/bin/sh

# Helper script for generating package data. First step is to download and
# parse out the Big 5 Personality scoring guide into a tabular format. This
# data is then piped into the data-raw/DATASET.R script

# Download file
wget \
  https://openpsychometrics.org/printable/narcissistic-personality-inventory.pdf

# Parse into a tabular format
pdftotext narcissistic-personality-inventory.pdf - \
  | grep '[0-9]\+, ' \
  | awk '
      NR % 2 == 1 { gsub(/, |$/, ",A\n"); print } 
      NR % 2 == 0 { gsub(/, |$/, ",B\n"); print }
    ' \
  | sed '/^[[:space:]]*$/d' \
  > npi_guide.csv

# Remove downloaded PDF
rm narcissistic-personality-inventory.pdf
