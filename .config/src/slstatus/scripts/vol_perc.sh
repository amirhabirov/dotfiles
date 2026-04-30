#!/bin/sh

volume="$(pamixer --get-volume)%"
if "$(pamixer --get-mute)" = "true"; then
    echo "V ${volume} (M)"
else 
    echo "V ${volume}"
fi
