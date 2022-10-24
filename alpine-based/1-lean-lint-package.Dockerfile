# syntax = docker/dockerfile:1.4.3
# enable advanced Dockerfile features, like Build Kit and more modern syntax options
# also see: https://docs.docker.com/develop/develop-images/build_enhancements/

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

LABEL MAINTAINERS="Daniel Schulz"

ARG TARGETPLATFORM="linux/amd64"

# set my time zone to Greenwich/London, UK time as a best practice
ENV TZ='Europe/Berlin'


# prefer faster-executing, binary PIP packages pre-compiled for my (Linux) container
# rather take no developer dependenices, which are slower on runtime but changable
ARG PIP_PREFER_BINARY="${PIP_PREFER_BINARY:-1}"
ARG PIP_INSTALL_ARGUMENTS="--no-cache-dir --compile --prefer-binary"
# ARG PIP_INSTALL_ARGUMENTS=""
# what PIP packages to install -- divived by one space between PIP package names
ARG PIP_PACKAGES_TO_INSTALL_SPACE_SPEARATED

# add Git client
RUN \
    apk add --no-cache \
        # GCC, GLIBC, MUSL, etc.
        build-base libc-dev libstdc++ musl-dev \
        # Python & Py-based packages & OS tools
        bash git python3 py3-pip unzip && \
    # clear system-wide APT caches
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/cache/apk/*
    # configure system to use Python 3.10 by default
    #    rm -f /usr/bin/python /usr/bin/python3 && \
    #    ln -s "/usr/bin/python${PYTHON3_VERSION}" /usr/bin/python3 && \
    #    ln -s "/usr/bin/python${PYTHON3_VERSION}" /usr/bin/python && \

SHELL [ "/bin/bash", "-c" ]

# add Python Packages PreCommit & Docker Compose
RUN PIP_PREFER_BINARY="${PIP_PREFER_BINARY}" \
    pip install ${PIP_INSTALL_ARGUMENTS} ${PIP_PACKAGES_TO_INSTALL_SPACE_SPEARATED} && \
    # clear user's PIP caches
    rm -rf "${HOME}/.cache/pip"

# tell the container, to accept SIGTERM as a signal to gracefully stop the container
STOPSIGNAL SIGTERM

CMD [ "/bin/bash" ]
