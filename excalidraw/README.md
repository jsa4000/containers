# Excalidraw

Excalidraw does not provide a container image based on arm architecture currently.

## Manual build

Use multi-plarform build using `buildx` command from docker tool.

```bash
# Create multi-platform builder
# https://unix.stackexchange.com/a/748634 ("ERROR: Multi-platform build is not supported for the docker drive)
docker buildx create --use --platform=linux/amd64,linux/arm64 --name multi-platform-builder

# Build docker image for multiple architectures (using previous multi-platform builder created)
docker buildx build --platform linux/amd64,linux/arm64 -t excalidraw .

# Build only one platform (use --no-cache for 'Segmentation fault' error)
docker buildx build --no-cache --platform linux/arm64 -t excalidraw .

# Run container image
docker run -p 8080:80 excalidraw
```

## Local

Build locally the project using `node` and `yarn`.

```bash
# Prepare NVM and Node version (v18.x)
nvm use v18.12.1
# Install yarn
npm install --global yarn

# Cone the current excalidraw version from Github
export EXCALIDRAW_VERSION=v0.17.3
mkdir src && cd src
git clone -b "${EXCALIDRAW_VERSION}" --single-branch --depth 1 https://github.com/excalidraw/excalidraw.git .

# Install dependencies and build static files.
yarn --network-timeout 600000
yarn build:app:docker

```
