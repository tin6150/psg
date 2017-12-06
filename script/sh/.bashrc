## .bashrc ##

##
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


### PSG/.bashrc -> PSG/sh/script/.bashrc
### making this so that it can be sourced as ADDITION rather than replace a machine or account specific .bashrc
### since diff acc/host will likely have diff config that I don't want to add too many test in here
### but then again, dir test before setup is likely enough... maybe keep going.
### worse case, fork off the alias into .alias 
### 2017-10-07

### after using addtoString, not much need for machine specific stuff
### so at this point, can still just replace a local .bashrc with this one



COMMON_ENV_TRACE="$COMMON_ENV_TRACE personal_bashrc_start"
## global /etc/bashrc need to be sourced before fn declarations so that PATH is seeded properly...  
## still didn't work in SL6, so seed it manually
##--echo "Path before anything.  $PATH"
PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin
[[ -f /etc/bashrc ]] && source /etc/bashrc
##--echo "Path after /etc/bashrc.  $PATH"
COMMON_ENV_TRACE="$COMMON_ENV_TRACE source_global_bashrc_returned"

###
###
###  function declaration section
###
###

# Function to avoid repetitive environment variable entries
# eg use after declaration:
# AddtoString PATH /usr/local/bin
# source: .profile from db2profile for setting up path
# originally hard coded, but linux don't have echo in  /usr/bin, 
# so just need to be sure echo, sed and awk are in PATH before calling this fn
# /etc/bashrc seems to define pathmunge , maybe use that instead...
AddtoString()
{
  var=$1
  addme=$2
  if [ -d $2 ]; then
    awkval='$1 != "'${addme?}'"{print $0}'
    newval=`eval echo \\${$var} | awk "${awkval?}" RS=:`
    eval ${var?}=`echo $newval | sed 's/ /:/g'`:${addme?}
    unset var addme awkval newval
  else
    return 1	# return false if dir ($2) does not exist  # Tin 2017.1007
  fi
}


setPrompt () {
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
} # end setPrompt 


add_local_module () {
	LOCAL_MODULE_DIR=/opt/modulefiles
	# ln -s ~/PSG/modulefiles/ /opt 
	AddtoString MODULEPATH ${LOCAL_MODULE_DIR} 
	SING_VER=2.4.2
	[[ -x /opt/singularity-${SING_VER}/bin/singularity ]] && module load container/singularity/${SING_VER}
	AddtoString MODULEPATH /opt/modulefiles/
	AddtoString MODULEPATH /opt2
	#AddtoString MODULEPATH /opt2/singularity-2.4.alpha/modulefiles
	#export MODULEPATH=$MODULEPATH:/opt/modulefiles/
	#export MODULEPATH=$MODULEPATH:/opt2
	#export MODULEPATH=$MODULEPATH:/opt2/singularity-2.4.alpha/modulefiles
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE add_local_module_ends"
} # end add_local_module


add_hpcs_module () {
	# perceus has no SMF at all, thus still need to test.  but SL6 vs SL7 are handled by other scg script
	#--if [[ -d /global/software/sl-7.x86_64/modfiles/tools ]]; then   # mounted in sl6 as well :(
		#module load vim  # only in sl7 module, throws err in sl6 :(
	##fi
	## the following don't load on perceus, but pretty much everywhere else...
	if [[ -d /global/software/ ]] ; then 
		module load git
		module load intel openmpi mkl
	fi
	## https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/getting-started/sl6-module-farm-guide
	## export MODULEPATH=$MODULEPATH:/location/to/my/modulefiles
	## some modules are avail after the language pack is loaded.  eg:
	## module load python/2.7.5
	## module load scikit-image
	## module load gcc openmpi
	# till /global/home/groups-sw/allhands/.bashrc  is fixed to include lr5:
	# export MODULEPATH=/global/software/sl-7.x86_64/modfiles/langs:/global/software/sl-7.x86_64/modfiles/tools:/global/software/sl-7.x86_64/modfiles/apps
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE personal_bashrc_ModDir_set"
} # end add_hpcs_module 

add_hpcs_bin () {
	##--echo "Path before mocking: $PATH"
	AddtoString PATH /global/home/groups/scs/IB-tools 
	AddtoString PATH /global/home/groups/scs/yqin
	##--echo "Path after mocking: $PATH"
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE add_group_bin_ends"
} # end add_hpcs_bin 

add_cosmic_module () {
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
} # end add_cosmic_module 

###
### define alias
###
###
### originally from from .alias, 
### merging into here cuz want to be lazy and just link .bashrc for ~ to github
###
defineAlias () {

	alias ls0="ls  -l | perl -lane 'if ($F[4] == 0 )    { print \$_ };' "   # can use $_ in shell, but need \$_ for sourced script
	alias ls-0="ls -l | perl -lane 'if ($F[4] != 0 )    { print \$_ };' "
	#alias ls-0="/home/hoti1/applet/script/ls-0.pl"
	#alias ls0="/home/hoti1/applet/script/ls0.pl"

	alias listuid="ypcat passwd | awk -F: ' {print \$3 \" \" \$1} ' | sort -n"
	alias listgid="ypcat group  | awk -F: ' {print \$3 \" \" \$1} ' | sort -n"

	#alias Dirs='dirs | sed "s/\ /\n/g"'  	# don't work in bash 3.2.57 x86_64-apple-darwin17
	alias Dirs="dirs | tr ' ' '\n'"		# work in macos
	alias printDbg='env | egrep DBG\|ENV_TRACE\|DOT\|SKEL\|SOFT'
	alias printTrace='env | fgrep ENV_TRACE | sed "s/ /\n/g"'
	alias printPath='echo $PATH | sed "s/:/\n/g"'
	alias printLib='echo $LD_LIBRARY_PATH | sed "s/:/\n/g"'
	alias printMod='echo $MODULEPATH | sed "s/:/\n/g"'
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

	alias vncsvr12='vncserver -geometry 1280x800 -depth 32'   #  macbook full screen, native 2304x1440. said should scale to 1400 x 900 but did not find it to be doing that.
        alias vncsvr14='vncserver -geometry 1440x840 -depth 24'   #  macbook pro window, native 2880x1800 Retina.  y=860 causes gvncviewer to scroll, so not using

	#alias vncsvr30='vncserver -geometry 2400x1400 -depth 32'   # actual 2560x1600
	#alias rdp1='rdesktop -N -a 16 -g 1840x1000'


	alias rpmf="rpm -qa --qf '%{NAME} \t\t %{VERSION} \t %{RELEASE} \t %{ARCH}\n'"

	#alias sin=/usr/local/bin/singularity
	#alias Git=~/app/bin/git
	alias nxc=/usr/NX/bin/nxclient
	# lazy finger alias
	alias ef='ps -ef'
	alias lt="ls -latr"
	alias ltr="ls -latr"
	alias sq="squeue"
	alias sqt="squeue -u tin"

	# overwrite default behaviour, keep command name
	alias grep='grep --color=auto'
	#alias ssh='ssh -o StrictHostKeyChecking=no'
	#alias vi=vim	# vim not avail on sl7
	alias vim="vim -c 'set shiftwidth=2 tabstop=4 formatoptions-=cro list'" 		# hopefully tab remains as tab for normal file edit
	alias vis="vim -c 'set shiftwidth=2 tabstop=4 formatoptions-=cro list nu expandtab'"    # for python coding.  ansible yaml may need tabstop=2
	alias gvim="gvim -c 'set shiftwidth=2 tabstop=4 formatoptions-=cro list'" 		
	alias gvis="gvim -c 'set shiftwidth=2 tabstop=4 formatoptions-=cro list nu expandtab'"  
	alias lynx=elinks

	###
	### Alias that need to be defined as function
	### use declare -F to list defined functions
	### use declare -f to see all gory details
	### NOTE: fn must end with ; before closing with }
	###

	Size() { ls -l $* | awk '{sum+=$5} END {print sum}' ; }         # Size *.txt  # not /usr/bin/size!

	# slurm alias, experimenting...
	Sinfo() { sinfo  | awk '{print $1 "  " $2 "  " $3 "  " $4}' | sort -u ; }
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE defineAlias_end"

} # end defineAlias

###
### mac alias, future may have to add more mac specific stuff ??
###
defineAliasMac () {
	[[ -f /Applications/RealVNC/VNC\ Viewer.app/Contents/MacOS/vncviewer ]] && alias vncviewer='/Applications/RealVNC/VNC\ Viewer.app/Contents/MacOS/vncviewer' 
	[[ -f /Applications/x2goclient.app/Contents/MacOS/x2goclient ]] && alias x2go=/Applications/x2goclient.app/Contents/MacOS/x2goclient
	# not sure why, but mac don't seems to heed the defineAlias block above, so explicitly re-define these.
	#alias vim="vim -c 'set shiftwidth=2 tabstop=4 formatoptions-=cro'"   # ansible yaml may need tabstop=2 :(
	alias vim="vim -c 'set syntax=on shiftwidth=2 tabstop=4 formatoptions-=cro'"   # ansible yaml may need tabstop=2 :(
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE macStuff"

} # end defineAliasMac 



###
### sge alias, no longer useful
###
defineAliasSge () {
	alias qchk="qstat -f | awk '\$6 ~ /[a-zA-Z]/ {print \$0}'"
	alias qchk="qstat -f | awk '\$6 ~ /[a-zA-Z]/  &&  \$1 ~ /default.q@/  {print \$0}'"
	alias qs="qstat"
	#qstat -f | grep au$                                                             # will get most of the nodes with alarm state, but misses adu, auE...
	#qstat -f | awk '$6 ~ /[a-zA-Z]/ {print $0}'                                     # some host have error state in column 6, display only such host
	#qstat -f | awk '$6 ~ /[a-zA-Z]/  &&  $1 ~ /default.q@compute/  {print $0}'      # add an additional test for nodes in a specific queue
	alias qmon="/cm/shared/apps/sge/2011.11p1/bin/linux-x64/qmon"  #don't work anyway
	alias qstate=/home/hoja2/bin/qstatstate.py
	alias qstate2=/home/hoja2/bin/qstatstate_op.py
	alias qtop=/home/hoti1/code/git/qtop/qtop.py
	alias qtop.py=/home/hoti1/code/git/qtop/qtop.py

	qhostTot() { qhost | sed 's/G//g' | awk '/^sky/ {h+=1; c+=$3; m+=$8} END {print "host="h " core=" c " RAM=" m "G"}' ; }

} # end defineAliasSge



###
###
### "main" - script start point
###
###

umask 0002      # i do want file default group writable


# the following will not save .bash_history when exit bash, so no xfer b/w sessions
# very useful when putting pw in env var 
export ANSIBLE_NOCOWS=1
export HISTFILESIZE=100
export HISTTIMEFORMAT="%d/%m/%y %T "	# once enabled, .bash_history get timestamp data as comment before each cmd.  eg #1504106987

#echo "DBG Path before source modules.sh.  $PATH"
[[ -f /etc/profile.d/modules.sh ]] && source /etc/profile.d/modules.sh
#echo "DBG Path after source modules.sh.  $PATH"
export EDITOR=vi
#set -o vi     # allow ESC, /string ENTER for searching command line history.
# nah, better to use ^R to search bash history



### some check for host specific stuff

MAQUINA=$(hostname)

if [[ x${MAQUINA} == x"c7" ]]; then
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE MAQUINA_c7"
	#add_local_module
	### xref https://github.com/singularityware/singularity-builder/blob/master/singularity_build.sh
fi	

if [[ x${MAQUINA} == x"c7" ]]; then
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE MAQUINA_backbay"

	# custom config in .bashrc of sn@backbay 
	# before adopting .bashrc from github PSG
	export SCALA_HOME=/opt/scala/scala-2.11.1
	export PATH=$SCALA_HOME/bin:$PATH

	export NVM_DIR="/home/sn/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

	alias xt=/usr/bin/xfce4-terminal
	#export ANDROID_HOME=/home/sn/app/android-studio
	export ANDROID_HOME=/home/sn/app/android-sdk
	export JAVA_HOME=/home/sn/app/jdk1.8.0_101
	export PATH=/home/sn/app/node-v4.5.0-linux-x64/bin:$PATH
	export PATH=/home/sn/app/jdk1.8.0_101/bin:$PATH
	export PATH=$PATH:/home/sn/app/android-studio/bin
	export EDITOR=vi



fi	


add_local_module	# runnable in c7, cueball, likely other, without presenting much problem hopefully

### hpcs stuff - may want to add check before calling fn, but okay too just let function do basic check
add_hpcs_bin
add_hpcs_module	# overwrite PATH and don't export it back correctly??  only in SL6... ??
add_cosmic_module 

setPrompt 
defineAlias
defineAliasMac
#defineAliasSge
[[ -f ~/.bashrc_cygwin ]] && source ~/.bashrc_cygwin && COMMON_ENV_TRACE="$COMMON_ENV_TRACE bashrc_cygwin"
##[[ -f ~/.alias_bashrc  ]] && source ~/.alias_bashrc  && COMMON_ENV_TRACE="$COMMON_ENV_TRACE alias_bashrc"  # using .bash_alias, sourced by .bashrc_cygwin




COMMON_ENV_TRACE="$COMMON_ENV_TRACE personal_bashrc_end"
export COMMON_ENV_TRACE

