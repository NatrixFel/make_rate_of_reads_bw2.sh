#!/bin/bash
# init variables
directory=""
output_file=""
prefix=""
postfix=""

# help
usage() {
  echo "Usage: $0 -d <directory> -o <output_file> -s <prefix> -e <postfix>"
  exit 1
}
# getopts
while getopts "d:o:p:s:" opt; do
  case "$opt" in
    d) directory=$OPTARG ;;
    o) output_file=$OPTARG ;;
    s) prefix=$OPTARG ;;
    e) postfix=$OPTARG ;;
    *) usage ;; 
  esac
done

if [ -z "$directory" ] || [ -z "$output_file" ] || [ -z "$prefix" ] || [ -z "$postfix" ]; then
  usage
fi

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
