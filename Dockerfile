# Download jammy image ubuntu 22:04
ARG TAG0=focal
ARG TAG1=jammy
FROM ubuntu:${TAG0}

# Label about the custom image
LABEL maintainer="ericmosesngigi@gmail.com"
LABEL version="0.1"
LABEL description="This is a custom Docker Image for wine"

# Disable Prompts During Packages Installation
ENV DEBAIN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update Ubuntu Software Repository
RUN sed -i -E 's/^# deb-src /deb-src /g' /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN apt update
RUN apt upgrade -y

# Update timezone to use
ENV TZ=Africa/Nairobi
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN apt install -y --no-install-recommends \
  apt-transport-https \
  build-essential \
  ca-certificates \
  cabextract \
  dbus-x11 \
  dpkg-dev \
  firefox \
  git \
  gnupg \
  gpg-agent \
  gosu \
  locales \
  p7zip \
  sudo \
  tzdata \
  unzip \
  wget \
  winbind \
  xvfb \
  zenity \
  x11-xserver-utils \
  xfce4 \
  xfce4-goodies \
  xorgxrdp \
  xrdp \
  xubuntu-icon-theme \
  openssh-server
  
RUN rm -rf /var/lib/apt/lists/*
RUN apt clean

# Setup locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# Install wine
RUN mkdir -pm755 /etc/apt/keyrings
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
RUN apt-get update -y
RUN apt install --install-recommends winehq-stable -y

# entrypoint to setup user
COPY entrypoint.sh /usr/share/entrypoint
ENTRYPOINT [ "/usr/share/entrypoint" ]
