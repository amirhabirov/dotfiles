#!/bin/sh

sound_path=/usr/share/sounds/freedesktop/stereo/complete.oga
mpv --no-video $sound_path > /dev/null 2>&1 &
