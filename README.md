# pd_to_zynthian_oram
 The command line bash scripts (linux) in the /bin/ dirctory can be used to create a development environment for pd patches' compilation.
 * initialize_lv2_dev.sh
 * config.sh
 * compile.sh
 * test.sh (to be customized by the user)

# How to create an lv2 plugin (example)

 First step is to clone the repository or download the zipped files and extract it to a local directory.
 ```
 git clone https://github.com/gitnob/pd_to_zynthian_oram.git CUSTOM_DIRECTORY
 cd CUSTOM_DIRECTORY
 ```
 All commands will be called from this directory. I.e.
 ```
 bin/initialize_lv2_dev.sh
 ...
 ```
 
## initialize_lv2_dev.sh
 This script creates some directories and downloads necessary repositories. Python >3.8 must be installed. 
 
 1. A virtual python environment will be created and set to active (.venv).
 2. hvcc module is installed with pip3.
 3. the following repositories are installed:
	- https://github.com/Wasted-Audio/heavylib
	- https://github.com/DISTRHO/DPF
	- https://github.com/DISTRHO/DPF-Widgets


## config.sh
This file is specific for only one lv2 plugin. **You have to adjust the specific parameters for this lv2 plugin.**
Most of the parameters are directly used for the hvcc command.
At the moment only the heavylib library is included as extra parameter.

## compile.sh
The script calls the following command
```
hvcc "$PDFILE" -o gen -n "$LV_NAME" -p "$HVLIB" -g dpf --copyright "$LV_COPYRIGHT" -m "$METAFILE"
```
All the arguments -o, -n, -p ... are described on the github page of hvcc:
https://github.com/Wasted-Audio/hvcc

After the translation into C++ code, the script calls the make command to create the lv2 plugin into the following location:

./gen/bin/NAME_OF_YOUR_LV"_PLUGIN.lv2

You can copy the directory to any specific location, for example into ~/.lv2 .

## test.sh

This is a very system specific script which calls the plugin by its LV_URI name. A audio player is also called and some jack2 audio connections are established. 
**You have to customize this script for your needs!**

# compiling lv2 for pd_to_zynthian (oram)

The development of the pd patch is best made on a desktop/laptop computer. You can use puredata (https://puredata.info/) or plugdata (https://plugdata.org/) for this - the later has a compiled mode, which suspends not by heavy supported puredata objects.
Read the heavy hvcc restrictions to not get into strange behaviour (https://github.com/Wasted-Audio/hvcc/blob/develop/docs/02.getting_started.md#known-limitations, https://github.com/Wasted-Audio/hvcc/blob/develop/docs/10.unsupported_vanilla_objects.md, and the special DPF comments under https://github.com/Wasted-Audio/hvcc/blob/develop/docs/03.gen.dpf.md).

After having tested the lv2 plugin on the desktop/laptop computer, you can create a directory within Zynthian's directory structure (/usr/local/src or similar) by cloning this repository. For example like this:
```
git clone https://github.com/gitnob/pd_to_zynthian_oram.git /usr/local/src/CUSTOM_DIRECTORY
cd /usr/local/src/CUSTOM_DIRECTORY
bin/initialize_lv2_dev.sh
```

Copy your tested puredata patch into the pd directory of the CUSTOM_DIRECTORY.
```
cp -r PATH_TO_YOUR_DEVELOPMENT_PD_PLUGIN_DIRECTORY CUSTOMDIRECTORY/pd	# copies the complete pd plugin directory
```
You can also link to your development directory.
```
ln -s PATH_TO_YOUR_DEVELOPMENT_PD_PLUGIN_DIRECTORY CUSTOMDIRECTORY/pd/PLUGIN_NAME	# symbolic link to the development directory
```

Set the parameters in config.sh. Especially if you are developing several plugins in pd, an even better way is to copy the bin/config.sh file to your pd code directory, make the changes as described in the config.sh file.

Compile the plugin with the help of hvcc:
```
bin/compile.sh	# if you are using the bin/config.sh file as a configuration file
```
or
```
bin/compile.sh -c CUSTOMDIRECTORY/pd/PLUGIN_NAME/config.sh 	# using bin/config.sh file in the pd directory
```

After compilation the newly created lv2 plugin can be found in CUSTOM_DIRECTORY/gen/bin/NAME_OF_YOUR_LV.lv2.

I suggest to soft link this newly created plugin with the command:
```
ln -s /usr/local/src/CUSTOM_DIRECTORY/gen/bin/NAME_OF_YOUR_LV.lv2 /zynthian/zynthian-plugins/lv2/
```
This makes your new lv2 plugin available for Zynthian.

After this you have to "Search For Engines" once to make your new plugin available in the long engines list of the webconf page.

This way, if you're still developing your lv2 plugin, the changes are automatically available in zynthian.
