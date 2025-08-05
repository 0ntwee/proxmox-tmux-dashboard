# Proxmox Tmux Dashboard

![Dashboard Screenshot](./screenshot.png)

A lightweight terminal dashboard for Proxmox clusters with tmux.

## Features

- Real-time system monitoring (htop)
- Storage capacity overview
- Container status tracking (LXC + Docker)
- SSH terminal access
- Auto-start configuration

## Quick Start

```bash
# Clone repository
git clone https://github.com/0ntwee/proxmox-tmux-dashboard.git
cd proxmox-tmux-dashboard

# Make script executable
chmod +x src/dashboard.sh

# Run dashboard
./src/dashboard.sh

Automatic Setup
# Run installation script
sudo ./install.sh

# Enable auto-start (for systemd)
sudo systemctl enable proxmox-dashboard

Configuration

Edit src/dashboard.sh to set your servers:
PROXMOX_SERVER="root@your_proxmox_ip"
DOCKER_SERVER="root@your_docker_host_ip"

Requirements

    tmux 3.0+

    SSH key authentication

    Proxmox VE 7+
