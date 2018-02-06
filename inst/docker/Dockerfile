FROM rocker/verse:3.4.1

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
  && wget -O pandoc-2.1.1-1-amd64.deb https://github.com/jgm/pandoc/releases/download/2.1.1/pandoc-2.1.1-1-amd64.deb \
  && dpkg -i pandoc-2.1.1-1-amd64.deb \
  && rm pandoc-2.1.1-1-amd64.deb

