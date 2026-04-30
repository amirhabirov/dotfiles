#!/bin/sh

LOG_FILE=/tmp/warmup
TIME=900

create_log_file() {
  test -f $LOG_FILE || touch $LOG_FILE
}

calc_mins() {
  mins=$((${time} / 60))
  test $mins -gt 9 || mins="0${mins}"
}

calc_secs() {
  secs=$((${time} % 60))
  test $secs -gt 9 || secs="0${secs}"
}

calc_all() {
  calc_mins
  calc_secs
}

log_time() {
  echo "W ${mins}:${secs}" > $LOG_FILE
}

timer_cycle() {
  time=$((${time} - 1))
  calc_all
  log_time
  sleep 1 
}

timer() {
  time=$1
  while test $time -gt 0; do
    timer_cycle
  done
  notify-send -- "--> Godspeed you... Warmup! <--" 
}

main() {
  create_log_file
  while :; do
    timer $TIME
  done
}

main
