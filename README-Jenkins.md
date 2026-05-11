# Jenkins setup (Pipeline)

This repo includes a **`Jenkinsfile`** that builds and tests the project and then builds a Docker image.

## 1) Create a Jenkins Job
1. In Jenkins: **New Item** -> **Pipeline**
2. Source: **Pipeline script from SCM**
3. SCM: Git
4. Repository: your repo URL
5. Branch: `main` (or your branch)

Jenkins will automatically pick up `Jenkinsfile` from the repo root.

## 2) Required tools on the Jenkins agent
The agent running the job must have:
- Node.js (compatible with `package.json` engines; Node >=18 <21)
- npm
- Docker (for `docker build`)

## 3) Environment variables
This pipeline is designed to build the Docker image locally on the agent.

- `IMAGE_NAME` (optional, default: `vito-ginglies-luxury`)
- `REGISTRY_URL` (currently unused; provided as a placeholder if you want to extend the pipeline to push)

## 4) Docker registry push (optional)
If you want Jenkins to push the image, extend the pipeline:
- Add Docker registry login using Jenkins credentials
- Tag the image with your registry name
- Push the tagged image

(Recommended follow-up: I can update the pipeline once you tell me your registry and image naming.)

