


#set -o vi     # allow ESC, /string ENTER for searching command line history.
# nah, new bash use ^R to search history

if [[ -z $ENV_TRACE_DOT_PROFILE ]] ; then
	#PS1='\u@\h \w \#\$ '
	#PS1='____\[\e[0;32m\]\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\] \[\e[1;32m\]\$\[\e[m\] '
	PS1='__rc__\[\e[0;32m\]\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\] viMode\[\e[1;32m\]>\[\e[m\] '
	export PS1
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE personal_bashrc__no_profile"
else
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE personal_bashrc__w_profile"
fi


[[ -f ~/.bashrc_cygwin ]] && source ~/.bashrc_cygwin && COMMON_ENV_TRACE="$COMMON_ENV_TRACE bashrc_cygwin"
##[[ -f ~/.alias_bashrc  ]] && source ~/.alias_bashrc  && COMMON_ENV_TRACE="$COMMON_ENV_TRACE alias_bashrc"  # using .bash_alias, sourced by .bashrc_cygwin


export COMMON_ENV_TRACE 




##  it seems that .bashrc is NOT sourced when doing sudo su - username
##  or when ssh in.  (so, bashrc not sourced when exec as login shell)
##
## but .bashrc is what is sourced for new shell in screen session (and terminal?)
## yet such case does not source .profile.
## what a pain!!
##
## actually, new man page says bash omit .profile if .bashrc exist.
## these days, bash_profile just seems to source bashrc, 
## so may as well just have everything in .bashrc !!

##~~2015.1106 [[ -z $ENV_TRACE_DOT_PROFILE ]] && source $HOME/.bash_profile
##[[ -z $ENV_TRACE_DOT_PROFILE ]] && source .profile

## going forward, just put stuff in .bashrc and forget .bash_profile


umask 0002      # i do want file default group writable
