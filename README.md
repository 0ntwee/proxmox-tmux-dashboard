# Proxmox Tmux Dashboard

Terminal-based monitoring dashboard for Proxmox servers using tmux.

## Features

- Real-time system monitoring (htop)
- Disk usage overview
- Container status (LXC + Docker)
- Direct SSH access
- Auto-start capability

## Installation

1. Clone repository:
```bash
git clone https://github.com/yourusername/proxmox-tmux-dashboard.git
cd proxmox-tmux-dashboard
```

2. Configure servers in `dashboard.sh`:
```bash
PROXMOX_SERVER="root@your_proxmox_ip"
DOCKER_SERVER="root@your_docker_host_ip"
```

3. Set up SSH keys:
```bash
ssh-copy-id root@your_proxmox_ip
ssh-copy-id root@your_docker_host_ip
```

4. Make executable:
```bash
chmod +x dashboard.sh
```

## Usage

Run manually:
```bash
./dashboard.sh
```

Enable auto-start:
```bash
sudo cp dashboard.service /etc/systemd/system/
sudo systemctl enable --now dashboard.service
```

## Keys Controls

| Shortcut    | Action               |
|-------------|----------------------|
| `Ctrl+B` → `↑↓←→` | Navigate panels    |
| `Ctrl+B` → `d`    | Detach session     |
| `tmux attach`     | Restore session    |

## Requirements

- tmux 3.0+
- SSH access to servers
- Proxmox VE 7+/Docker
```
