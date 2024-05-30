#!/bin/bash
BASE_PATH=$PWD
CALL_PATH=$OLD_PWD

# init:
	cd $BASE_PATH

# init python virtual environment
# if it does not exist, create it and start it

	if [ "${VIRTUAL_ENV}" == "" ] ; then
		if [ ! -d ".venv" ]; then
			python3 -m venv .venv
			if test ${?} != 0; then
				echo Creation of virtual environment failed. Stopping script.
				cd $CALL_PATH
				exit 1
			fi
		fi
		source .venv/bin/activate
		if test ${?} != 0; then
			echo Activation of virtual environment failed. Stopping script.
			cd $CALL_PATH
			exit 2
		fi
	else 
		if [ "${Virtual_ENV}" != "$PWD/.venv" ] ; then
			echo Please deactivate other virtual python environment before continue. Stopping script.
			exit 2
		fi
	fi
	echo Virtual python environment activated \($VIRTUAL_ENV\).
	
# install hvcc within virtual environment
	pip3 install hvcc
	if test ${?} != 0; then
		cd $CALL_PATH
		exit 3
	fi
	echo Heavy compiler environment installed.

# clone heavylib and dpf, as well as dpf-widget repository to lib resp. gen directory
	if [ ! -d "$PWD/lib/heavylib" ] ; then
		git clone https://github.com/Wasted-Audio/heavylib.git $BASE_PATH/lib/heavylib
		if test ${?} != 0; then
			echo Cloning of hvcc repository failed. Stopping script.
			cd $CALL_PATH
			exit 4
		fi
	echo Heavylib patches for puredata installed \($BASE_PATH/lib/heavylib\).
	fi
	
	if [ ! -d "$PWD/gen/dpf" ] ; then
		git clone https://github.com/DISTRHO/DPF.git $BASE_PATH/gen/dpf
		if test ${?} != 0; then
			echo Cloning of hvcc repository failed. Stopping script.
			cd $CALL_PATH
			exit 4
		fi
	fi
	
	if [ ! -d "$PWD/gen/dpf-widgets" ] ; then
		git clone https://github.com/DISTRHO/DPF-Widgets.git $BASE_PATH/gen/dpf-widgets
		if test ${?} != 0; then
			echo Cloning of hvcc repository failed. Stopping script.
			cd $CALL_PATH
			exit 4
		fi
	fi
	echo DPF repositories installed \($BASE_PATH/gen\)
	
# going back to old directory
	cd $CALL_PATH
	echo Succesfully created development environment. Place code into pd directory \(must be heavy compatible\).
	echo 
	echo -e Config:'\t\t'bin/config.sh
	echo -e Compile:'\t'bin/compile.sh	
	echo -e Testing:'\t'bin/test.sh		\(needs jalv to be installed\)
	
