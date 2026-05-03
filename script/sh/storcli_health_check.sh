#!/bin/bash

# manual raid check for system with storcli, eg samoa
# 2025-1031

#  xref /etc/cron.d/raid-check
#  manually test (eg that mail is working)
#  bash  /usr/sbin/raid-check

# samoa cf
ln -s /usr/local/MegaRAID\ Storage\ Manager/StorCLI  /opt/ 
storcli64=/opt/StorCLI/storcli64  
#xx storcli64=/usr/local/MegaRAID\ Storage\ Manager/StorCLI/storcli64  # samoa


## try these commands, not well formed yet though.

$storcli64 /call show events | egrep "Event Description|Time"
$storcli64 /call /vall show 
$storcli64 /call /vall /eall show 

$storcli64 /c0 /eall /sall show all 
$storcli64 /c0 /eall /sall show all J | grep -iE "Ctrl|State|Status|Predict"

/opt/storcli64 /c0 /eall /sall show all J | grep -i state    # "all J" will show json format

## $storcli64 /c0 show alarm 		# whether controller alarm is enabled (probably whether alarm is usable, not whether it is beeping) [only for 9750 and 9690a)

# /opt/storcli64 /call show
# /opt/storcli64 /c0 show migraterate 
# /opt/storcli64 /c0/e8/sall show rebuild


# 
