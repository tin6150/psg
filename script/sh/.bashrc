## .bashrc ##

# the following will not save .bash_history when exit bash, so no xfer b/w sessions
# very useful when putting pw in env var 
export HISTFILESIZE=0
export HISTTIMEFORMAT="%d/%m/%y %T "	# once enabled, .bash_history get timestamp data as comment before each cmd.  eg #1504106987

export EDITOR=vi

COMMON_ENV_TRACE="$COMMON_ENV_TRACE personal_bashrc_start"


### hpcs stuff ###

if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi
COMMON_ENV_TRACE="$COMMON_ENV_TRACE source_global_bashrc_returned"

[[ -f /etc/profile.d/modules.sh ]] && source /etc/profile.d/modules.sh
### not sre what's going on, but insist on SL6 MODULEPATH, so seeding it to null to start for now.
### 2017.0919
MODULEPATH=""
###Some stuff are in Yong's home dir, so sourcing them to be able to run staging test
MODULEPATH=$MODULEPATH:~yqin/applications/modfiles


export MODULEPATH=$MODULEPATH:/opt/modulefiles/
export MODULEPATH=$MODULEPATH:/opt2
#export MODULEPATH=$MODULEPATH:/opt2/singularity-2.4.alpha/modulefiles

# User specific aliases and functions
# https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/getting-started/sl6-module-farm-guide
# export MODULEPATH=$MODULEPATH:/location/to/my/modulefiles

## some modules are avail after the language pack is loaded.  eg:
## module load python/2.7.5
## module load scikit-image

ModDirList_sl6="/global/software/sl-6.x86_64/modfiles/tools \
/global/software/sl-6.x86_64/modfiles/langs \
/global/software/sl-6.x86_64/modfiles/intel/2013_sp1.4.211"

ModDirList_sl7="/global/software/sl-7.x86_64/modfiles/tools \
/global/software/sl-7.x86_64/modfiles/langs \
/global/software/sl-7.x86_64/modfiles/intel/2013_sp1.4.211"

## need a better way to be able to detect sl6...
ModDirList=$ModDirList_sl7

for ModDir in $ModDirList; do
	[[ -d $ModDir ]] && MODULEPATH=${MODULEPATH}:$ModDir
done
export MODULEPATH
COMMON_ENV_TRACE="$COMMON_ENV_TRACE personal_bashrc_ModDir_set"

[[    -d /global/software/sl-6.x86_64/modules/tools/git/ ]] && module load git

if [[ -d /global/software/sl-7.x86_64/ ]]; then
	#module load vim		# seems like vim no longer avail as module
	echo "" > /dev/null
fi


### my old stuff, adapted to new work ###

#PS1='\u@\h \w \#\$ '
#PS1='____\[\e[0;32m\]\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\] \[\e[1;32m\]\$\[\e[m\] '
#PS1='__rc__\[\e[0;32m\]\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\] viMode\[\e[1;32m\]>\[\e[m\] '
#PS1='__ \[\e[0;32m\]\u \H\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]>\[\e[m\] '
#PS1='\[\e[1;37\]___ \[\e[1;33m\]\u \H\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]>\[\e[m\] '
# http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
CYAN="\[\033[0;36m\]"
LIGHT_CYAN="\[\033[1;36m\]"
YELLOW="\[\033[1;33m\]"
WHITE="\[\033[1;37m\]"
GRAY="\[\033[1;30m\]"
LIGHT_GRAY="\[\033[0;37m\]"
NO_COLOUR="\[\033[0m\]"
#PS1="${CYAN}__ ${WHITE}\u ${CYAN}\H ${YELLOW}\w ${CYAN}> ${NO_COLOUR} "
# the one below pretty good in Terminal app in mac with Homebrew and custom brown text on dark blue bg profile
##PS1="${LIGHT_CYAN}__ ${WHITE}\u ${CYAN}\H ${LIGHT_GRAY}\w ${LIGHT_CYAN}> ${NO_COLOUR} "       ## good prompt, but hacking it so .rst file highlight prompt :)
PS1="${CYAN}**^ ${WHITE}\u ${LIGHT_CYAN}\H ${LIGHT_GRAY}\w ${CYAN}^**> ${NO_COLOUR} "		## for .rst highlight
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
alias hilite="grep --color -C100000"   # eg ip a | hilite inet
alias xlock="gnome-screensaver-command -l"	# lock screen and prompt for password right away.
alias xlck="gnome-screensaver-command -l"	# lock screen and prompt for password right away.
alias xlk="gnome-screensaver-command -l"	# lock screen and prompt for password right away.
#alias psh="ps H -H -eF -jl --context --headers --forest"
alias ssh="ssh -Y"
alias PS="ps -eLFjlZ  --headers "
alias axms="ps axms"	# threads view with lots of hex
alias aux="ps auxf"	# f for ascii forest
alias psr="ps -ALo pid,ppid,pcpu,wchan:16,psr,cmd:90,user --header | grep --color -C 200 PID.*USER"	# processor core number of ea pid

#alias vncsvr30='vncserver -geometry 2400x1400 -depth 24'   # actual 2560x1600
#alias rdp1='rdesktop -N -a 16 -g 1840x1000'


alias rpmf="rpm -qa --qf '%{NAME} \t\t %{VERSION} \t %{RELEASE} \t %{ARCH}\n'"

#alias sin=/usr/local/bin/singularity
#alias Git=~/app/bin/git
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


## cluster specific stuff
if [[ -d /global/groups/cosmic ]]; then
	# hope /global/groups/cosmic is only avail on cosmic.  if not, need something else...

	# troubleshooting David Shapiro's problem
	##module unload python
	module load gcc/4.4.7
	module load atlas/3.10.1-gcc
	module load fftw/3.3.3-gcc
	module load hdf5
	module load openmpi/1.8.4-gcc
	module load cuda
	module load gsl
	module load zeromq
	module load cmake
	module load boost
	module load sharp

	alias mpi='mpirun --hostfile /global/groups/cosmic/host_file'
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE cosmic_loaded"
fi



### mac stuff ###
[[ -f /Applications/RealVNC/VNC\ Viewer.app/Contents/MacOS/vncviewer ]] && alias vncviewer='/Applications/RealVNC/VNC\ Viewer.app/Contents/MacOS/vncviewer' 
[[ -f /Applications/x2goclient.app/Contents/MacOS/x2goclient ]] && alias x2go=/Applications/x2goclient.app/Contents/MacOS/x2goclient
COMMON_ENV_TRACE="$COMMON_ENV_TRACE macStuff"


COMMON_ENV_TRACE="$COMMON_ENV_TRACE personal_bashrc_end"
export COMMON_ENV_TRACE

