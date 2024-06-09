#!/bin/bash
#
# check for command line arguments
	CONFIGFILE = ./bin/config.sh
	while getopts c flag
	do
	    case "${flag}" in
	        c) CONFIGFILE=${OPTARG};;
	    esac
	done
# execute the content of this file
	source $CONFIGFILE
# init:
	cd $BASE_PATH

	# activate python venv
	source .venv/bin/activate
	
	if test ${?} != 0; then
		cd $CALL_PATH
		exit 1
	fi
	
# hvcc:
	# generating hvcc files
	echo hvcc "$PDFILE" -o gen -n "$LV_NAME" -p "$HVLIB" -g dpf --copyright "$LV_COPYRIGHT" -m "$METAFILE"
	hvcc "$PDFILE" -o gen -n "$LV_NAME" -p "$HVLIB" -g dpf --copyright "$LV_COPYRIGHT" -m "$METAFILE"
	if test ${?} != 0; then
		echo error generating hvcc. stopping.
		cd $CALL_PATH
		exit 2
	fi
	
# compiling:
	cd gen
	make
	if test ${?} != 0; then
		echo error compiling lv2. stopping.
		cd $CALL_PATH
		exit 3
	fi
