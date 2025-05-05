function update
    sudo xbps-install --sync --update --yes
    flatpak update --assumeyes
end
