#!/bin/bash

orphans=$(pacman -Qdtq)

if [[ -z $orphans ]]; then
	echo "No unused packages found."
	exit 0
else
	echo "unused package found:"
	echo "${orphans}"

	declare -l confirm
	read -p "Did you want to delete unuses package? (y/N): " confirm
	
	if [[ $confirm == y ]]; then
		sudo pacman -Rns $orphans
		echo ""

		if (( $? == 0 )); then
			echo "Success deleting unused packages!"
		else
			echo "Failed to delete packages/"
		fi
	fi
fi
