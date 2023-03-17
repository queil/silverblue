FROM quay.io/fedora/fedora-silverblue:39

RUN sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' 

RUN rpm-ostree install \
      rust \
      cargo \
      dotnet-sdk-7.0 \
      code \
      cascadia-code-fonts && \
    ln -s /usr/bin/ld.bfd /usr/bin/ld && \
    rm -r /var/* && \
    ostree container commit

ARG VSCODE_USER_DATA_DIR=/usr/vscode
ARG VSCODE_EXTENSIONS=${VSCODE_USER_DATA_DIR}/extensions

RUN code --install-extension Ionide.Ionide-fsharp --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR && \
    code --install-extension ms-vscode-remote.vscode-remote-extensionpack --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR  && \
    code --install-extension rust-lang.rust-analyzer --no-sandbox --user-data-dir $VSCODE_USER_DATA_DIR && \
    echo "export VSCODE_EXTENSIONS=${VSCODE_EXTENSIONS}" >> /etc/bashrc && \
    ostree container commit
