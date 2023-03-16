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

ARG USER=queil
RUN useradd -m -u 1000 $USER
USER queil

RUN code --install-extension Ionide.Ionide-fsharp && \
    code --install-extension ms-vscode-remote.vscode-remote-extensionpack  && \
    code --install-extension rust-lang.rust-analyzer && \
    ostree container commit
