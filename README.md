# CICD-images-kubetools-using-DinD

kubetools &mdash; builder images using Docker-in-Docker for use in CI/CD pipelines for Kubernetes (K8s)

## &forall; &mdash; same in all images

These versions apply to all these images:

- dind-lint<br/>
  `eu.gcr.io/jarvis-366407/cicd-images-kubetools-using-dind:dind-lint-py-v3.10-dind-v20.10-git-v2.25-precommit-v2.20`
- dind-package<br/>
  `eu.gcr.io/jarvis-366407/cicd-images-kubetools-using-dind:dind-package-py-v3.10-dind-v20.10-git-v2.25-dockercompose-v1.29`
- dind-package-publish<br/>
  `eu.gcr.io/jarvis-366407/cicd-images-kubetools-using-dind:dind-package-py-v3.10-dind-v20.10-git-v2.25-dockercompose-v1.29-awscli-v2.7`

| package        | version |
| -------------- | ------- |
| Ubuntu         | 20.04   |
| Python         | 3.10    |
| Docker         | 20.10   |
| PIP            | version |
| PreCommit      | version |
| Docker-Compose | version |
| AWS CLI        | version |
