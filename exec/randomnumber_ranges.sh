#!/bin/sh

# Get random number ranges for each question in the 
# randomnumbers codebook. Transformed data is saved
# in the /etc folder of the base project directory

outdir="$(dirname "$(pwd)")"/etc
mkdir -p $outdir

cat "$(dirname "$(pwd)")"/data/randomnumber/codebook.txt \
  | grep -o "[0-9]\{1,\} and [0-9]\{1,\}" \
  | sed "s/ and /,/g" \
  > $outdir/randomnumber_ranges.csv
