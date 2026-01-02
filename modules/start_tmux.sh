#!/usr/bin/env bash

if [[ -z $1 ]]; then
	if [[ -z "$TMUX" ]]; then
		echo "not in tmux bro"
		exit 1
	else
		SESSION=$(tmux display-message -p '#S')
	fi
else
	SESSION=$1
fi

if ! tmux has-session -t "$SESSION" 2>/dev/null; then
	echo "Invalid session"
	exit 1
fi

tmux kill-pane -a -t $SESSION:0
tmux select-layout -t $SESSION:0 tiled 
tmux split-window -h -t $SESSION:0.0 "btop"
tmux split-window -v -t $SESSION:0.1 "neo-matrix -D --color=orange"
tmux select-pane -t $SESSION:0 -L
tmux send-key -t $SESSION:0 "clear; fastfetch" C-m
