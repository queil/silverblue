FROM quay.io/fedora/fedora-silverblue:39

RUN sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' 

COPY ./custom.sh /etc/
COPY ./init.sh /usr/bin/queil-init.sh
COPY ./init.service /lib/systemd/system/queil-init.service

RUN echo ". /etc/custom.sh" >> /etc/bashrc && \
    systemctl enable queil-init && \
    chmod +x usr/bin/queil-init.sh && \
    ostree container commit

# DOWNLOAD SLACK

RUN export SLACK_VER=$(curl -sSL https://slack.com/release-notes/linux | grep -Poh "Slack \d+\.\d+\.\d+" | cut -d ' ' -f 2 | head -n 1 | tr -d '\n') && \
    curl -sSL https://downloads.slack-edge.com/releases/linux/$SLACK_VER/prod/x64/slack-$SLACK_VER-0.1.el8.x86_64.rpm -o slack.rpm

RUN rpm-ostree install -y \
      dotnet-sdk-7.0 \
      hugo \
      code \
      cascadia-code-fonts \
      slack.rpm \
      keepassxc && \
      ln -s /usr/bin/ld.bfd /usr/bin/ld && \
    rm -r /var/* && rm slack.rpm && \
    ostree container commit

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

RUN code --install-extension Ionide.Ionide-fsharp --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR && \
    code --install-extension ms-vscode-remote.remote-containers --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR  && \
    code --install-extension rust-lang.rust-analyzer --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR && \
    code --install-extension streetsidesoftware.code-spell-checker --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR && \
    echo "export VSCODE_EXTENSIONS=${VSCODE_EXTENSIONS}" >> /etc/custom.sh && \
    ostree container commit

# STARSHIP

RUN curl -sSL https://starship.rs/install.sh -o ./install.sh && \
    chmod +x ./install.sh && ./install.sh --yes --bin-dir /usr/bin && rm ./install.sh && \
    ostree container commit

# ROOZ
ARG ROOZ_VER=0.17.0
RUN curl -sSL https://github.com/queil/rooz/releases/download/v${ROOZ_VER}/rooz -o ./rooz && chmod +x ./rooz && sudo mv ./rooz /usr/bin && \
    ostree container commit
