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
#alias dcc="ssh bernardoborges@login.dcc.ufmg.br"
alias cpdcc='function _cpdcc() { scp "$1" bernardoborges@login.dcc.ufmg.br:; }; _cpdcc'

eval "$(fnm env --use-on-cd)"

fwdPort() {
    local port="$1"
    ssh -fNT -L "$port":localhost:"$port" bernardoborges@speed &
}

alias FWD="ssh -fNT -L 32172:localhost:32172 bernardoborges@speed"

#alias bindPort='function _bindPort() { ssh -fNT -L ${1}:localhost:${1} bernardoborges@cloudvm'

#alias jup="ssh -fNT -L 20001:localhost:20001 bernardoborges@cloudvm"



alias gs="gswin64c"


facet() {
    local mat=2020006396
    local date="$1"
    echo $(( $(printf "%d" $(echo $(( mat + date )) | sha256sum \
     | awk '{print $1;}' | grep -oEe '....$' \
     | sed 's/^/0x/' \
     ) \
     ) % 4 ))
}

encrypt() {
    local filename="$1"
    openssl enc -aes-256-cbc -a -salt -in $filename -out $filename.enc
}

decrypt() {
    local filename="$1"
    openssl enc -d -aes-256-cbc -a -in $filename -out $filename.out
}
