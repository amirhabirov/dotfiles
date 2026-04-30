#!/bin/sh

save_point() {
  eval "$(xdotool getmouselocation --shell)"
}

detect_text() {
  xdotool mousemove "$X" "$Y" click 1 &
  orig_x="$X"
  orig_y="$Y"
  text="$(xclip -o -selection primary)"
  test -n "$text" || exit 0
}

translate_text() {
  goldendict "$text" &
}

restore_point() {
  xdotool mousemove "$orig_x" "$orig_y" &
}

main() {
  save_point
  detect_text && translate_text
  restore_point
}

main
