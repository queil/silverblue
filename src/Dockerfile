FROM quay.io/fedora/fedora-silverblue:39

RUN rm /opt

RUN sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' 

# DOWNLOAD ZOOM
RUN curl -sSL https://zoom.us/client/5.14.7.2928/zoom_x86_64.rpm -o zoom.rpm

RUN rpm-ostree install -y \
      gcc \
      code \
      micro \
      cascadia-fonts-all \
      fira-code-fonts \
      zoom.rpm \
      keepassxc && \
      ln -s /usr/bin/ld.bfd /usr/bin/ld && \
      ln -s /usr/share/fontconfig/conf.avail/10-sub-pixel-bgr.conf /etc/fonts/conf.d && \
    rm -r /var/* && rm ./*.rpm && \
    ostree container commit

COPY ./custom.sh /etc/custom.sh
RUN ostree container commit

# RUST

# only set env vars during install so the binaries and caches are separated
ARG CARGO_HOME=/usr/bin/.cargo
ARG RUSTUP_HOME=/usr/bin/.rustup

RUN echo "export PATH=${PATH}:${CARGO_HOME}/bin" >> /etc/custom.sh && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path && \
    ostree container commit

# VSCODE

ARG VSCODE_USER_DATA_DIR=/usr/vscode
ARG VSCODE_EXTENSIONS=${VSCODE_USER_DATA_DIR}/extensions
ARG DONT_PROMPT_WSL_INSTALL=1

RUN code --install-extension ms-vscode-remote.remote-containers --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR  && \
    code --install-extension rust-lang.rust-analyzer --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR && \
    code --install-extension streetsidesoftware.code-spell-checker --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR && \
    code --install-extension luxcium.pop-n-lock-theme-vscode --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR && \
    echo "export VSCODE_EXTENSIONS=${VSCODE_EXTENSIONS}" >> /etc/custom.sh && \
    ostree container commit

# STARSHIP

RUN curl -sSL https://starship.rs/install.sh -o ./install.sh && \
    chmod +x ./install.sh && ./install.sh --yes --bin-dir /usr/bin && rm ./install.sh && \
    ostree container commit

# ROOZ
ARG ROOZ_VER=0.29.0
RUN curl -sSL https://github.com/queil/rooz/releases/download/v${ROOZ_VER}/rooz -o ./rooz && chmod +x ./rooz && sudo mv ./rooz /usr/bin && \
    ostree container commit

COPY ./settings.dconf /etc/settings.dconf
COPY ./vscode.json /etc/vscode.json
COPY ./init.sh /usr/bin/queil-init.sh
COPY ./init.service /lib/systemd/system/queil-init.service

RUN echo ". /etc/custom.sh" >> /etc/bashrc && \
    chmod +x usr/bin/queil-init.sh && \
    ostree container commit
