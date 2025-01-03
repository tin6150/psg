#!/bin/bash

# setup tmux 3 sessions, each with a standard set of windows (what I think of tabs)
# http://man7.org/linux/man-pages/man1/tmux.1.html

# **** Best NOT to run this script inside a tmux session ****

#++ need to enable one of the META_SESSION_LIST before running...
#   commented out cuz don't want to accidentally rerun and overwrite sessions
#//META_SESSION_LIST="m1 m2 m3 m4 m5 m6 m7 m8" # add more meta session if desired
META_SESSION_LIST="m1 m2 m3 m4" # add more meta session if desired
#++META_SESSION_LIST="m5 m6 m7 m8" # add more meta session if desired
#--META_SESSION_LIST="m4" # add more meta session if desired
for MS in $META_SESSION_LIST; do

	# each meta session contain 3 smaller pane with sessions inside of them
	SESSION_LIST="s1 s2 s3" #used to name these as t7 t8 t9
	for S in $SESSION_LIST; do
		SESSION=${MS}_${S}

		tmux kill-session          -t $SESSION    # kill old config (used in dev)
		tmux new-session -d        -s $SESSION   # -d for detache mode, just want to set them up in background 
		tmux new-window -n loRt    -t ${SESSION}:  -d  'echo "localhost"     ; date ; bash'		#s1
		#                                                    V                                                          echo ends here --V      V-- actual ssh
		tmux new-window -n brc     -t ${SESSION}:  -d  'echo "ssh -Y -o ServerAliveInterval=300 -o ServerAliveCountMax=2 brc.berkeley.edu #brc"    ; ssh -Y -o ServerAliveInterval=300 -o ServerAliveCountMax=2 brc.berkeley.edu; bash'  	#s2  echo "" ; ssh
		#                                                    V                                                                                                                                     echo ends here --V     V-- cmd just get shell.
		tmux new-window -n scs-brc -t ${SESSION}:  -d  'echo "ssh -Y -o ServerAliveInterval=300 -o ServerAliveCountMax=2 scs-cm.lbl.gov;   sudo ssh -Y -o ServerAliveInterval=55 -o ServerAliveCountMax=2 master.brc #scs"   ; /bin/bash'	#s3  echo only
		tmux new-window -n lrc1_128.3.7.151 -t ${SESSION}: -d  'echo "ssh -Y -o ServerAliveInterval=300 -o ServerAliveCountMax=2 -o ServerAliveInterval=300 -o ServerAliveCountMax=2 128.3.7.151"    ; bash'  # 151=n0000.scs00; xfer has no squeue; lrc-viz can't login to node w/o password :/
		##tmux new-window -n perce   -t ${SESSION}:  -d  'echo "ssh -Y -o ServerAliveInterval=300 -o ServerAliveCountMax=2 lrc-viz"; sudo ssh -Y -o ServerAliveInterval=240 perceus-00.scs.lbl.gov"    ; bash'	# doesn't seems to run, commented out now
		tmux new-window -n scs     -t ${SESSION}:  -d  'echo "ssh -Y -o ServerAliveInterval=300 -o ServerAliveCountMax=2 scs-cm #scs s5"     ; bash'	#s5 echo only
		#                                                    V                                                                         .  echo ends here --V     V-- cmd just get shell.
		tmux new-window -n beag    -t ${SESSION}:  -d  'echo "ssh -Y -o ServerAliveInterval=300 -o ServerAliveCountMax=2 -o StrictHostKeyChecking=no beagle";    bash' 	#s6 echo only
		tmux new-window -n asbl    -t ${SESSION}:  -d  'echo "ssh -Y -o ServerAliveInterval=300 -o ServerAliveCountMax=2 -o scg-ansible          ";    bash' #s7  echo only
		tmux new-window -n asblGtr -t ${SESSION}:  -d  'echo "ssh -Y -o ServerAliveInterval=300 -o ServerAliveCountMax=2 -o scg-ansible  # asbl #2";    bash' #s8
		tmux new-window -n loRt    -t ${SESSION}:  -d  'date; bash'								#s9  # run date and shell
		#tmux new-window -n rt      -t ${SESSION}:  -d  'echo "sudo su -";             bash'	# no more
		tmux list-windows
	done

	# meta containers, attaching the above created sessions, 3 session per meta container
	tmux kill-session -t ${MS}  # kill the config before recreating them.  safe as just place holders
	tmux new-session  -d -A -s "${MS}"  # meta m1, m2, m3
	tmux set-option status-style bg=blue  # immediately before get the color treatment
	#tmux set-option status-style bg=yellow  # immediately before get the color treatment
	# another good color is magenta.  set a variable to fit each meta session if want to get colorful
	# should also be set them in run time by creating a temp pane on each meta session and running the command...
	tmux split-window -v -d -t "${MS}"  "unset TMUX; tmux attach -dt ${MS}_s1; date"
	tmux split-window -v -d -t "${MS}"  "unset TMUX; tmux attach -dt ${MS}_s2"
	tmux split-window -v -d -t "${MS}"  "unset TMUX; tmux attach -dt ${MS}_s3"
	tmux kill-pane     -t ${MS}
	tmux select-layout -t ${MS} even-vertical # ^b atl-2
done


# manual fix (sometime close sub tmux window, or 2024.0717 didn't seems fully setup)
# tmux split-window -v -d -t "${MS}"  "unset TMUX; tmux attach -dt ${MS}_s2"
# tmux split-window -v -d -t "m2"  "unset TMUX; tmux attach -dt $m2_s2"
# oh, the new tmux in Mint 21.3 seems to behave differently than the old one on Zorin
# have been forking tmux in many hosts lately.
# have bofh24 run screen, use ^a " to list screens, and simple tmux nest inside that (after ssh as needed)
# the old school m1..m8 windows.... m1 still ok.  the other might run them inside screen eg m2_s1 inside screen

tmux set-option -g mouse off 
## ^b :set -g mouse on             # mouse mode, allow resize pane w/ tmux 2.1+
## ^b :set    allow-rename off     # prevent automatic renaming of pane/tab eg when want to manually name via ^b ,


#tmux set-option status-style bg=magenta # immediately before get the color treatment


date
echo "---"
tmux display-panes
echo ""
tmux ls


# 2024.0505 trying tmux on demand on machines as needed
# might be easier to pick up where left off, the nested pane thing take too much navigation
# try fewer windows, leave at least one wide pane for copy-n-paste.  3 panes as T might be ideal.
# ^b q 0 to jump to specific pane #0
# give them name like these:
# tmux new-session -s tmuxHW
# tmux new-session -s tmuxETA


#### ~~~~~~~~~~~~~~~~~~~~~


# new workflow, more host centric tmux (like what most peep do)
# but some could be hosted inside screen on bofh24, so resume them easier
#  screen -S asbl_hw   # ssh  asbl +  brc,  tmux for asbl and hw there
# hmm... don't know if nesting screen and tmux will have that paste with merged line problem...

# desirable tmux session, to reduce constantly looking for new "tab" 
# hw  # on brc, bofh24, cueball3_wombat17x, 
# cf  # CF_BK edits, another tab for psg?
# 


# plan in 2024.0807.   
# have many screen session, each single screen only, ssh to remote host eg asbl, then tmux inside.
# so screen just to avoid typing password.
# to switch, just detach and attach to new screen.
#   maybe only use screen for things that I must hop 2x, like asbl,  but less for like brc,lrc1


# renaming screen -ls result:   ^a :sessioname hw
# screen: ^A A  # this rename specific tab
