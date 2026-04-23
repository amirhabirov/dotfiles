#!/bin/sh

volume="$(pamixer --get-volume)%"
if "$(pamixer --get-mute)" = "true"; then
    echo "( ${volume})"
else 
    echo "( ${volume})"
fi
