FROM registry.fedoraproject.org/fedora-silverblue:rawhide as base

RUN sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' 

WORKDIR /tmp/install

RUN curl -sSL https://zoom.us/client/5.14.7.2928/zoom_x86_64.rpm -o zoom.rpm
RUN rpm2cpio zoom.rpm | cpio -di && mv ./opt/* /usr/share/ && cp ./usr/share/* -R /usr/share/ && \
    ln -s /usr/share/zoom/ZoomLauncher /usr/bin/zoom
RUN ostree container commit

FROM base as install

RUN rpm-ostree install -y \
      gcc \
      code \
      micro \
      cascadia-fonts-all \
      fira-code-fonts \
      keepassxc && \
      ln -s /usr/bin/ld.bfd /usr/bin/ld && \
      ln -s /usr/share/fontconfig/conf.avail/10-sub-pixel-bgr.conf /etc/fonts/conf.d && \
    rm -r /var/* && \
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

ARG VSCODE_USER_DATA_DIR=/usr/share/vscode
ARG VSCODE_EXTENSIONS=${VSCODE_USER_DATA_DIR}/extensions
ARG DONT_PROMPT_WSL_INSTALL=1

RUN code --install-extension ms-vscode-remote.remote-containers --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR  && \
    code --install-extension rust-lang.rust-analyzer --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR && \
    code --install-extension vadimcn.vscode-lldb --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR && \
    code --install-extension streetsidesoftware.code-spell-checker --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR && \
    code --install-extension luxcium.pop-n-lock-theme-vscode --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR && \
    echo "export VSCODE_EXTENSIONS=${VSCODE_EXTENSIONS}" >> /etc/custom.sh && \
    ostree container commit

# vscode-lld extension's adapter
RUN export CODE_LLDB_VER="$(curl -ILs -o /dev/null -w %{url_effective} https://github.com/vadimcn/codelldb/releases/latest | grep -Eo 'v([0-9\.]+)' | cut -c2- )" && \
    export CODE_LLDB_PATH="${VSCODE_EXTENSIONS}/vadimcn.vscode-lldb-${CODE_LLDB_VER}/" && \
    curl -sSf -L https://github.com/vadimcn/codelldb/releases/latest/download/codelldb-x86_64-linux.vsix -o /tmp/codelldb-x86_64-linux.zip && \
    mkdir -p /tmp/codelldb && unzip /tmp/codelldb-x86_64-linux.zip 'extension/*' -d /tmp/codelldb && \
    cp /tmp/codelldb/extension/* -R "$CODE_LLDB_PATH" && \
    touch "${CODE_LLDB_PATH}/platform.ok"

# STARSHIP

RUN curl -sSL https://starship.rs/install.sh -o ./install.sh && \
    chmod +x ./install.sh && ./install.sh --yes --bin-dir /usr/bin && rm ./install.sh && \
    ostree container commit

# ROOZ
ARG ROOZ_VER=0.36.0
RUN curl -sSL https://github.com/queil/rooz/releases/download/v${ROOZ_VER}/rooz -o ./rooz && chmod +x ./rooz && sudo mv ./rooz /usr/bin && \
    ostree container commit

COPY ./settings.dconf /etc/settings.dconf
COPY ./vscode.json /etc/vscode.json
COPY ./init.sh /usr/bin/queil-init.sh
COPY ./init.service /lib/systemd/system/queil-init.service

RUN echo ". /etc/custom.sh" >> /etc/bashrc && \
    chmod +x /usr/bin/queil-init.sh && \
    ostree container commit
