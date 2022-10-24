# syntax = docker/dockerfile:1.4.3
# enable advanced Dockerfile features, like Build Kit and more modern syntax options
# also see: https://docs.docker.com/develop/develop-images/build_enhancements/

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

LABEL MAINTAINERS="Daniel Schulz"

ARG TARGETPLATFORM="linux/amd64"

# set my time zone to Greenwich/London, UK time as a best practice
ENV TZ='Europe/Berlin'

# configure build-side user to switch back to later when `root`-side installations and configurations are done
ARG APPS_PATH="/apps"
ARG APPS_SW_PATH="${APPS_PATH}/tools"

ARG APPS_AWS_PATH="${APPS_SW_PATH}/aws"
ARG APPS_AWS_BIN_PATH="${APPS_SW_PATH}/aws-bin"

# AWS CLI & K8S
# install AWS CLI & kubectl
ARG AWS_CLI_VERSION
ARG AWS_CLI_ARCHIVE="https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip"
ARG AWS_CLI_CHECKSUM

RUN echo "installing AWS CLI" && \
    cd /tmp && \
    curl --silent "${AWS_CLI_ARCHIVE}" -o "/tmp/awscliv2.zip" && \
    echo "${AWS_CLI_CHECKSUM}  /tmp/awscliv2.zip" | sha256sum -c -s && \
    # extract files really quietly (-qq) and overwrite wo/ asking before (-o)
    unzip -oqq /tmp/awscliv2.zip && \
    /tmp/aws/install --update -i ${APPS_AWS_PATH} -b ${APPS_AWS_BIN_PATH} && \
    rm -rf /tmp/awscliv2.zip /tmp/aws


# add AWS CLI to make it work right from anywhere for it being in the ENV variable PATH
ENV PATH="${APPS_AWS_BIN_PATH}:${PATH}"


# tell the container, to accept SIGTERM as a signal to gracefully stop the container
STOPSIGNAL SIGTERM
