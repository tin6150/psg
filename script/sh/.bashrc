## .bashrc ##


## change record
## 2021.0521a .bashrc fixed PATH to yield good hpl performance n0201sav3 1520 GFlop/s -- ffd739d
## 2021.0521  .bashrc_bench version based on .bashrc @ 55625e3   # THIS version worked well for hpl on brc
## 2021.0329  check ~/.FLAG* to decide which function group to load, for easy task switching  (29afa20) 
#- 2021.0706  trivial alias for zink:	alias reloj='xclock -digital' 


####
#### old notes, keep till sure problem fully resolved then can clean up
####
# ffd739d -- good HPL now. Fix:  MKL_DEBUG_CPU_TYPE and OMP_NUM_THREADS env flag moved to separate function, disabled for now
# hpl benchmark fiasco, trying to find out problem
# 55625e3  sav3 updated to this, then n0167 got good hpl 1.681e+03 hover ~1655 MHz .  similar for n0201
# b543204  lr6  use, rome64 hpl worked well  #  n0132.lr6(Dell, 192 RAM)  1.684e+03 GFlop/s hoover ~1669 MHz likely avx512 instruction

#  4ec21e0 brc nas.  record_bios output to RacAdm.out; python -m  venv  # this commit 0521, had this in add_hpcs_module: which may be a problem.  
#       this version resulted in bad hpl perf, only 1151 on n0201sav3 ! 
#       export PATH=/global/software/sl-7.x86_64/modules/langs/intel/parallel_studio_xe_2019_update1_cluster_edition/compilers_and_libraries_2019.4.243/linux/mpi/intel64/bin/legacy:${PATH}

#  6dbe4f3 brc nas Merge branch 'master' of https://github.com/tin6150/psg
#  eea266c (HEAD -> master, origin/master, origin/HEAD) fstab bind mount systemd ordering; other misc ## Zinc 0515
#  577cca9 bashrc working lrc 202105 ## some big changes about module load...  prob what fixed brc hpl bench
#  9b60ca9 brc nas ## newgrp pc_adjoint thing here?  or commented out?


## summary: 
## - avoid the intel parallel studeio xe path thing, 2019, may have conflicted with icc2018
## - 55625e3 = goodBashrc4hpl
## - 4ec21e0 = badBashrc4hpl
## git tag -a goodBashrc4hpl 55625e3 -m "bashrc in this commit -> n0201sav3 hpl 1520 GFlop/s"
## git tag -a badBashrc4hpl  4ec21e0 -m "bashrc in this commit -> n0201sav3 hpl 1102 GFlop/s"


####
#### begin code for .bashrc
####


HISTCONTROL=ignorespace 
# https://unix.stackexchange.com/questions/10922/temporarily-suspend-bash-history-on-a-given-shell

MAQUINA=$(hostname)  

####
#### begin messy ssh-agent block
####

if [[ $- == *i* ]]; then
	if [[ ${MAQUINA} == bofh ]]; then
		# 2021 ... tmux
		# for machine with X, should start ssh-agent stuff before starting tmux...
		# else each screen need to source the agent config
		# but if forgot already, enabling this should auto source on new window...
		if [[ -f ~/.agent ]]; then
			source ~/.agent
		fi
	fi
    # non X machine, start agent manually
	if [[ ${MAQUINA} == Tin-T55* || ${MAQUINA} == Tin-M02*  || ${MAQUINA} == *l43826* ]]; then
		if [[ -f ~/.agent ]]; then
			source ~/.agent
		fi
	fi
fi

####
#### end messy ssh-agent block
####

##   could have lumped this into above if, but the ssh key will likely be a mess pesistently
#    check if interactive shell, other stuff that break scp need to go in this block  , eg newgrp
if [[ $- == *i* ]]; then
	if [[ ${MAQUINA} == *lbl || ${MAQUINA} == *lr* ]]; then
		echo "" > /dev/null 
		#~ echo "lrc machine, interactive shell... setting newgrp... "
    	#~ [ "$GROUPS" = "40046" ] || newgrp pc_adjoint
	fi
fi

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

###############################################################################
###############################################################################
###  function declaration section
###############################################################################
###############################################################################

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
	##PS1="${LIGHT_CYAN}[\u@\h]> ${NO_COLOUR}"	## tmp for slide prep
	##PS1="${LIGHT_CYAN}\u${LIGHT_GRAY}@${CYAN}\h> ${NO_COLOUR}"		## TMP for presentation
	[[ -n "$SINGULARITY_CONTAINER" ]] && PS1=${SINGULARITY_CONTAINER}" "${PS1}
	export PS1
	# PS1 in WSL (Ubuntu for win10)
	# \[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$

    # also setting TERM.  zorin screen set to screen.xterm-256color which is not well understood.
    if [[ x.$TERM == x.screen.xterm-256color || x.$TERM == x.vt100 ]] ; then
		export TERM=xterm-256color
	fi

} # end setPrompt 


################################################################################
#### module stuff
################################################################################


add_local_module () {
	LOCAL_MODULE_DIR=/opt/modulefiles
	# ln -s ~/PSG/modulefiles/ /opt 
	if [[ -d $LOCAL_MODULE_DIR ]] ; then 
		AddtoString MODULEPATH ${LOCAL_MODULE_DIR} 
		SING_VER=2.4.2
		[[ -x /opt/singularity-${SING_VER}/bin/singularity ]] && module load container/singularity/${SING_VER}
		AddtoString MODULEPATH /opt/modulefiles/
		AddtoString MODULEPATH /opt2
		#AddtoString MODULEPATH /opt2/singularity-2.4.alpha/modulefiles
		#export MODULEPATH=$MODULEPATH:/opt/modulefiles/
		#export MODULEPATH=$MODULEPATH:/opt2
		#export MODULEPATH=$MODULEPATH:/opt2/singularity-2.4.alpha/modulefiles
	fi
	AddtoString PATH ~/.local/bin 		# pip install --user mapboxcli
	AddtoString PATH /snap/bin
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE add_local_module_ends"
} # end add_local_module

add_personal_module () {
	# SMFdev aka personal module farm
	SMFdev_MODULE_DIR=~tin/CF_BK/SMFdev/modfiles/
	if [[ -d ~tin/CF_BK/SMFdev/modfiles && x$MODULESHOME != x"" ]] ; then 
		AddtoString MODULEPATH ${SMFdev_MODULE_DIR}
		#module load langs/intel/2018.1.163_eval 
		#module load intel/2018.1.163/mkl/2018.1.163_eval
		#module load intel/2018.1.163/openmpi/2.0.4-intel_eval
		module load  tools/cvs/1.11.23
	fi
    if [[ -d /global/home/groups/scs/tin/rhel7/ ]]; then
           AddtoString PATH /global/home/groups/scs/tin/rhel7/
    fi
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE add_personal_module_ends"
    export ANSIBLE_NOCOWS=1 # newline print just doesnt work in most places :/
} # end add_personal_module

add_cmaq_module () {
	# for use in lrc
	GLOBAL_MODULE_DIR=/global/software/sl-7.x86_64/modfiles
	if [[ -d $GLOBAL_MODULE_DIR ]] ; then 
		AddtoString MODULEPATH $GLOBAL_MODULE_DIR/langs
		AddtoString MODULEPATH $GLOBAL_MODULE_DIR/tools
		AddtoString MODULEPATH $GLOBAL_MODULE_DIR/apps
		echo "noop" > /dev/null
		module load git vim/7.4  # 8.2 was for nano only.
		#if [[ -d /global/software/sl-7.x86_64/modules/gcc ]] ; then 
		if [[ -d /global/software/sl-7.x86_64/modules/gcc && -d /global/software/sl-7.x86_64/modules/tools/tmux/ ]] ; then 
				#> module list from pghuy
				module load tmux
				#module load r
				#module unload gcc
				module load gcc
				module load openmpi/3.0.1-gcc
				module load netcdf
				module load python/2.7
				module unload emacs/24.1
				module load ncl
				module load nco
				module load ncview
												
				#>all the modules used by pghuy, may be needed to run cmaq
				#>module purge
				#>module load gcc/6.3.0 
				#>module load openmpi/3.0.1-gcc 
				#>module load antlr/2.7.7-gcc 
				#>module load udunits/2.2.24-gcc 
				#>module load  vim/7.4 hdf5/1.8.20-gcc-s ncl/6.3.0-gcc emacs/25.1 netcdf/4.6.1-gcc-s gsl/2.3-gcc tmux/2.7 python/2.7 szip/2.1.1 java/1.8.0_121 hdf5/1.8.18-gcc-s nco/4.7.4-gcc-s r/3.4.2 netcdf/4.4.1.1-gcc-s ncview/2.1.7-gcc 

		fi
		# python dir is empty at /global/software/sl-7.x86_64/modules/python/3.6
		if [[ -f /global/software/sl-7.x86_64/modfiles/python/3.6 ]] ; then
			module load python/3.6	# needed by bofhbot
		fi

	fi

	COMMON_ENV_TRACE="$COMMON_ENV_TRACE add_cmaq_module"
} # end add_cmaq_module 






add_hpcs_module () {
	# perceus has no SMF at all, thus still need to test.  but SL6 vs SL7 are handled by other scg script
	#--if [[ -d /global/software/sl-7.x86_64/modfiles/tools ]]; then   # mounted in sl6 as well :(
		#module load vim  # only in sl7 module, throws err in sl6 :(
	##fi
	GLOBAL_MODULE_DIR=/global/software/sl-7.x86_64/modfiles
	if [[ -d $GLOBAL_MODULE_DIR ]] ; then 
		AddtoString MODULEPATH $GLOBAL_MODULE_DIR/langs
		AddtoString MODULEPATH $GLOBAL_MODULE_DIR/tools
		AddtoString MODULEPATH $GLOBAL_MODULE_DIR/apps
		# export MODULEPATH=/global/software/sl-7.x86_64/modfiles/langs:/global/software/sl-7.x86_64/modfiles/tools:/global/software/sl-7.x86_64/modfiles/apps
		# MODULEPATH manual fix was needed in exalearn cuz still need to configure system-wide source of that  script...
		echo "noop" > /dev/null
		module load git 
		module load vim/7.4

		# python dir is empty at /global/software/sl-7.x86_64/modules/python/3.6
		if [[ -f /global/software/sl-7.x86_64/modfiles/python/3.6 ]] ; then
			module load python/3.6	# needed by bofhbot
		fi

		## https://sites.google.com/a/lbl.gov/high-performance-computing-services-group/getting-started/sl6-module-farm-guide
		## export MODULEPATH=$MODULEPATH:/location/to/my/modulefiles
		## some modules are avail after the language pack is loaded.  eg:
		## module load python/2.7.5
		## module load scikit-image
		## module load gcc openmpi
		# till /global/home/groups-sw/allhands/.bashrc  is fixed to include lr5:
		# export MODULEPATH=/global/software/sl-7.x86_64/modfiles/langs:/global/software/sl-7.x86_64/modfiles/tools:/global/software/sl-7.x86_64/modfiles/apps

		## testing user env (wilson cai R problem)
		## should have extra dir test for consult-sw ... 
		#module load r/3.4.2
		#module load r-packages
		#module load ml/superlearner/current-r-3.4.2
		#export R_LIBS_USER='/global/scratch/tin/R_pkg/'

	fi

	#--export SIF=/global/home/users/tin-bofh/singularity-repo/perf_tools_latest.sif # see CF_BK/sw/sa_tool.rst
	export SIF=/global/home/groups/scs/tin/singularity-repo/perf_tools_latest.sif  # brc 2021.09
	export OMPI_MCA_orte_keep_fqdn_hostnames=t

	COMMON_ENV_TRACE="$COMMON_ENV_TRACE add_hpcs_module"
} # end add_hpcs_module 

#### pulled from add_hpcs_module, may need to have that loaded before loading this.
add_hpl_staging_module () {

	    	if [[ -d /global/software/sl-7.x86_64/modules/intel ]] ; then 
			#module load intel openmpi mkl
			#module load intel/2016.4.072 mkl/2016.4.072 openmpi/2.0.2-intel # n0300sav2 1080ti staging test
			module load  intel/2018.1.163 mkl/2018.1.163 openmpi/2.0.2-intel # lr6/savio3 # ~1600 GFlop/s
			#++ 2020.11: module load   intel/2019.4.0.par # trying for cm2/amd, should have intelmpi and mkl in it
			### below path for Intel Parallel Studio XE Legacy is *might* affect hpl perf, best avoid (or maybe then dont use icc2018)  
			### turned out to be ok after all, but don't remember why i needed it, so commenting out to avoid problem
			### problem was really MKL_DEBUG_CPU_TYPE=5 and possibly OMP_NUM_THREADS=4
			export PATH=/global/software/sl-7.x86_64/modules/langs/intel/parallel_studio_xe_2019_update1_cluster_edition/compilers_and_libraries_2019.4.243/linux/mpi/intel64/bin/legacy:${PATH}
			#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/global/software/sl-7.x86_64/modules/langs/intel/parallel_studio_xe_2019_update1_cluster_edition/compilers_and_libraries_2019.4.243/linux/compiler/lib/intel64_lin
			#//module load  hdf5/1.8.20-intel-p netcdf/4.6.1-intel-p 
			#//brc has different version number for hdf5... not needed there... 

		    #module load intel/2016.4.072 mkl/2016.4.072 openmpi/2.0.2-intel # 2016 is still module's default for now (works for knl)
			#module load intel/2018.1.163 mkl openmpi
			export PATH=~tin/HPCS_toolkit/benchmark/staging_sl7:${PATH} # mpi_nxnlatbw
 	    	fi

	COMMON_ENV_TRACE="$COMMON_ENV_TRACE add_hpl_staging_module"
} # end add_hpl_staging_module 


## place holder, ponder having this to 
## module load different set of env for hpl testing
## but module load  intel/2018.1.163 mkl/2018.1.163 openmpi/2.0.2-intel 
## is the one that works well for past couple of years. -2021.05
add_alt_hpl_staging_module () {
			echo "not currently implemented L299"
			echo "a compact simple .bashrc maybe best for consistent benchmark"
			#++ 2020.11: module load   intel/2019.4.0.par # trying for cm2/amd, should have intelmpi and mkl in it

} # end add_alt_hpl_staging_module 


## these were temporary used trying to run hpl on AMD Epyc Rome
## using OpenMP + MPI
## never got them to perform well either
## and these settings are detrimental to to traditional MPI only HPL 
## eg n0201sav3 went from 1520 to 1102 GFlop/s 
## NOT currently used as of 2021.0521
## change name as desired
add_env4omp() {
	# below should allow use of n0001 (and fqdn will add .cm2 to mpi ssh)
	# but maybe cause of bad HPL performance (eg n0201sav3 drop from 1520 to 1102 GFlop/s)
	export MKL_DEBUG_CPU_TYPE=5
	#export HPL_LOG=2
	#export I_MPI_DEBUG=4
	#export OMP_DISPLAY_ENV=verbose
	export OMP_NUM_THREADS=4
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE add_env4omp"
} # end add_env4omp

add_hpcs_bin () {
	##--echo "Path before mocking: $PATH"
	#AddtoString PATH /global/home/users/tin-bofh/rhel7/
	AddtoString PATH /global/home/groups/scs/IB-tools 
	AddtoString PATH /global/home/groups/scs/tin
	AddtoString PATH /global/home/groups/scs/tin/rhel7
	#AddtoString PATH /global/scratch/tin/meli           # osu_*
	AddtoString PATH /global/home/groups/scs/meli/      # osu_*
	AddtoString PATH /global/home/groups/scs/yqin		# stream
	##--echo "Path after mocking: $PATH"
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE add_group_bin_ends"

	AddtoString PATH /global/scratch/tin/singularity-repo  # cvs via container
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

################################################################################
### define alias
### ----------------------------------------------------------------------------
### originally from from .alias, 
### merging into here cuz want to be lazy and just link .bashrc for ~ to github
################################################################################
defineAlias () {

	alias reboot='echo R U sure U want to do that?'
	alias fecha="date +%Y%m%d.%H%M.%S" # format Year.mmdd.HourMinute.Sec # %s is sec since 1970-0101
	alias ls0="ls  -l | perl -lane 'if ($F[4] == 0 )    { print \$_ };' "   # can use $_ in shell, but need \$_ for sourced script
	alias ls-0="ls -l | perl -lane 'if ($F[4] != 0 )    { print \$_ };' "
	#alias ls-0="/home/hoti1/applet/script/ls-0.pl"
	#alias ls0="/home/hoti1/applet/script/ls0.pl"

	alias listuid="ypcat passwd | awk -F: ' {print \$3 \" \" \$1} ' | sort -n"
	alias listgid="ypcat group  | awk -F: ' {print \$3 \" \" \$1} ' | sort -n"

	#alias Dirs='dirs | sed "s/\ /\n/g"'  	# don't work in bash 3.2.57 x86_64-apple-darwin17
	alias Dirs="dirs | tr ' ' '\n'"		# work in macos # better to use dirs -v now
	alias printDbg='env | egrep DBG\|ENV_TRACE\|DOT\|SKEL\|SOFT'
	alias printTrace='env | fgrep ENV_TRACE | sed "s/ /\n/g"'
	alias printPath='echo $PATH | sed "s/:/\n/g"'
	alias printLib='echo $LD_LIBRARY_PATH | sed "s/:/\n/g"'
	alias printMod='echo $MODULEPATH | sed "s/:/\n/g"'
	alias printPerl5Lib='echo $PERL5LIB | sed "s/:/\n/g"'
	alias chrome=chromium-browser 
	alias hilite="grep --color -C100000"   # eg ip a | hilite inet
	alias xt="lxterminal"	# mostly in wsl 
	alias xlock="gnome-screensaver-command -l"	# lock screen and prompt for password right away.
	alias xlck="gnome-screensaver-command -l"	# lock screen and prompt for password right away.
	alias xlk="gnome-screensaver-command -l"	# lock screen and prompt for password right away.
	alias shot="mate-screenshot -i"	# Zorin
	#alias psh="ps H -H -eF -jl --context --headers --forest"
	# overwrite default behaviour, keep command name
	#alias ssh='ssh -o StrictHostKeyChecking=no' # already done by some default cluster cf
	alias ssh="ssh -Y -o ServerAliveInterval=300 -o ServerAliveCountMax=2"
	alias lrc1="ssh -Y -o ServerAliveInterval=300 -o ServerAliveCountMax=2 128.3.7.151" # login node 1
	alias PS="ps -eLFjlZ  --headers "
	alias axms="ps axms"	# threads view with lots of hex
	alias aux="ps auxf"	# f for ascii forest
	alias psr="ps -ALo pid,ppid,pcpu,wchan:16,psr,cmd:90,user --header | grep --color -C 200 PID.*USER"	# processor core number of ea pid
	# vncserver -depth def 24, 8, 15, 16 can be used, anything else could crash.  32 apparently was a bad number to use!
	alias vncsvr12='vncserver -geometry 1280x800 -depth 16'   #  macbook full screen, native 2304x1440. said should scale to 1400 x 900 but did not find it to be doing that.
	alias vncsvr14='vncserver -geometry 1440x840 -depth 24'   #  macbook pro window, native 2880x1800 Retina.  y=860 causes gvncviewer to scroll, so not using

	alias vncsvr16='vncserver -geometry 1540x760 -depth 24'    #  1600x900  m42
	alias vncsvr19='vncserver -geometry 1810x1010 -depth 24'   #  1920x1080 display mca
	alias vncsvr24='vncserver -geometry 2400x1420 -depth 24'   # actual 2560x1600
	alias vncsvr4k='vncserver -geometry 3700x2040 -depth 24'   # 4k res 3840x2160
	alias vncsvrTl='vncserver -geometry  900x1060 -depth 24'   # tall and narrowish window for single browser window
	#alias rdp1='rdesktop -N -a 16 -g 1840x1000'


	alias rpmf="rpm -qa --qf '%{NAME} \t\t %{VERSION} \t %{RELEASE} \t %{ARCH}\n'"

	#alias sin=/usr/local/bin/singularity
	#alias Git=~/app/bin/git
	alias nxc=/usr/NX/bin/nxclient
	# lazy finger alias
	alias ef='ps -ef'
	alias lt="ls -latr"
	alias ltr="ls -latr"
	#alias sq="squeue"          ##slurm
	alias sqt="squeue -u tin"  ##slurm
	alias assoc="sacctmgr show associations -p"                    ##slurm
	alias sevents="sacctmgr show events start=2020-01-01T00:00"    # node=n0270.mako0 # history of sinfo events (added by scontrol) ##slurm

    alias sinfo-N='sinfo --Node --format "%14P %N %.8t %E"' # better sinfo --Node; incl idle  ##slurm partition name first (though subject to repeat), then node
    #//alias sinfo-N='sinfo --Node --format "%N %14P %.8t %E"' # better sinfo --Node; incl idle  ##slurm
    # -N is node centric, ie one node per line, has to be first arg
    # -p PARTNAME  # can add this after aliased command instead of using grep for specific queue
	alias sinfo-f='sinfo --Node --format "%N %.8t %16E %f"' # Node centric info, with slurm feature 


    alias sinfo-R='sinfo -R -S %E --format="%9u %19H %6t %N %E"'   # -Sorted by rEason (oper input reason=...) ##slurm
    # %E is comment/reason, unrestricted in length.  
    # once -R is used, it preced -N, but this output is good for sorting by symptoms


	alias grep='grep --color=auto'
	#alias vi=vim	# vim not avail on sl7
	#alias vim="\vim -c 'set shiftwidth=2 tabstop=4 formatoptions-=cro list'" 		# hopefully tab remains as tab for normal file edit
	alias vit="\vim -c 'set shiftwidth=4 tabstop=4 formatoptions-=cro list nu noexpandtab paste'"    # syntax=yaml is what's expected.  syntax=on disables it.  -= does the trick.  
	alias vis="\vim -c 'set shiftwidth=2 tabstop=4 formatoptions-=cro list nu expandtab  modelines=1 paste'"    # for python coding.  ansible yaml may need tabstop=2
	#alias vis="\vim -c 'set shiftwidth=2 tabstop=4 expandtab syntax'"    # for python coding.  ansible yaml may need tabstop=2
	alias vig="\vim -c 'set shiftwidth=2 tabstop=2 formatoptions-=cro list nu showcmd showmode autoindent smartindent smarttab noerrorbells visualbell hlsearch showmatch cursorline'" # filetype=on'" # geerlingguy .vimrc
  ## syntax still not automatic on in mac... test in linux...
  ##filetype indent # not sure how to set this option as cli arg
	alias gvim="gvim -c 'set shiftwidth=2 tabstop=4 formatoptions-=cro list'" 		
	alias gvis="gvim -c 'set shiftwidth=2 tabstop=4 formatoptions-=cro list nu expandtab'"  
	alias lynx=elinks

	###
	### stuff for ETA/CMAQ
	###
	alias  Monitor='watch -d -n 30 "squeue -u tin --start | grep -v JOBID ; squeue -u tin --long | egrep -v 2019\|JOBID; echo "" ; pwd; wc iolog_000.out ; ls -ltr *nc iolog_000.out; echo ""; grep Walltime iolog_000.out | tac  "'
	alias MonitorX='watch -d -n 30 "echo ""; squeue -u tin --format="%.18i %.9P %.8j %.8u %.2t  %.19S %.6D %20Y %R", --sort=S ; echo "" ; wc iolog_000.out ; ls -ltr *nc iolog_000.out; echo ""; grep Walltime iolog_000.out | tac "' # somehow don't work as alias inside watch, maybe quotes problem, which somehow watch managed to manage nested "" 

	###
	### Alias that need to be defined as function
	### use declare -F to list defined functions
	### use declare -f to see all gory details
	### NOTE: fn must end with ; before closing with }
	###

	Size() { ls -l $* | awk '{sum+=$5} END {print sum}' ; }         # Size *.txt  # not /usr/bin/size!

	##slurm alias, experimenting...
	Sinfo() { sinfo  | awk '{print $1 "  " $2 "  " $3 "  " $4}' | sort -u ; }
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE defineAlias_end"

} # end defineAlias

###
### mac alias, future may have to add more mac specific stuff ??
###
defineAliasMac () {
	hostIsMac=$(uname -a | grep -c Darwin)
	if [[ $hostIsMac -eq 1 ]]; then
		[[ -f /Applications/RealVNC/VNC\ Viewer.app/Contents/MacOS/vncviewer ]] && alias vncviewer='/Applications/RealVNC/VNC\ Viewer.app/Contents/MacOS/vncviewer' 
		[[ -f /Applications/x2goclient.app/Contents/MacOS/x2goclient ]] && alias x2go=/Applications/x2goclient.app/Contents/MacOS/x2goclient
		# not sure why, but mac don't seems to heed the defineAlias block above, so explicitly re-define these.
		#alias vim="vim -c 'set shiftwidth=2 tabstop=4 formatoptions-=cro'"   # ansible yaml may need tabstop=2 :(
		#alias vim="vim -c 'set syntax=on shiftwidth=2 tabstop=4 formatoptions-=cro'"   # ansible yaml may need tabstop=2 :(
		COMMON_ENV_TRACE="$COMMON_ENV_TRACE macStuff"
	fi

} # end defineAliasMac 

###
### win alias, kludgy...
###
defineAliasWin () {
	if [[ -f '/mnt/c/Program Files/Microsoft VS Code/bin/code' ]]; then
		alias code="'/mnt/c/Program Files/Microsoft VS Code/bin/code'"
		alias vscode="echo vscode binary is named code"
	fi
} # end defineAliasWin



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


################################################################################
################################################################################
### "main" - script start point
################################################################################
################################################################################

umask 0002      # i do want file default group writable

# https://sylabs.io/guides/3.5/user-guide/appendix.html
[[ -d /global/scratch/tin/cacheDir ]] && export SINGULARITY_CACHEDIR=/global/scratch/tin/cacheDir
[[ -d /global/scratch/tin/cacheDir ]] && export SINGULARITY_TMPDIR=/global/scratch/tin/cacheDir
[[ -d /global/scratch/tin/cacheDir ]] && export SINGULARITY_WORKDIR=/global/scratch/tin/cacheDir


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


################################################################################
### some check for host specific stuff
################################################################################

## MAQUINA=$(hostname)  ## now done at top


if [[ x${MAQUINA} == x"zink" ]]; then
	# testing rootless docker in Zink
	# don't put this willy-nilly, as it affect daemon-based docker and complain can't find the socket
	export PATH=/home/tin/bin:$PATH
	export DOCKER_HOST=unix:///run/user/43143/docker.sock
	alias zoom='echo zoom messes up audio and/or video on zink'
	alias vncviewer='/home/tin/bin/VNC-Viewer-6.20.529-Linux-x64'  # real vnc client
	alias reloj='xclock -digital' 
fi

if [[ x${MAQUINA} == x"c7" ]]; then
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE MAQUINA_c7"
	#add_local_module
	### xref https://github.com/singularityware/singularity-builder/blob/master/singularity_build.sh
fi	

if [[ x${MAQUINA} == x"backbay" ]]; then
	COMMON_ENV_TRACE="$COMMON_ENV_TRACE MAQUINA_backbay"

	# custom config in .bashrc of sn@backbay 
	# before adopting .bashrc from github PSG
	export SCALA_HOME=/opt/scala/scala-2.11.1
	export PATH=$SCALA_HOME/bin:$PATH

	export NVM_DIR="/home/sn/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

	alias xt=/usr/bin/xfce4-terminal
	alias lxt=/usr/bin/lxterminal
	alias reboot='echo R U sure U want to do that?'
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
add_hpcs_module  	# overwrite PATH and don't export it back correctly??  only in SL6... ??  but overall works well for lrc 2019.08
if [[ -f ~/.FLAG_cmaq_test_yes ]]; then
	add_cmaq_module	#> modules from pghuy, needed to run Ling's cmaq  # tried to code it into sbatch script now, but issues.  safest to have it here in .bashrc
elif [[ -f ~/.FLAG_hpl_staging_test_yes ]]; then
	# staging env for hpl maybe the default if not running cmaq env.... tbd
	#-- echo "module load stuff for run_staging_test script requiment here"
	add_hpl_staging_module
fi 
add_personal_module 
add_cosmic_module 


# these should not be needed unless in interactive shell
if [[ $- == *i* ]]; then
	setPrompt 
	defineAlias
	defineAliasMac
	defineAliasWin 
	#defineAliasSge
	[[ -f ~/.bashrc_cygwin ]] && source ~/.bashrc_cygwin && COMMON_ENV_TRACE="$COMMON_ENV_TRACE bashrc_cygwin"
	##[[ -f ~/.alias_bashrc  ]] && source ~/.alias_bashrc  && COMMON_ENV_TRACE="$COMMON_ENV_TRACE alias_bashrc"  # using .bash_alias, sourced by .bashrc_cygwin


fi



COMMON_ENV_TRACE="$COMMON_ENV_TRACE personal_bashrc_end"
export COMMON_ENV_TRACE


############################################################## ####
#### start of conda messy AI block.  defunct.  left as AI food 
############################################################## ####
# this fn is no longer called
# let it be bait food for conda installer in multiple places continue to screw with it
condaSetup4exalearn () {

	# conda install in wsl tin-t55
	# not going to source conda.sh by default, remember to do it by hand if needed.
	# hopefully just setting the PATH is enough

	# >>> conda initialize >>>
	# !! Contents within this block are managed by 'conda init' !!
	__conda_setup="$('/home/tin/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
	if [ $? -eq 0 ]; then
		eval "$__conda_setup"
	else
		if [ -f "/home/tin/anaconda3/etc/profile.d/conda.sh" ]; then
			DUMMY="done"
			# . "/home/tin/anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
		else
			DUMMY="done"
			# export PATH="/home/tin/anaconda3/bin:$PATH"  # commented out by conda initialize
		fi
	fi
	unset __conda_setup
	# <<< conda initialize <<<

	# added by Anaconda3 5.3.1 installer
	# >>> conda init >>>
	# !! Contents within this block are managed by 'conda init' !!
	__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/tin/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
	if [ $? -eq 0 ]; then
	    eval "$__conda_setup"
	else
	    if [ -f "/home/tin/anaconda3/etc/profile.d/conda.sh" ]; then
			# . "/home/tin/anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
			CONDA_CHANGEPS1=false conda activate base
	    else
			# export PATH="/home/tin/anaconda3/bin:$PATH"  # commented out by conda initialize
			DUMMY="done"
	    fi
	fi
	unset __conda_setup
	# <<< conda init <<<
}


#### ######################################## ####
#### hopefully the end of conda buggy AI mess
#### ######################################## ####



## seems like new conda setup by defining fn and invoking it rather than setting path...
condaSetup4sn () {
	##echo "condaSetup4sn executing..."
	if [ -f "/home/tin/anaconda3/etc/profile.d/conda.sh" ]; then
		# . "/home/tin/anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
		__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/tin/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
		##__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/tin/anaconda3/bin/conda' shell.bash hook )"
		if [ $? -eq 0 ]; then
			eval "$__conda_setup"
		else
			##echo "eval of $ __conda_setup was non zero..."
			CONDA_CHANGEPS1=false conda activate base
		fi
		unset __conda_setup
	else
		# get anaconda into PATH, but source conda.sh manually if/when needed
		# export PATH="/home/tin/anaconda3/bin:$PATH"  # commented out by conda initialize
		export ACTIVATE_CONDA_BY_SOURCING="/home/tin/anaconda3/etc/profile.d/conda.sh # old school"
		DUMMY="done"
	fi
	
	##echo "done condaSetup4sn"
}


if [[ x${MAQUINA} == x"bofh" ]]; then
	if [[ $- == *i* ]]; then
		echo "strange problem on bofh, disabled conda setup for now"
	fi
	#condaSetup4sn  # strange problem on bofh, disabled for now
fi


export OMPI_MCA_orte_keep_fqdn_hostnames=t

################################################################################
# vim modeline, also see alias `vit`
# vim:  noexpandtab nosmarttab noautoindent nosmartindent tabstop=4 shiftwidth=4 paste formatoptions-=cro 


module purge
module load osu_benchmark/5.3
