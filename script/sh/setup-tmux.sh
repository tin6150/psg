#!/bin/bash

# setup tmux 3 sessions, each with a standard set of windows (what I think of tabs)
# http://man7.org/linux/man-pages/man1/tmux.1.html

META_SESSION_LIST="m1 m2 m3" # add more meta session if desired
for MS in $META_SESSION_LIST; do

	# each meta session contain 3 smaller pane with sessions inside of them
	SESSION_LIST="s1 s2 s3" #used to name these as t7 t8 t9
	for S in $SESSION_LIST; do
		SESSION=${MS}_${S}

		tmux kill-session          -t $SESSION    # kill old config (used in dev)
		tmux new-session -d        -s $SESSION   # -d for detache mode, just want to set them up in background 
		tmux new-window -n lo      -t ${SESSION}:  -d  'echo "localhost";  date;      bash'
		tmux new-window -n brc     -t ${SESSION}:  -d  'echo "ssh -Y brc.berkeley.edu"; ssh -Y brc.berkeley.edu; bash'
		tmux new-window -n scs-brc -t ${SESSION}:  -d  'echo "ssh -Y scs-cm.lbl.gov; sudo ssh -Y -o ServerAliveInterval=55 -o ServerAliveCountMax=2 master.brc" ; /bin/bash'
		tmux new-window -n lrc-xfer -t ${SESSION}: -d  'echo "ssh -Y 128.3.7.151";        bash'  # 151=n0000.scs00; xfer has no squeue; lrc-viz can't login to node w/o password :/
		tmux new-window -n perce   -t ${SESSION}:  -d  'echo "ssh -Y lrc-viz"; sudo ssh -Y -o ServerAliveInterval=240 perceus-00.scs.lbl.gov" ; bash'
		tmux new-window -n scs     -t ${SESSION}:  -d  'echo "ssh -Y scs-cm";         bash'
		tmux new-window -n beag    -t ${SESSION}:  -d  'echo "ssh -Y beagle";  ssh -Y -o StrictHostKeyChecking=no beagle.lbl.gov;  bash'
		tmux new-window -n ansi    -t ${SESSION}:  -d  'echo "ssh -Y scg-ansible";    bash'
		tmux new-window -n rt      -t ${SESSION}:  -d  'echo "sudo su -";             bash'
		tmux new-window -n lo      -t ${SESSION}:  -d  'date; bash'
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

tmux set-option -g mouse off 



#tmux set-option status-style bg=magenta # immediately before get the color treatment


date
echo "---"
tmux display-panes
echo ""
tmux ls
