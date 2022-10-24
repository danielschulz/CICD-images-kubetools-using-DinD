#!/bin/bash

# ENABLE DOCKER BUILD OPTIONS
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export FS_ROOT="${PWD}"
export FS_COMPOSE_NAME_PROTECTED_ALPINE="alpine-based/kube-tools-docker-compose-w-names.yml"
export FS_COMPOSE_NAME_PROTECTED_UBUNTU="ubuntu-based/kube-tools-docker-compose-w-names.yml"



echo " ---- (1/2) PRE-COMMIT HOOKS ---- "

# LINTING & CHECK FORMATTING
pre-commit run -a -c .pre-commit-config.yaml


# abort, if this is not pretty enough
export RES=$?
if [[ ! 0 -eq "${RES}" ]]; then
  echo "PreCommit hooks were not satisfied with your setup and it's configuration. Error code was ${RES}."
  echo "Please make sure, your code, configuration and guidelines are align with one another."
  exit "${RES}"
fi


# check source directory exists
if [ -d "${FS_ROOT}" ]; then
  cd "${FS_ROOT}"
else
  echo "The specified FS_ROOT folder ${FS_ROOT} w/ all sub-sequent sources does not exist."
  echo "Failing for this reason now (FastFail) w/ error code 131."
  exit 131;
fi


# check protected file w/ effective values IS NOT present
if [ -f "${FS_ROOT}/${FS_COMPOSE_NAME_PROTECTED_ALPINE}" ]; then
  echo "Please make sure, no file named \"${FS_COMPOSE_NAME_PROTECTED_ALPINE}\" exists in this Git repo's root."
  echo "All files named 'kube-tools-docker-compose-w-names.yml' in this Git repo's root will be over-written."
  echo "Failing for this reason now (FastFail) w/ error code 132."
  rm -f "${FS_ROOT}/${FS_COMPOSE_NAME_PROTECTED_ALPINE}"
  # exit 132;
fi

# check protected file w/ effective values IS NOT present
if [ -f "${FS_ROOT}/${FS_COMPOSE_NAME_PROTECTED_UBUNTU}" ]; then
  echo "Please make sure, no file named \"${FS_COMPOSE_NAME_PROTECTED_UBUNTU}\" exists in this Git repo's root."
  echo "All files named 'kube-tools-docker-compose-w-names.yml' in this Git repo's root will be over-written."
  echo "Failing for this reason now (FastFail) w/ error code 133."
  rm -f "${FS_ROOT}/${FS_COMPOSE_NAME_PROTECTED_UBUNTU}"
  # exit 133;
fi


# check, whether the pattern file IS present
if [ ! -f "${FS_ROOT}/alpine-based/docker-compose-pattern.yml" ]; then
  echo "Please make sure, a file named 'alpine-based/docker-compose-pattern.yml' exists in this Git repo's root."
  echo "Hint: All files named \"${FS_COMPOSE_NAME_PROTECTED_ALPINE}\" in this Git repo's root will be over-written."
  echo "Failing for this reason now (FastFail) w/ error code 134."
  exit 134;
fi

# check, whether the pattern file IS present
if [ ! -f "${FS_ROOT}/ubuntu-based/docker-compose-pattern.yml" ]; then
  echo "Please make sure, a file named 'ubuntu-based/docker-compose-pattern.yml' exists in this Git repo's root."
  echo "Hint: All files named \"${FS_COMPOSE_NAME_PROTECTED_UBUNTU}\" in this Git repo's root will be over-written."
  echo "Failing for this reason now (FastFail) w/ error code 134."
  exit 135;
fi


# create effective file to utilize, where all parameters have been replaced w/ specific values
cat "${FS_ROOT}/alpine-based/docker-compose-pattern.yml" | \
     sed \
        -e "s|\${REGISTRY_URL_REG_DOMAIN_W_USERNAME}|${REGISTRY_URL_REG_DOMAIN_W_USERNAME}|g" \
        -e "s|\${REGISTRY_REPO_NAME}|${REGISTRY_REPO_NAME}|g" - \
     > "${FS_ROOT}/${FS_COMPOSE_NAME_PROTECTED_ALPINE}"

# create effective file to utilize, where all parameters have been replaced w/ specific values
cat "${FS_ROOT}/ubuntu-based/docker-compose-pattern.yml" | \
     sed \
        -e "s|\${REGISTRY_URL_REG_DOMAIN_W_USERNAME}|${REGISTRY_URL_REG_DOMAIN_W_USERNAME}|g" \
        -e "s|\${REGISTRY_REPO_NAME}|${REGISTRY_REPO_NAME}|g" - \
     > "${FS_ROOT}/${FS_COMPOSE_NAME_PROTECTED_UBUNTU}"


echo " ---- (2/3) Alpine CI IMAGES ---- "

# BUILD CI IMAGES
time docker-compose \
    --env-file "${FS_ROOT}/alpine-based/packages-non-python-dependencies.env" \
    --file "${FS_ROOT}/${FS_COMPOSE_NAME_PROTECTED_ALPINE}" \
    build \
    dind-lint \
    dind-package \
    dind-package-publish


# abort, if there was an error
export RES=$?
if [[ ! 0 -eq "${RES}" ]]; then
  echo "Building all CI images failed. Error code was ${RES}."
  exit "${RES}"
fi


echo " ---- (3/3) Ubuntu CI IMAGES ---- "

# BUILD CI IMAGES
time docker-compose \
    --env-file "${FS_ROOT}/ubuntu-based/packages-non-python-dependencies.env" \
    --file "${FS_ROOT}/${FS_COMPOSE_NAME_PROTECTED_UBUNTU}" \
    build \
    dind-lint-py38 \
    dind-lint-py310 \
    dind-package-py38 \
    dind-package-py310 \
    dind-package-publish-py38 \
    dind-package-publish-py310


# abort, if there was an error
export RES=$?
if [[ ! 0 -eq "${RES}" ]]; then
  echo "Building all CI images failed. Error code was ${RES}."
  exit "${RES}"
fi



# TRANSPARENCY ON BUILD
export RES=$?
exit "${RES}"
