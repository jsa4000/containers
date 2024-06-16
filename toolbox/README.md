# ToolBox

Container image based on `alpine` distribution with a variety of linux tools installed.

The image contains:

- bash
- jq
- kubectl
- openssl
- curl
- git
- more

## Run

### Kubernetes

```bash
# Run the image in kubernetes using following command
kubectl run -it --rm toolbox --image=ghcr.io/jsa4000/toolbox:1.0.0
```
