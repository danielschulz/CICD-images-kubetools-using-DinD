# syntax = docker/dockerfile:1.4.3
# enable advanced Dockerfile features, like Build Kit and more modern syntax options
# also see: https://docs.docker.com/develop/develop-images/build_enhancements/

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

LABEL MAINTAINERS="Daniel Schulz"
SHELL [ "/bin/bash", "-c" ]

ARG TARGETPLATFORM="linux/amd64"

# set my time zone to Greenwich/London, UK time as a best practice
ENV TZ='Europe/Berlin'

# tell APT we are not answering CLI questions, please do not wait for my input in the first place
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND="${DEBIAN_FRONTEND}"

ARG PYTHON3_VERSION

# prefer faster-executing, binary PIP packages pre-compiled for my (Linux) container
# rather take no developer dependenices, which are slower on runtime but changable
ARG PIP_PREFER_BINARY="${PIP_PREFER_BINARY:-1}"
ARG PIP_INSTALL_ARGUMENTS="--no-cache-dir --compile --prefer-binary"
# ARG PIP_INSTALL_ARGUMENTS=""
# what PIP packages to install -- divived by one space between PIP package names
ARG PIP_PACKAGES_TO_INSTALL_SPACE_SPEARATED

# add Git client
RUN \
    # assure, we have the latest and all SW repos to utilize for further APT installs
    apt update && \
    # only install additional packages for Python versions other than 3.8
    # as this is already shipped with Ubuntu 20.04
    if [[ "${PYTHON3_VERSION}" != '3.8' ]]; then \
        apt-get remove -y python3.8 && \
        apt-get install software-properties-common -y && \
        add-apt-repository ppa:deadsnakes/ppa && \
        # install Python when not v3.8 -- which ships by defauöt
        apt-get install -y "python${PYTHON3_VERSION}" ; fi && \
    # install Python-adjacent packages like PIP and Git in OS, which are version-independent
    # install gettext-base to have envsubst in CI runs
    apt-get install -y python3-distutils python3-apt python3-pip git gettext-base unzip && \
    # clear system-wide APT caches
    rm -rf /var/lib/apt/lists/*
    # configure system to use Python 3.10 by default
    #    rm -f /usr/bin/python /usr/bin/python3 && \
    #    ln -s "/usr/bin/python${PYTHON3_VERSION}" /usr/bin/python3 && \
    #    ln -s "/usr/bin/python${PYTHON3_VERSION}" /usr/bin/python && \

# add Python Packages PreCommit & Docker Compose
RUN PIP_PREFER_BINARY="${PIP_PREFER_BINARY}" \
    pip install ${PIP_INSTALL_ARGUMENTS} ${PIP_PACKAGES_TO_INSTALL_SPACE_SPEARATED} && \
    # clear user's PIP caches
    rm -rf "${HOME}/.cache/pip"

# tell the container, to accept SIGTERM as a signal to gracefully stop the container
STOPSIGNAL SIGTERM
