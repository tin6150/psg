## .bashrc ##

COMMON_ENV_TRACE="$COMMON_ENV_TRACE personal_bashrc_start"


### hpcs stuff ###

if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
# https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/getting-started/sl6-module-farm-guide
# export MODULEPATH=$MODULEPATH:/location/to/my/modulefiles

ModDirList="/global/software/sl-6.x86_64/modfiles/tools \
/global/software/sl-6.x86_64/modfiles/langs \
/global/software/sl-6.x86_64/modfiles/intel/2013_sp1.4.211"

for ModDir in $ModDirList; do
	[[ -d $ModDir ]] && MODULEPATH=${MODULEPATH}:$ModDir
done
export MODULEPATH

[[    -d /global/software/sl-6.x86_64/modules/tools/git/ ]] && module load git
if [[ -d /global/software/sl-7.x86_64/ ]]; then
	module load vim
fi


### my old stuff, adapted to new work ###

#PS1='\u@\h \w \#\$ '
#PS1='____\[\e[0;32m\]\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\] \[\e[1;32m\]\$\[\e[m\] '
#PS1='__rc__\[\e[0;32m\]\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\] viMode\[\e[1;32m\]>\[\e[m\] '
PS1='__ \[\e[0;32m\]\u \H\[\e[m\] \[\e[1;34m\]\W\[\e[m\] \[\e[1;32m\]>\[\e[m\] '
[[ -n "$SINGULARITY_CONTAINER" ]] && PS1=${SINGULARITY_CONTAINER}" "${PS1}
export PS1

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
##
## going forward, just put stuff in .bashrc and forget .bash_profile

#set -o vi     # allow ESC, /string ENTER for searching command line history.
# nah, new bash use ^R to search history

umask 0002      # i do want file default group writable




## from from .alias, merging into here cuz want to be lazy and just link .bashrc for ~ to github

alias ls0="ls  -l | perl -lane 'if ($F[4] == 0 )    { print \$_ };' "   # can use $_ in shell, but need \$_ for sourced script
alias ls-0="ls -l | perl -lane 'if ($F[4] != 0 )    { print \$_ };' "
#alias ls-0="/home/hoti1/applet/script/ls-0.pl"
#alias ls0="/home/hoti1/applet/script/ls0.pl"

alias listuid="ypcat passwd | awk -F: ' {print \$3 \" \" \$1} ' | sort -n"
alias listgid="ypcat group  | awk -F: ' {print \$3 \" \" \$1} ' | sort -n"

alias Dirs='dirs | sed "s/\ /\n/g"'
alias printDbg='env | egrep DBG\|COMMON\|DOT\|SKEL\|SOFT'
alias printPath='echo $PATH | sed "s/:/\n/g"'
alias printLib='echo $LD_LIBRARY_PATH | sed "s/:/\n/g"'
alias printPerl5Lib='echo $PERL5LIB | sed "s/:/\n/g"'
alias chrome=chromium-browser 

#alias vncsvr30='vncserver -geometry 2400x1400 -depth 24'   # actual 2560x1600
#alias rdp1='rdesktop -N -a 16 -g 1840x1000'


alias rpmf="rpm -qa --qf '%{NAME} \t\t %{VERSION} \t %{RELEASE} \t %{ARCH}\n'"

alias sin=/usr/local/bin/singularity
alias Git=~/app/bin/git
alias nxc=/usr/NX/bin/nxclient
# lazy finger alias
alias ef='ps -ef'
alias lt="ls -latr"
alias ltr="ls -latr"

# overwrite default behaviour, keep command name
alias grep='grep --color=auto'
#alias ssh='ssh -o StrictHostKeyChecking=no'
#alias vi=vim	# vim not avail on sl7
alias lynx=elinks

# slurm alias, experimenting...
Sinfo() { sinfo  | awk '{print $1 "  " $2 "  " $3 "  " $4}' | sort -u ; }
# use declare -F to list defined functions.  fn must end with ; before closing with }

# sge alias, no longer useful
#alias qchk="qstat -f | awk '\$6 ~ /[a-zA-Z]/ {print \$0}'"
#alias qchk="qstat -f | awk '\$6 ~ /[a-zA-Z]/  &&  \$1 ~ /default.q@/  {print \$0}'"
#alias qs="qstat"
#qstat -f | grep au$                                                             # will get most of the nodes with alarm state, but misses adu, auE...
#qstat -f | awk '$6 ~ /[a-zA-Z]/ {print $0}'                                     # some host have error state in column 6, display only such host
#qstat -f | awk '$6 ~ /[a-zA-Z]/  &&  $1 ~ /default.q@compute/  {print $0}'      # add an additional test for nodes in a specific queue
#alias qmon="/cm/shared/apps/sge/2011.11p1/bin/linux-x64/qmon"  #don't work anyway
#alias qstate=/home/hoja2/bin/qstatstate.py
#alias qstate2=/home/hoja2/bin/qstatstate_op.py
#alias qtop=/home/hoti1/code/git/qtop/qtop.py
#alias qtop.py=/home/hoti1/code/git/qtop/qtop.py

# use declare -F to list defined functions
# qhostTot() { qhost | sed 's/G//g' | awk '/^sky/ {h+=1; c+=$3; m+=$8} END {print "host="h " core=" c " RAM=" m "G"}' ; }

COMMON_ENV_TRACE="$COMMON_ENV_TRACE personal_bashrc_end"
export COMMON_ENV_TRACE


