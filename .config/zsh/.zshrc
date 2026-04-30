PROMPT="%n@%m:%~\$ "

bindkey -e

autoload -Uz compinit && compinit

setopt histignorealldups sharehistory

test -z "$TMUX" \
  && test "$TERM" != "xterm-256color" \
  && test -n "$DISPLAY" \
  && test $UID -ne 0 \
  && tmux new-session -A -s "!"
