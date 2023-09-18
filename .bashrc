# If not running interactively, don't do anything
#[[ "$-" != *i* ]] && return

# Command Prefix (~$ )
export PS1="\[\e[0;32m\]/\W$ \[\e[m\]"

# Default Makefile
export MAKEFILES="~/.makefile"

# Check Window Size
shopt -s checkwinsize

# MSYS2 packages
# pacman -Syu
# pacman -Syu
# pacman -S vim gcc make diffutils 

# Aliases
alias python3=python
alias dcc="ssh bernardoborges@login.dcc.ufmg.br"
alias cpdcc='function _cpdcc() { scp "$1" bernardoborges@login.dcc.ufmg.br:; }; _cpdcc'
alias cloud="ssh -p 4422 -i \"/c/Users/bernb/.ssh/cloud_bernardoborges\" bernardoborges@150.164.203.31"

eval "$(fnm env --use-on-cd)"
