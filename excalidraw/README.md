# Excalidraw

Excalidraw does not provide a container image based on arm architecture currently.

## Manual build

```bash
# Build docker image for multiple architectures
docker buildx build --platform linux/arm64,linux/arm64 -t excalidraw .
# Run single platform architecture: "ERROR: Multi-platform build is not supported for the docker driver."
docker buildx build --platform linux/arm64 -t excalidraw .

# Run container image
docker run -p 8080:80 excalidraw

```

## Local

```bash
# Prepare NVM and Node version
nvm use v18.12.1
npm install --global yarn

# Cone the current excalidraw version from Github
export EXCALIDRAW_VERSION=v0.17.3
mkdir src && cd src
git clone -b "${EXCALIDRAW_VERSION}" --single-branch --depth 1 https://github.com/excalidraw/excalidraw.git .

yarn --ignore-optional --network-timeout 600000
yarn build:app:docker

```
