#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias dotfiles='/usr/bin/git --git-dir=/home/day4me/.dotfiles/ --work-tree=/home/day4me'
export QT_QPA_PLATFORMTHEME=qt5ct
