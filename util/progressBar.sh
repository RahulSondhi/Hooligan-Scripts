#!/bin/bash

function ProgressBar {
	# Grab Params
	if [[ -z "$1" ]]
	then
			echo "No Current Count Passed"
			exit 1
	fi

	if [[ -z "$2" ]]
	then
			echo "No Total Count Passed"
			exit 1
	fi

	# Process data
	progress=$(echo "$1/$2" | bc -l )
	filledSpace=$(echo "$progress*40/1" | bc); echo $d
	emptySpace=$((40-$filledSpace))

	filledSpaceString=$(printf '#%.0s' $(seq $filledSpace))
	emptySpaceString=$(printf '*%.0s' $(seq $emptySpace))

	# Double Check It Doesnt Give Anything if 0
	if [ $filledSpace -lt 1 ] 
	then
		filledSpaceString=''
	fi

	if [ $emptySpace -lt 1 ] 
	then
		emptySpaceString=''
	fi

	# Progress: [########################################] 100%
	echo -e "\r\033[2A\033[0KProgress: [$filledSpaceString$emptySpaceString] $(echo "scale=2; $progress*100/1" | bc -l )%"
}