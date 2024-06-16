# OpenTofu

Container image based on `alpine` distribution with a variety of linux tools installed.

The image contains:

- opentofu
- bash
- jq
- kubectl
- openssl
- curl
- git
- more

## Installation

```bash
# Run a pod to test the installation
kubectl run -it --rm toolbox --image=ghcr.io/jsa4000/toolbox:1.0.0

# Download the script to install
# https://opentofu.org/docs/intro/install/alpine/
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh

# Run the installer in standalone mode so the version can be specified
bash ./install-opentofu.sh --skip-verify --install-method standalone --opentofu-version 1.7.2
# or using apk mode
# bash ./install-opentofu.sh --install-method apk

# Remove the script
rm install-opentofu.sh && \
```
