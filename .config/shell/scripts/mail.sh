#!/bin/sh

MB_DIR=~/.mail
DELAY=300
PREV_UC=0

mk_mb_dir() {
  test -d $MB_DIR || mkdir $MB_DIR
}

sync_mb() {
  (mbsync -aq && notmuch new) > /dev/null 2>&1
}

get_uc() {
  uc="$(notmuch count tag:unread)"
}

notify() {
  notify-send -- "--> New Email(s)... <--" 
}

run_once() {
  sync_mb && get_uc
  test $uc -le $PREV_UC || notify
  PREV_UC=$uc
}

run_in_loop() {
  while :; do
    run_once
    sleep $DELAY
  done
}

main() {
  mk_mb_dir 
  test "$1" = "--sync" && run_once || run_in_loop
}

main $1
