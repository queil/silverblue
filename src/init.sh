dconf load / < /etc/settings.dconf
systemctl --user enable --now podman.socket
podman pull ghcr.io/queil/image:latest
cp /etc/vscode.json ~/.config/Code/User/settings.json
