#!/bin/bash

# Directory with logs
directory=$1

# Output CSV
output_file=$2

# Non-variable Prefix
prefix=$3

# Non-variable Postfix
postfix=$4

# CSV-header
echo "Filename,Total Reads (mln),Overall Alignment Rate,Calculated Value (mln)" > $directory/$output_file

# Check each files in the specified folder
for log_file in "$directory"/$prefix*.log; do
  filename=$(basename "$log_file" $postfix)
  total_reads=$(grep -oP '^\d+ reads' "$log_file" | awk '{print $1 * 2 / 1000000}')
  alignment_rate=$(grep -oP '^\d+\.\d+% overall alignment rate' "$log_file" | awk '{print $1}' | tr -d '%')
  
  calculated_value=$(echo "$alignment_rate" | sed 's/,/./' | awk '{print $1 / 100 * '$total_reads'}')
  
  echo "$filename,$total_reads,$alignment_rate,$calculated_value" >> $directory/$output_file
done

echo "CSV file '$output_file' created successfully."
