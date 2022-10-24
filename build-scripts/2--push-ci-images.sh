#!/bin/bash

echo " ---- (1/2) AUTHENTICATING ---- "

# authenticating towards AWS ECR to push images into later
echo -e "Authenticating user ${AWS_ECR_USERNAME} to AWS ECR ${REGISTRY_URL_REG_DOMAIN_W_USERNAME} in AWS region ${AWS_REGION} now:"
aws ecr-public get-login-password --region "${AWS_REGION}" | docker login --username "${AWS_ECR_USERNAME}" --password-stdin public.ecr.aws



# define common beginning: repo and image name
CI_IMAGE_REPONAME_AND_IMAGENAME_STEM="${REGISTRY_URL_REG_DOMAIN_W_USERNAME}/${REGISTRY_REPO_NAME}"

# CI IMAGES
echo " ---- (2/2) CI IMAGES ---- "

# publish 2nd image
CURRENT_IMAGE_TAG="awscli-v2.7.24-k8scli-v1.25.2-helm-v3.10.0"
echo "Pushing 2nd image ${CURRENT_IMAGE_TAG} to user's repo ${DOCKERHUB_USER_NAME}"
echo "will be named: ${CI_IMAGE_REPONAME_AND_IMAGENAME_STEM}:${CURRENT_IMAGE_TAG}"
docker tag "${CI_IMAGE_REPONAME_AND_IMAGENAME_STEM}:${CURRENT_IMAGE_TAG}" "${CI_IMAGE_REPONAME_AND_IMAGENAME_STEM}:${CURRENT_IMAGE_TAG}"
time docker push "${CI_IMAGE_REPONAME_AND_IMAGENAME_STEM}:${CURRENT_IMAGE_TAG}"


# TRANSPARENCY ON BUILD
export RES=$?
exit "${RES}"
