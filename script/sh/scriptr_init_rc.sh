#!/bin/sh
#
#
# This script is invoked by the rc system.
# used on scriptr servers

## start/stop scriptr, as user "sys_usem_scriptr" 
##
## tin.ho@novartis.com
##
##  nn = startLevel  Sxx Kxx
##  eg start at rc3 and rc5,   start as S96, kill as K19
##
# chkconfig: 35 96 18
# description: scritr
#
# run from cli:
# sudo cp -p /home/hoti1/emv-sa/config_backup/sw/scriptr/scritr_init_rc /etc/init.d/scriptr
# sudo chkconfig --level 35 scriptr on
# sudo chkconfig --level 01246 scriptr off
#
RETVAL=0
prog="scriptr"
PROG="scriptr"
USARIO="sys_usem_scriptr"
TOUCH=/bin/touch
SUBSYSFILE=/var/lock/subsys/scriptr
SCRIPTR=/apps/scriptr/scriptr_server/scriptr.sh
SCRIPTR_ENV="PATH=/cm/shared/apps/sge/univa/bin/lx-amd64:/usr/prog/python/2.7.9-goolf-1.5.14-NX/bin:/usr/prog/check/0.9.14-goolf-1.5.14-NX/bin:/usr/prog/cmake/2.8.12.2-goolf-1.5.14-NX/bin:/usr/prog/ncurses/5.9-goolf-1.5.14-NX/bin:/usr/prog/cuda/7.0.28/:/usr/prog/cuda/7.0.28/bright_bin:/usr/prog/cuda/7.0.28/bin:/usr/prog/clang/3.5.2-GCC-4.8.2/bin:/usr/prog/sqlite/3.8.8.3-goolf-1.5.14-NX/bin:/usr/prog/blast/2.2.29-goolf-1.5.14-NX/bin:/usr/prog/FFTW/3.3.4-gompi-1.5.14-NX/bin:/usr/prog/OpenMPI/1.6.5-GCC-4.8.2-NX/bin:/usr/prog/hwloc/1.8.1-GCC-4.8.2-NX/bin:/usr/prog/GCC/4.8.2/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/apps/scriptr/scriptr_server"


GRP=sys_usem_scriptr # old version of su does not support -g option!!
#CATALINA_HOME=/usr/local/apache-tomcat-current/
#CATALINA_HOME=/app/apache-tomcat-current
#PATH=${JAVA_HOME}/bin:$PATH
#export JAVA_HOME CATALINA_HOME PATH GRP

#. /usr/local/tomcat.profile
#. /app/tomcat.profile
# use  $CATALINA_HOME/bin/setenv.sh now

# echo JAVA_HOME is set to $JAVA_HOME
# but the settings does not get inherited to  ${CATALINA_HOME}/bin/startup.sh
# cuz not apache!!   use su -m to preserve env.  sudo is bad (requiretty), avoid for init script!!

# utilities
ECHO=/bin/echo
SLEEP=/bin/sleep
BASENAME=/bin/basename
RMF="/bin/rm -f"
HOSTN=/bin/hostname
SU=/bin/su
EXPRN=/usr/bin/expr
CUT=/usr/bin/cut
CAT=/bin/cat
GREPX="/bin/grep -x"

TR=/bin/tr


case `/bin/uname` in
Linux) TR=/usr/bin/tr
       ;;
SunOS) if [ 'i86pc' = `/bin/uname -i` ]; then
          TR=/usr/xpg4/bin/tr
       fi
       ;;
esac

case `/bin/uname` in
  Linux)
    LOGGER="/usr/bin/logger"
    if [ ! -f "$LOGGER" ];then
    LOGGER="/bin/logger"
    fi
    LOGMSG="$LOGGER -puser.err"
    LOGERR="$LOGGER -puser.alert"
    ;;
  *)
    $ECHO "ERROR: Unknown Operating System"
    exit -1
    ;;
esac

start()
{
  $ECHO -n "Starting $PROG: "
  $TOUCH $SUBSYSFILE
  # touching this file is very very important
  # else, rhel service daemon don't think the service is running and will
  # skip this K-ill script!!!!


  if [ -f $SCRIPTR ]; then
	 ##sudo -u prog ". /usr/local/tomcat.profile; ${CATALINA_HOME}/bin/startup.sh"  ## don't work
	 #su -m --group=$GRP $USARIO -c ${CATALINA_HOME}/bin/startup.sh    ## old version of su does not support -g
	 su -l -m  $USARIO -c $SCRIPTR start &
	 #su -m  $USARIO -c $SCRIPTR_ENV $SCRIPTR start
  else
	echo "Unable to start $PROG,  ${SCRIPTR}  not found!"
  fi
}

stop()
{
  $ECHO -n "Stopping ${PROG}"
  #su  -m $USARIO ${CATALINA_HOME}/bin/shutdown.sh
  su -l -m  $USARIO -c $SCRIPTR stop &
  #su -m  $USARIO -c $SCRIPTR_ENV $SCRIPTR stop 
  rm $SUBSYSFILE
}

# See how we were called.
case "$1" in
  start)
    $LOGGER -p local7.info "Starting $PROG.  Args: $0 $1"
    start
    ;;
  stop)
    $LOGGER -p local7.info "Stoping $PROG.  Args: $0 $1"
    stop
    ;;
  *)
    echo 'Invalid argument, please use either "start" or "stop"'.  
esac

exit 0;
