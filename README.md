# CICD-images-kubetools-using-DinD

kubetools &mdash; builder images using Docker-in-Docker for use in CI/CD pipelines for Kubernetes (K8s)

## &forall; Ubuntu

### &mdash; same in all Ubuntu-based images

These versions apply to all these images:

- to lint code using <b>PreCommit</b><br/>
  `eu.gcr.io/jarvis-366407/cicd-images-kubetools-using-dind:ubuntu-lint-py-v3.8-docker-v20.10-git-v2.25-precommit-v2.20`<br/>
  w/ tag `ubuntu-lint-py-v3.8-docker-v20.10-git-v2.25-precommit-v2.20`
- to build Container images using <b>Docker-Compose</b><br/>
  `eu.gcr.io/jarvis-366407/cicd-images-kubetools-using-dind:ubuntu-package-py-v3.8-docker-v20.10-git-v2.25-dockercompose-v1.29`<br/>
  w/ tag `ubuntu-package-py-v3.8-docker-v20.10-git-v2.25-dockercompose-v1.29`
- to build Container images using <b>Docker-Compose</b> and push to <b>AWS' ECR</b><br/>
  `eu.gcr.io/jarvis-366407/cicd-images-kubetools-using-dind:ubuntu-package-publish-py-v3.8-docker-v20.10-git-v2.25-dockercompose-v1.29-awscli-v2.7`<br/>
  w/ tag `ubuntu-package-publish-py-v3.8-docker-v20.10-git-v2.25-dockercompose-v1.29-awscli-v2.7`


### to lint code using PreCommit

| package   | version   |
|-----------|-----------|
| Ubuntu    | 20.04     |
| Docker    | 20.10.18  |
| Python    | 3.8.10    |
| PIP       | 22.1.1    |
| PreCommit | 2.20.0    |

Sizes for this image are:

| in unit  | un-compressed | compressed |
|----------|---------------|------------|
| in Bytes | 724,197,192   | &empty;    |
| in MiB   | <b>690.6</b>  |<b>262.2</b>|

### to build Container images using Docker-Compose

| package        | version   |
| -------------- |-----------|
| Ubuntu         | 20.04     |
| Docker    | 20.10.18  |
| Docker-Compose | 1.29.2   |
| Python    | 3.8.10    |
| PIP            | 22.1.1    |

Sizes for this image are:

| in unit  | un-compressed | compressed |
|----------|---------------|-------------|
| in Bytes | 740,405,492   | &empty;     |
| in MiB   | <b>706.1</b>  |<b>261.2</b>|


### to build Container images using Docker-Compose and push to AWS' ECR

| package        | version   |
| -------------- |-----------|
| Ubuntu         | 20.04     |
| Docker    | 20.10.18  |
| Docker-Compose | 1.29.2   |
| Python    | 3.8.10    |
| PIP            | 22.1.1    |
| AWS CLI        | 2.7.24   |

Sizes for this image are:

| in unit  | un-compressed | compressed    |
|----------|---------------|---------------|
| in Bytes | 899,211,091   | &empty;       |
| in MiB   | <b>857.6</b>  | <b>304.2</b> |
