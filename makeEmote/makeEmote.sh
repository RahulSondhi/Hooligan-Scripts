#!/bin/bash
source "$(dirname $0)/../util/progressBar.sh"

# Grab Params
if [[ ! -d "$1" ]]
then
    echo "$1 does not exist on your filesystem."
		exit 1
fi

if [ -z "$2" ]
  then
    echo "No output file name was passed"
		exit 1
fi

# Grab Info for Files To Convert
files_to_convert=`ls $1/*.png`
files_to_convert_count=`find $1 -name "*.png" | wc -l`
files_converted_count=0

# Setup Paths for new files
file_to_write="$2.ts"
temp_file_to_write="$2.temp.ts"

# Writing TS File
echo 'const emote = {' > $temp_file_to_write

echo -e "\n$(printf '=%.0s' $(seq 40))"
echo 'Starting Image Conversion'
echo -e "$(printf '=%.0s' $(seq 40))\n\n"
ProgressBar 0 100

for file_to_convert in $files_to_convert
do
	filename=$(echo "${file_to_convert##*/}" | sed 's/\.[^.]*$//')
	echo "\t\"$filename\": [" >> $temp_file_to_write

  while IFS= read -r line; do
    echo "\t\t\"$line\"," >> $temp_file_to_write
	done < <( ascii-image-converter $file_to_convert -C --width 60 )

	echo '\t],' >> $temp_file_to_write

	# Update Progress Bar 
	files_converted_count=$(($files_converted_count+1))
	ProgressBar $files_converted_count $files_to_convert_count
done

echo '}' >> $temp_file_to_write
echo 'export default emote' >> $temp_file_to_write

# Converts Terminal Color Codes to Something More Usable By JS
"$(dirname $0)/../util/ansi2unicode.sh" $temp_file_to_write $file_to_write

# Handles Cleanup
if [ $? -eq 0 ]; then
  rm $temp_file_to_write
else
	rm $temp_file_to_write
	rm $file_to_write
fi