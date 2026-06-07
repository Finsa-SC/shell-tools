#!/bin/bash

read -p "Parent path: " PARENT_PATH
read -p "File name: " FILE_NAME

if [[ -z $PARENT_PATH ]]; then
    PARENT_PATH=$(pwd)
fi

FULL_PATH="$PARENT_PATH/$FILE_NAME"
if [[ -f $FULL_PATH ]]; then
    declare -l confirm
    read -p "Are you sure to clean file $FULL_PATH? (Y/n): " confirm
    if [[ $confirm == "y" || -z $confirm ]]; then
        cat /dev/null > $FULL_PATH
        echo "Successfully cleaned up the contents of the file"
    else
        echo "Cleaning file Canceled"
    fi
else
    echo "No such file or directory"
fi
