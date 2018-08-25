FROM rocker/verse:3.5.0

LABEL org.label-schema.license="(GPL-3.0 AND DocumentRef-https://www.princexml.com/license/)" \
      org.label-schema.vcs-url="https://github.com/RLesur/weasydoc/blob/master/inst/docker/Dockerfile" \
      org.label-schema.vendor="weasydoc" \
      maintainer="Romain Lesur <romain.lesur@gmail.com>" \
      org.opencontainers.image.licenses="(GPL-3.0 AND DocumentRef-https://www.princexml.com/license/)" \
      org.opencontainers.image.url="https://github.com/RLesur/weasydoc" \
      org.opencontainers.image.source="https://github.com/RLesur/weasydoc/blob/master/inst/docker/Dockerfile" \
      org.opencontainers.image.vendor="weasydoc" \
      org.opencontainers.image.authors="Romain Lesur <romain.lesur@gmail.com>"

# Install FiraCode font
RUN mkdir -p /usr/share/fonts/truetype/firacode \
  && wget -O /usr/share/fonts/truetype/firacode/FiraCode-Bold.ttf "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-Bold.ttf?raw=true" \
  && wget -O /usr/share/fonts/truetype/firacode/FiraCode-Light.ttf "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-Light.ttf?raw=true" \
  && wget -O /usr/share/fonts/truetype/firacode/FiraCode-Medium.ttf "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-Medium.ttf?raw=true" \
  && wget -O /usr/share/fonts/truetype/firacode/FiraCode-Regular.ttf "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-Regular.ttf?raw=true" \
  && wget -O /usr/share/fonts/truetype/firacode/FiraCode-Retina.ttf "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-Retina.ttf?raw=true"

# Install MS fonts
RUN apt-get update \
  && apt-get install -y --no-install-recommends cabextract xfonts-utils fonts-liberation2 \
  && wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.7_all.deb \
  && apt install -y ./ttf-mscorefonts-installer_3.7_all.deb \
  && rm ttf-mscorefonts-installer_3.7_all.deb

# Avoid warning during package installation
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends apt-utils

# Install weasyprint dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    libcairo2 \
    libffi-dev \
    libgdk-pixbuf2.0-0 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    python3-cffi \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    shared-mime-info \
  && apt-get autoremove -y \
  && apt-get autoclean -y \
  && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND teletype

# Install weasyprint
RUN pip3 install WeasyPrint

# Remove pandoc symlinks and install pandoc 2
RUN rm /usr/local/bin/pandoc \
  && rm /usr/local/bin/pandoc-citeproc \
  && wget -O pandoc-2.2.1-1-amd64.deb https://github.com/jgm/pandoc/releases/download/2.2.1/pandoc-2.2.1-1-amd64.deb \
  && dpkg -i pandoc-2.2.1-1-amd64.deb \
  && rm pandoc-2.2.1-1-amd64.deb

# Install weasydoc
RUN Rscript -e "devtools::install_github('RLesur/weasydoc')"

# Install Prince
RUN wget -O prince_20180524-1_debian9.1_amd64.deb https://www.princexml.com/download/prince_20180524-1_debian9.1_amd64.deb \
  && dpkg -i prince_20180524-1_debian9.1_amd64.deb \
  && rm prince_20180524-1_debian9.1_amd64.deb
