dconf load / < /etc/settings.dconf
systemctl --user enable --now podman.socket
systemctl enable --now tailscaled
podman pull ghcr.io/queil/image:latest
cp /etc/vscode.json ~/.config/Code/User/settings.json
