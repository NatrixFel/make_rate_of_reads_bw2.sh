**This script makes a summary CSV table of bowtie2 alignment rate from log files**

Usage: make_rate_of_reads.sh -d <logs_directory> -o <output_csv_summary> -s <log_prefix> -e <log_postfix>

# Example:

./make_rate_of_reads.sh -d current_directory -o output.csv  -s PAO_3_ -e .align.log
