# Personal aliases and functions.

# Personal environment variables and startup programs should go in
# ~/.bash_profile.  System wide environment variables and startup
# programs are in /etc/profile.  System wide aliases and functions are
# in /etc/bashrc.

if [ -f "/etc/bashrc" ] ; then
  source /etc/bashrc
fi

alias ll='ls -l'
alias l='ls -alh'
alias duh='du -h --max-depth=1'
alias dfh='df -h'

# End ~/.bashrc
