#!/bin/bash

# setup tmux 3 sessions, each with a standard set of windows (what I think of tabs)
# http://man7.org/linux/man-pages/man1/tmux.1.html

SESSION_LIST="s1 s2 s3 s4 s5 s6" #used to name these as t7 t8 t9

for SESSION in $SESSION_LIST; do
	tmux kill-session -t $SESSION    # kill old config (used in dev)
	tmux new-session -d    -s $SESSION   # -d for detache mode, just want to set them up in background 
	tmux new-window -n lo      -t ${SESSION}:  -d  'echo "localhost";  date;      bash'
	tmux new-window -n brc     -t ${SESSION}:  -d  'echo "ssh -Y brc.berkeley.edu"; ssh -Y brc.berkeley.edu; bash'
	tmux new-window -n scs-brc -t ${SESSION}:  -d  'echo "ssh -Y scs-cm.lbl.gov; sudo ssh -Y -o ServerAliveInterval=55 -o ServerAliveCountMax=2 master.brc" ; /bin/bash'
	tmux new-window -n lrc-viz -t ${SESSION}:  -d  'echo "ssh -Y lrc-viz";        bash' 
	tmux new-window -n perce   -t ${SESSION}:  -d  'echo "ssh -Y lrc-viz"; sudo ssh -Y -o ServerAliveInterval=240 perceus-00.scs.lbl.gov" ; bash'
	tmux new-window -n scs     -t ${SESSION}:  -d  'echo "ssh -Y scs-cm";         bash'
	tmux new-window -n beag    -t ${SESSION}:  -d  'echo "ssh -Y beagle";  ssh -Y -o StrictHostKeyChecking=no beagle.lbl.gov;  bash'
	tmux new-window -n ansi    -t ${SESSION}:  -d  'echo "ssh -Y scg-ansible";    bash'
	tmux new-window -n rt      -t ${SESSION}:  -d  'echo "sudo su -";             bash'
	tmux new-window -n lo      -t ${SESSION}:  -d  'date; bash'
	tmux list-windows
done

tmux set-option -g mouse off 

tmux kill-session -t m1  # kill the config before recreating them.  safe as just place holders
tmux new-session  -d -A -s "m1"  # meta 1
tmux set-option status-style bg=blue  # immediately before get the color treatment
tmux split-window -v -d -t "m1"  'unset TMUX; tmux attach -dt s1; date'
tmux split-window -v -d -t "m1"  'unset TMUX; tmux attach -dt s2'
tmux split-window -v -d -t "m1"  'unset TMUX; tmux attach -dt s3'
tmux select-layout -t m1 even-vertical  # ^b atl-2


tmux kill-session -t m2  # kill the config before recreating them
tmux new-session  -d -A -s "m2"  # meta 2
tmux set-option status-style bg=magenta # immediately before get the color treatment
tmux split-window -v -d -t "m2" 'unset TMUX; tmux attach -dt s4'
tmux split-window -v -d -t "m2" 'unset TMUX; tmux attach -dt s5' 
tmux split-window -v -d -t "m2" 'unset TMUX; tmux attach -dt s6; date'
tmux select-layout -t m1 even-vertical # ^b atl-2
# still have an extra pane left over that i don't like... but not sure how to rid it 
# good enough for now


date
echo "---"
tmux display-panes
echo ""
tmux ls
