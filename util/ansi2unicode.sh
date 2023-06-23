#!/bin/bash
source "$(dirname $0)/color.sh"
source "$(dirname $0)/progressBar.sh"

# Grab Params
if [[ ! -f "$1" ]]; then
  echo "$1 does not exist on your filesystem."
  exit 1
fi

if [ -z "$2" ]
  then
    echo "No output file name was passed"
		exit 1
fi

# Check it's not the same file
if [ $1 == $2 ]
  then
    echo "Output file must be different from input"
		exit 1
fi

file_to_write="$2"

echo "// Converted by ansi2unicode" > $file_to_write

# Progress Bar Tracking
lines_to_convert_count=$(wc -l < "$1")
lines_converted_count=0

echo -e "\n$(printf '=%.0s' $(seq 40))"
echo "Starting Ansi To Unicode Conversion"
echo -e "$(printf '=%.0s' $(seq 40))\n\n"

# Replace 24 bit colors with unicode 256
while IFS= read -r line || [[ -n "$line" ]]; do
  color_code_regex='\[38;2;([0-9]{1,3});([0-9]{1,3});([0-9]{1,3})m'
  while [[ "$line" =~ $color_code_regex ]]; do
    R=$((${BASH_REMATCH[1]}))
    G=$((${BASH_REMATCH[2]}))
    B=$((${BASH_REMATCH[3]}))
    color_code=$(convert_24bit_to_256 $R $G $B)
    color_code_subst='\[38;5;'$color_code'm'
    line=$(echo "$line" | sed -E "s/\[38;2;${R};${G};${B}m/$color_code_subst/g")
  done
  
  line=$(echo "$line" | sed -E "s/\\x1b/\\\u001b/g")
  echo -e "$line" >> "$file_to_write"

  # Update Progress Bar
  lines_converted_count=$(($lines_converted_count+1))
  ProgressBar $lines_converted_count $lines_to_convert_count
done < "$1"

# Final Progress Bar update
ProgressBar 100 100