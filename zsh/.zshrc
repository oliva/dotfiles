# ~/.zshrc
# vim: undofile

#source .profile
[ -x $HOME/.profile ] && source $HOME/.profile

# recompile this file if newer than the compiled zwc
[[ $HOME/.zshrc       -nt $HOME/.zshrc.zwc       ]] && zcompile $HOME/.zshrc
[[ $HOME/.zshrc.local -nt $HOME/.zshrc.local.zwc ]] && zcompile $HOME/.zshrc.local

emulate -L zsh
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' max-errors 2
zstyle ':completion::complete:*' use-cache 1
zstyle :compinstall filename '/home/oliva/.zshrc'

HISTFILE=~/.history
HISTSIZE=65536
SAVEHIST=65536
DIRSTACKSIZE=8
bindkey -e

fpath+="~/.zsh/completion"
autoload -U compinit colors prompt zmv
compinit
colors

#I don't use flow control
stty -ixon

#TODO autoload, zstyle, setopt
#changing directories
setopt autocd autopushd chasedots pushdminus pushdsilent
setopt autolist
setopt nohashdirs #make compinit find new executables

#TODO clean this up
setopt appendhistory notify noautomenu interactivecomments sharehistory appendhistory histignoredups histignorespace nohup extendedhistory histfindnodups noclobber chasedots
unsetopt menucomplete

unset HOSTID
[[ -n $SSH_TTY ]] && #if not a local session, show host on prompt
	HOSTID="@$(hostname -s)"


PROMPT="%(!.%F{blue}.%F{green})%n$HOSTID:%1~ %%%f "
#Bourne-style $#: PROMPT="%(!.%F{blue}.%F{green})%n$HOSTID:%1~ %(!.#.$)%f "
unset HOSTID

#no smiley
RPROMPT="%(?.%F{cyan}%b.%F{red})%T%F{default}%b"
#two-char smiley
#RPROMPT="%F{black}%B%T%b%(?.%F{green} :).%F{red} :()" ||
#fancy smiley
#RPROMPT="%F{black}%B%T%b%(?.%F{green} ☺.%F{red} ☹)"

zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

REPORTTIME=2

export EDITOR=`which vim`

#source .bashrc (modded for zsh)
[ -x $HOME/.zshrc.local ] && source $HOME/.zshrc.local

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" history-beginning-search-forward

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.

function zle-line-init () {
	echoti smkx
}
function zle-line-finish () {
	echoti rmkx
}

#zle -N zle-line-init
#zle -N zle-line-finish

#assume slash to not be a word character (for purposes of filepath part deletion)
WORDCHARS="${WORDCHARS/\//}"

#colorize stderr
#exec 2>>(while read line; do print '\e[91m'${(q)line}'\e[0m' > /dev/tty; print -n $'\0'; done &)

case $TERM in
	screen*)
		precmd () { print -Pn '\ek'"%~"'\e\\'; }
		preexec () { print -Pn '\ek'"${~1:gs/%/%%}\e\\" } # | cut -d' ' -f1)""\e\\"; }
		;;
	*|*xterm*|*rxvt*|alacritty|aterm|dterm|Eterm|gnome*|kterm)
		precmd () { print -Pn '\e]0;%n@%m:%~\a' }
		preexec () { print -Pn "\e]0;%n: ${~1:gs/%/%%}\a" } # | cut -d' ' -f1)""\a"; }
		;;
esac

#update prompt
zmodload -i zsh/sched
schedprompt() {
	# Remove existing event, so that multiple calls to "schedprompt" work.
	integer i=${"${(@)zsh_scheduled_events#*:*:}"[(I)schedprompt]}
	(( i )) && sched -$i

	zle && zle reset-prompt

	# Schedule next update
	sched +$((60-$(date +%S))) schedprompt
}

schedprompt
