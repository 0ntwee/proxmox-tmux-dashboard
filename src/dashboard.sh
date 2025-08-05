#!/bin/bash
# Proxmox Cluster Dashboard - tmux-based monitoring tool

# Configuration
PROXMOX_SERVER="root@192.168.1.100"
DOCKER_SERVER="root@192.168.1.59"
TERM="xterm-256color"
SESSION_NAME="proxmox_dash"

# Check if running inside tmux
if [ -n "$TMUX" ]; then
    echo "Error: Must run outside tmux!" >&2
    exit 1
fi

# Cleanup previous session
tmux kill-session -t $SESSION_NAME 2>/dev/null

# Create new tmux session
tmux new-session -d -s $SESSION_NAME
tmux set -g pane-border-status top

# Split layout (3 panes)
tmux split-window -h
tmux split-window -v -t 0

# Panel 0: System Monitor (htop)
tmux send-keys -t 0 "ssh -t $PROXMOX_SERVER 'export TERM=$TERM; htop'" C-m

# Panel 1: Admin Terminal
tmux send-keys -t 1 "ssh -t $PROXMOX_SERVER" C-m

# Panel 2: Storage Overview
tmux send-keys -t 2 "watch -n 10 '
echo \"=== Proxmox Storage ===\"
ssh $PROXMOX_SERVER \"df -h --output=source,size,used,avail,pcent,target | grep -v tmpfs\"
echo; echo \"=== Docker Host Storage ===\"
ssh $DOCKER_SERVER \"df -h --output=source,size,used,avail,pcent,target | grep -v tmpfs\"'
" C-m

# Panel 3: Container Status (added later)
tmux split-window -v -t 2
tmux send-keys -t 3 "while true; do
  clear
  echo \"=== Proxmox LXC Containers ===\"
  ssh $PROXMOX_SERVER 'pct list'
  echo; echo \"=== Docker Containers ===\"
  ssh $DOCKER_SERVER 'docker ps --format \"table {{.Names}}\t{{.Status}}\t{{.RunningFor}}\"'
  sleep 30
done" C-m

# Status bar configuration
tmux set -g status-style bg=default,fg=white
tmux set -g status-right "#[fg=white]%H:%M:%S"
tmux set -g status-left ""

# Attach to session
tmux attach -t $SESSION_NAME
