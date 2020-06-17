#!/bin/sh

# Script to download and parse out the Big Five Personality scoring guide.
# Final output file is saved in R/sysdata.rda

# Download file
wget https://openpsychometrics.org/printable/big-five-personality-test.pdf

# Parse into a tabular format
pdftotext big-five-personality-test.pdf - \
  | grep "[A-Z] =" \
  | sed -r "s/_+//g" \
  | sed -r "s/\(//g" \
  | sed -r "s/\)//g" \
  | sed -r "s/=//g" \
  | sed -r "s/ +/,/g" \
  | sed -r "s/([+-]),/\1/g" \
  | Rscript big_5_scoring_guide.R

# Remove downloaded PDF
rm big-five-personality-test.pdf
