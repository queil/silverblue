dconf load / < /etc/custom/settings.dconf
systemctl --user enable --now podman.socket
systemctl enable --now tailscaled
podman pull ghcr.io/queil/image:latest
cp /etc/custom/.config/* -R  ~/.config/
