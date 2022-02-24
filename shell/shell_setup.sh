#######################
# Shell Modifications #
#######################

if [ -n "$ZSH_VERSION" ]; then
   export PS1="%n@%m %1~ %#"
elif [ -n "$BASH_VERSION" ]; then
   export PS1="\w:\h>"
fi
export CLICOLOR=1
export TERM=xterm-color
