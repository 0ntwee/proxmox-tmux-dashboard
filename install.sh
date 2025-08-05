#!/bin/bash
# Proxmox Tmux Dashboard Installer
# Version: 1.0
# License: MIT

# Configuration
INSTALL_DIR="/opt/proxmox-dashboard"
BIN_PATH="/usr/local/bin/proxmox-dashboard"
SERVICE_FILE="/etc/systemd/system/proxmox-dashboard.service"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${RED}Error: This script must be run as root${NC}" >&2
  exit 1
fi

# Create installation directory
echo -e "${GREEN}[1/5] Creating installation directory...${NC}"
mkdir -p "$INSTALL_DIR"/{src,configs}
cp -r src/* "$INSTALL_DIR/src/"
cp -r configs/* "$INSTALL_DIR/configs/"

# Install dependencies
echo -e "${GREEN}[2/5] Installing dependencies...${NC}"
if command -v apt &> /dev/null; then
  apt update && apt install -y tmux sshpass
elif command -v pacman &> /dev/null; then
  pacman -Sy --noconfirm tmux sshpass
elif command -v dnf &> /dev/null; then
  dnf install -y tmux sshpass
else
  echo -e "${RED}Warning: Could not detect package manager. Please install tmux manually.${NC}"
fi

# Create symlink for easy access
echo -e "${GREEN}[3/5] Creating symlink...${NC}"
ln -sf "$INSTALL_DIR/src/dashboard.sh" "$BIN_PATH"
chmod +x "$BIN_PATH"

# Configure systemd service
echo -e "${GREEN}[4/5] Setting up systemd service...${NC}"
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Proxmox Tmux Dashboard
After=network.target

[Service]
User=$SUDO_USER
WorkingDirectory=$INSTALL_DIR
ExecStart=$BIN_PATH
Restart=always
Environment="TERM=xterm-256color"

[Install]
WantedBy=multi-user.target
EOF

# Enable autostart
echo -e "${GREEN}[5/5] Enabling services...${NC}"
systemctl daemon-reload
systemctl enable proxmox-dashboard

# SSH key setup reminder
echo -e "\n${GREEN}Installation complete!${NC}"
echo -e "Next steps:"
echo "1. Set up SSH keys to your servers:"
echo "   ssh-keygen -t ed25519"
echo "   ssh-copy-id root@your_proxmox_ip"
echo "2. Configure servers in: $INSTALL_DIR/src/dashboard.sh"
echo "3. Start the dashboard:"
echo "   systemctl start proxmox-dashboard"
echo "   or run manually: proxmox-dashboard"
