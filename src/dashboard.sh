#!/bin/bash

MAIN_SERVER="root@192.168.1.100"
DOCKER_SERVER="root@192.168.1.59"
TERM="xterm-256color"

# Проверка на запуск внутри tmux
if [ -n "$TMUX" ]; then
    echo "Ошибка: Скрипт нужно запускать вне tmux!"
    exit 1
fi

# Удаляем старую сессию
tmux kill-session -t proxmox_dash 2>/dev/null

# Создаем новую сессию
tmux new-session -d -s proxmox_dash
tmux set -g pane-border-status top

# Разделение экрана
tmux split-window -h
tmux split-window -v -t 0
tmux split-window -v -t 2
#tmux split-window -h -t 3

# Панель 0: htop (верхний левый)
tmux send-keys -t 0 "ssh -t $MAIN_SERVER 'export TERM=$TERM; htop'" C-m

# Панель 1: Терминал (верхний правый)
tmux send-keys -t 1 "ssh -t $MAIN_SERVER" C-m

# Панель 2: Диски (нижний левый)
tmux send-keys -t 2 "watch -n 10 '
echo \"=== Proxmox Disks ===\"
ssh $MAIN_SERVER \"df -h --output=source,size,used,avail,pcent,target | grep -v tmpfs\"
echo; echo \"=== Docker Host Disks ===\"
ssh $DOCKER_SERVER \"df -h --output=source,size,used,avail,pcent,target | grep -v tmpfs\"'
" C-m

# Панель 3: Контейнеры (нижний правый верх)
tmux send-keys -t 3 "while true; do
  clear
  echo \"=== Proxmox LXC ===\"
  ssh $MAIN_SERVER 'pct list'
  echo; echo \"=== Docker Containers ===\"
  ssh $DOCKER_SERVER 'docker ps --format \"table {{.Names}}\t{{.Status}}\t{{.RunningFor}}\"'
  sleep 30
done" C-m

# Статус-бар (только время)
tmux set -g status-style bg=default,fg=white
tmux set -g status-right "#[fg=white]%H:%M:%S"
tmux set -g status-left ""

# Подключаемся к сессии
tmux attach -t proxmox_dash
