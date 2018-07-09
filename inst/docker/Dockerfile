FROM rocker/verse:3.5.0

# Install FiraCode font
RUN mkdir -p /usr/share/fonts/truetype/firacode \
  && wget -O /usr/share/fonts/truetype/firacode/FiraCode-Bold.ttf "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-Bold.ttf?raw=true" \
  && wget -O /usr/share/fonts/truetype/firacode/FiraCode-Light.ttf "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-Light.ttf?raw=true" \
  && wget -O /usr/share/fonts/truetype/firacode/FiraCode-Medium.ttf "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-Medium.ttf?raw=true" \
  && wget -O /usr/share/fonts/truetype/firacode/FiraCode-Regular.ttf "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-Regular.ttf?raw=true" \
  && wget -O /usr/share/fonts/truetype/firacode/FiraCode-Retina.ttf "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-Retina.ttf?raw=true"

# Avoid warning during package installation
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends apt-utils

# Install Prince
RUN wget -O prince_20180524-1_debian9.1_amd64.deb https://www.princexml.com/download/prince_20180524-1_debian9.1_amd64.deb \
  && dpkg -i prince_20180524-1_debian9.1_amd64.deb \
  && rm prince_20180524-1_debian9.1_amd64.deb

# Install wkhtmltopdf
RUN apt-get update \
  && apt-get install -y --no-install-recommends xz-utils \
  && wget -O wkhtmltox-0.12.3_linux-generic-amd64.tar.xz https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
  && tar vxf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
  && cp wkhtmltox/bin/wkhtmltopdf /usr/local/bin/ \
  && rm -rf wkhtmltox \
  && apt-get remove --purge -y xz-utils \
  && apt-get autoremove -y \
  && apt-get autoclean -y \
  && rm -rf /var/lib/apt/lists/*

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
    shared-mime-info

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
