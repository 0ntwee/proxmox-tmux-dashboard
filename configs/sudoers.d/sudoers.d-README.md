# Sudoers Configuration

This directory should contain custom sudoers files. For security reasons,
we don't include actual configurations in the repository.

## Recommended Setup

1. Create a new file:
   ```bash
   sudo visudo -f /etc/sudoers.d/proxmox-dashboard
   ```

2. Add minimal required privileges:

   ```bash
   # Allow passwordless tmux and systemctl for the dashboard user
   USERNAME ALL=(ALL) NOPASSWD: /usr/bin/tmux,/usr/bin/systemctl
   ```

3. Set strict permissions:

   ```bash
   sudo chmod 440 /etc/sudoers.d/proxmox-dashboard
   ```

---
