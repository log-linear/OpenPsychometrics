#!/bin/sh

# Run all steps for packaging data

./big_five_guide.sh
./npi_guide.sh
Rscript DATASET.R

# Remove intermediate files
rm *.csv
