FROM axonasif/workspace-vnc:latest
SHELL ["/bin/bash", "-c"]

ENV FLUTTER_VERSION=2.10.2-stable

# For Qt WebEngine on docker
ENV QTWEBENGINE_DISABLE_SANDBOX 1

# Install Open JDK
USER root
RUN install-packages openjdk-8-jdk -y \
    && update-java-alternatives --set java-1.8.0-openjdk-amd64

# Install ungoogled_chromium
RUN curl -sSL https://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Focal/Release.key | apt-key add - \
  && echo 'deb http://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Focal/ /' > /etc/apt/sources.list.d/ungoogled_chromium.list \
  && install-packages ungoogled-chromium

# misc deps
RUN install-packages \
  libasound2-dev \
  libgtk-3-dev \
  libnss3-dev \
  fonts-noto \
  fonts-noto-cjk

# Insall flutter
USER gitpod
RUN wget -q "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz" -O - \
    | tar xpJ -C "$HOME" && printf "export PATH=$PATH:%s\n" "$HOME/flutter/bin" > "$HOME/.bashrc"

RUN flutter/bin/flutter precache
