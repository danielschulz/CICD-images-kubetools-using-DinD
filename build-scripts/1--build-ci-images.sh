#!/bin/bash

# ENABLE DOCKER BUILD OPTIONS
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export FS_ROOT="${PWD}"
export FS_COMPOSE_NAME_PROTECTED="ubuntu-based/kube-tools-docker-compose-w-names.yml"



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
if [ -f "${FS_ROOT}/${FS_COMPOSE_NAME_PROTECTED}" ]; then
  echo "Please make sure, no file named \"${FS_COMPOSE_NAME_PROTECTED}\" exists in this Git repo's root."
  echo "All files named 'kube-tools-docker-compose-w-names.yml' in this Git repo's root will be over-written."
  echo "Failing for this reason now (FastFail) w/ error code 132."
  rm -f "${FS_ROOT}/${FS_COMPOSE_NAME_PROTECTED}"
  # exit 132;
fi


# check, whether the pattern file IS present
if [ ! -f "${FS_ROOT}/ubuntu-based/docker-compose-pattern.yml" ]; then
  echo "Please make sure, a file named 'ubuntu-based/docker-compose-pattern.yml' exists in this Git repo's root."
  echo "Hint: All files named \"${FS_COMPOSE_NAME_PROTECTED}\" in this Git repo's root will be over-written."
  echo "Failing for this reason now (FastFail) w/ error code 133."
  exit 133;
fi


# create effective file to utilize, where all parameters have been replaced w/ specific values
cat "${FS_ROOT}/ubuntu-based/docker-compose-pattern.yml" | \
     sed \
        -e "s|\${REGISTRY_URL_REG_DOMAIN_W_USERNAME}|${REGISTRY_URL_REG_DOMAIN_W_USERNAME}|g" \
        -e "s|\${REGISTRY_REPO_NAME}|${REGISTRY_REPO_NAME}|g" - \
     > "${FS_ROOT}/${FS_COMPOSE_NAME_PROTECTED}"


echo " ---- (2/2) CI IMAGES ---- "

# BUILD CI IMAGES
time docker-compose \
    --env-file "${FS_ROOT}/ubuntu-based/packages-non-python-dependencies.env" \
    --file "${FS_ROOT}/${FS_COMPOSE_NAME_PROTECTED}" \
    build \
    dind-lint \
    dind-package \
    dind-package-publish


# abort, if there was an error
export RES=$?
if [[ ! 0 -eq "${RES}" ]]; then
  echo "Building all CI images fialed. Error code was ${RES}."
  exit "${RES}"
fi



# TRANSPARENCY ON BUILD
export RES=$?
exit "${RES}"
