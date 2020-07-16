#!/bin/sh

# Helper script for generating package data. First step is to download and
# parse out the Big 5 Personality scoring guide into a tabular format. This
# data is then piped into the data-raw/DATASET.R script

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
  > big_five_personality.csv

# Remove downloaded PDF
rm big-five-personality-test.pdf
