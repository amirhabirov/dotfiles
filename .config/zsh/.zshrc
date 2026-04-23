# Set up the prompt

PROMPT="%n@%m:%~\$ "

# Use vi keybindings

bindkey -v

# Use modern completion system

autoload -Uz compinit && compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Set up aliases

source $XDG_CONFIG_HOME/shell/aliases

# History 

setopt histignorealldups sharehistory

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=$ZDOTDIR/.zsh_history

# Start tmux automatically every time I open terminal

if test -z "$TMUX" && test -n "$DISPLAY" && test $UID -ne 0; then
	tmux new-session -A -s "tmux"
fi
