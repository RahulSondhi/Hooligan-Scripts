#!/bin/bash

if [[ ! -d "$1" ]]
then
    echo "$1 does not exist on your filesystem."
		exit 0
fi

if [ -z "$2" ]
  then
    echo "No output file name was passed"
		exit 0
fi

yourfilenames=`ls $1/*.png`
file_to_write="$2.ts"

echo 'const emote = {' > $file_to_write
for eachfile in $yourfilenames
do
	filename=$(echo "${eachfile##*/}" | sed 's/\.[^.]*$//')
	echo "\"$filename\": [" >> $file_to_write

  while IFS= read -r line; do
    echo "\"$line\"," >> $file_to_write
	done < <( ascii-image-converter $eachfile -C --width 60 )

	echo '],' >> $file_to_write
done
echo '}' >> $file_to_write
echo 'export default emote' >> $file_to_write

$(./ansi2unicode.sh $file_to_write)
