# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#I like my console green
if [ "$STY" ]
 then
  export PS1='\[\033k\033\\\e[32m\]\u:\W \$ \[\e[0m\]'
 else
  export PS1='\[\e[32m\]\u:\W \$ \[\e[0m\]'
fi
