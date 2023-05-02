#!/bin/bash

source ./util/color.sh

if [[ ! -f "$1" ]]; then
  echo "$1 does not exist on your filesystem."
  exit 0
fi

file_to_write="$(dirname $1)/converted-$(basename $1)"

echo "// Converted by ansii2unicode" > $file_to_write

while read -r line || [[ -n "$line" ]]; do
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
done < "$1"
