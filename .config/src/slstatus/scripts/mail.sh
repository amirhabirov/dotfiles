#!/bin/sh

MB_DIR=~/.mail/amirhabirov@disroot.org
LOG_FILE=/tmp/mail
MBSYNC_DELAY=900

create_mb_dir() {
  test -d $MB_DIR || mkdir -p $MB_DIR
}

clean_log_file() {
  echo > $LOG_FILE
}

sync_mb() {
  mbsync -aq && notmuch new > /dev/null 2>&1
}

get_uc() {
  uc=$(notmuch count tag:unread)
}

populate_log_file() {
  echo "{ @${uc} } " >  $LOG_FILE
}

maybe_notify() {
  get_uc && test $uc -gt 0 && populate_log_file || clean_log_file
}

run_once() {
  sync_mb && maybe_notify 
}

run_in_loop() {
  mbsync_delay=0
  while :; do
    if test $mbsync_delay -eq 0; then
      run_once && mbsync_delay=$MBSYNC_DELAY
    else
      mbsync_delay=$((${mbsync_delay} - 1))
      maybe_notify
    fi
    sleep 1
  done
}

main() {
  create_mb_dir
  clean_log_file
  test "$1" = "--sync" && run_once || run_in_loop
}

main "$1"
