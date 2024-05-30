#!/bin/bash
	source ./config.sh
	
	echo This is an example script for testing the lv2 plugin.
	echo It uses jalv.gtk to open the lv2 plugin from known lv2 directories \(i.e. "~/.lv2"\).
	echo Audacious as auioplayer.
	echo If you change this, the according jack connections should also be changed. A bit fiddling around could help...
	
	
	# for the test an audio file should be used, but it's not necessary
	AUDIOFILE=$BASE_PATH/pd/example.wav

	# automatic  established jack2 connections to the tested lv2
	JACK_NAME_AUDIO_OUT_PORT_L="PCM2900 Audio Codec Analog Stereo:playback_FL"
	JACK_NAME_AUDIO_OUT_PORT_R="PCM2900 Audio Codec Analog Stereo:playback_FR"

	# debugging information while testing
	DEBUG_FILE=$BASE_PATH/debug_msg.log

	
# init:
	cd $BASE_PATH

# starting: # lv2 with jalv gtk
	pw-jack jalv.gtk $LV2_URI 2>&1 > $DEBUG_FILE &
	if test ${?} != 0; then
		echo error running lv2. stopping.
		cd $CALL_PATH
		exit 4
	fi
	JALV_PID=$!
	echo running lv2 via jalv.gtk with PID=$JALV_PID
	
# running: #  audio file and connecting to LV2_URI
	pw-jack audacious $TESTFILE &
	if test ${?} != 0; then
		echo error running lv2. stopping.
		cd $CALL_PATH
		exit 5
	fi
	AUDACIOUS_PID=$!
	echo running audacious with PID=$AUDACIOUS_PID
	# connecting jack 
	sleep 3
	pw-jack jack_connect "$LV_NAME:lv2_audio_in_1"  "ALSA plug-in [audacious]:output_FL"
	pw-jack jack_connect "$LV_NAME:lv2_audio_in_2"  "ALSA plug-in [audacious]:output_FR"
	pw-jack jack_connect "$LV_NAME:lv2_audio_out_1" "$JACK_NAME_AUDIO_OUT_PORT_L"
	pw-jack jack_connect "$LV_NAME:lv2_audio_out_2" "$JACK_NAME_AUDIO_OUT_PORT_R"
	pw-jack jack_disconnect "ALSA plug-in [audacious]:output_FL" "$JACK_NAME_AUDIO_OUT_PORT_L"
	pw-jack jack_disconnect "ALSA plug-in [audacious]:output_FR" "$JACK_NAME_AUDIO_OUT_PORT_R"
	if test ${?} != 0; then
		echo error connecting jack ports or running audacious. stopping.
		cd $CALL_PATH
		exit 6
	fi

# debug:
	tail -f --pid "$JALV_PID" "$DEBUG_FILE"
	
# finalize:
	kill $JALV_PID
	kill $AUDACIOUS_PID
	cd $CALL_PATH
	exit 0
