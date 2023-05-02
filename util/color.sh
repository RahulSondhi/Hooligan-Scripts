#!/bin/bash

function convert_24bit_to_256 {
	# Check that exactly three arguments were provided
	if [ $# -ne 3 ]; then
			echo "Usage: $0 r g b"
			exit 1
	fi

	# Extract the RGB values from the command line arguments
	r=$1
	g=$2
	b=$3

# Calculate the 256-color code
if [ $r -gt 243 ] && [ $g -gt 243 ] && [ $b -gt 243 ]; then
  code=231
else
  r=$(( (r + 25) / 51 ))
  g=$(( (g + 25) / 51 ))
  b=$(( (b + 25) / 51 ))
  code=$(( 16 + (r * 36) + (g * 6) + b ))
fi

# Print the ANSI escape code with the 256-color code
echo -en $code
}