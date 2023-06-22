# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

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
