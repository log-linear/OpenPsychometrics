#!/bin/sh

# Script to download the Big Five Personality scoring guide from
# https://openpsychometrics.org/printable/big-five-personality-test.pdf into a 
# tabular format. Final output file is saved as etc/big_five_scoring.csv.
outdir="$(dirname "$(pwd)")"/etc
mkdir -p $outdir

# Download file
wget -P $outdir \
  https://openpsychometrics.org/printable/big-five-personality-test.pdf

# Parse into a csv
pdftotext "$outdir"/big-five-personality-test.pdf - \
  | grep "[A-Z] =" \
  | sed -r "s/_+//g" \
  | sed -r "s/\(//g" \
  | sed -r "s/\)//g" \
  | sed -r "s/=//g" \
  | sed -r "s/ +/,/g" \
  | sed -r "s/([+-]),/\1/g" \
  | Rscript big_five_scoring.R
