FROM quay.io/fedora/fedora-silverblue:39

RUN sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' 

RUN rpm-ostree install \
      code \
      cascadia-code-fonts && \
    rm -r /var/* && \
    ostree container commit
