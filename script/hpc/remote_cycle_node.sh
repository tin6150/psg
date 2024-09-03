#!/bin/sh

#### this is a dummy script for now

#### setuid tin nope, use sudo instead...
#### invoke as
# sudo -u tin /global/home/groups/scs/tin/remote_cycle_node.sh n0301.savio2


#### ssh master.brc
#### wwsh ipimi powerstatus n0xxx.savio.

#### location of script (don't need setuid)
# brc: /global/home/groups/scs/tin/remote_cycle_node.sh
# ~tin/PSG/script/hpc/

run_sanity_check()
{

        MAQUINA=$(hostname -s)

        # this regex is good enough, acc for greta nodes naming scheme
        if [[ x$MAQUINA =~ ln[0-9][0-9][0-9] ]]; then
                echo "hostname pattern passes sanity test, continuting..." # ie not causing an abort/exit
                #exit 0
        elif [[ x$MAQUINA =~ n[0-9][0-9][0-9][0-9] ]]; then
                echo "hostname pattern passes sanity test, continuting..." # ie not causing an abort/exit
        else
                echo "hostname pattern sanity test FAILED. NOT running !  Exiting."
                exit 007
        fi
        # normal return, allow caller to decide what to do next

}

############################################################
############################################################


## retest on n00? or b00?
run_remote_cycle_cmd()
{
	case $1 in 
		n0????.savio?)
			echo "this case never matches. "
			# potentially list only gpu nodes for case match
			;;
		*)
			node=$1
			echo $node
			if [[ x$node =~ n0[0-9][0-9][0-9].savio[0-4] ]]; then
				echo "attempt to power cycle $node"
				#ssh -o StrictHostKeyChecking=no master.brc whoami 
				#echo ssh -o StrictHostKeyChecking=no master.brc wwsh ipmi powerstatus $node
				
				ssh -o StrictHostKeyChecking=no master.brc "echo $node reboot by /global/home/groups/scs/tin/remote_cycle_node.sh  | /bin/mailx -s "[bofhbot] reboot notification" tin@berkeley.edu,hchristopher@lbl.gov"
				ssh -o StrictHostKeyChecking=no master.brc wwsh ipmi powerstatus $node
			else
				echo "node pattern is not of form n0???.savio?, exiting 444"
				exit 444
			fi
			;;
	esac
}

########################################
#### "main"
########################################

run_sanity_check
run_remote_cycle_cmd $1
