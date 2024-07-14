# Create New Container

This guide will explain the process to **add** a new container image and automatically **build** and **release** it.

Following some considerations:

* Every modification must be done by creating a new **branch** and creating a **Pull Request** for the validation.
* **Pull Requests** must follow the **title** convention "[`APP_NAME`] `DESCRIPTION`". This way `release-drafter` can detect the changed made to the folder and added into the **Release Notes**.

## Container Image

Create a new `directory` into the root folder with a `README.md` and `Dockerfile` file at the very least.

For example, the new directory to be created is `myapp` in this case.

```bash
├── myapp
│   ├── Dockerfile
│   └── README.md
├── opentofu
│   ├── Dockerfile
│   ├── README.md
│   └── entrypoint.sh
└── toolbox
    ├── Dockerfile
    ├── README.md
    └── entrypoint.sh
```

## Release Drafter

Since this repository is a `mono-repo` with multiple apps, the way these are configured to be processed by `release-drafter` is the following.

### Create configuration file

This file is the configuration to be used for `release-drafter` when generating the release draft. This inherits from `.github/release-drafter/base.yaml`.

Create a new file into `.github/release-drafter/myapp.yaml`.

> Take another file already create as a template.

```bash
_extends: containers:.github/release-drafter/base.yaml
name-template: "myapp-v$RESOLVED_VERSION"
tag-template: "myapp-v$RESOLVED_VERSION"
tag-prefix: myapp-v
include-paths:
  - "myapp/"
```

### Added Workflow Step

Add new step into `.github/workflows/release-drafter.yaml` so `release-drafter` will be triggered for this container image.

```bash
jobs:
  # ... #
  myapp:
    name: "[myapp] Draft release"
    runs-on: ubuntu-latest
    steps:
      - uses: release-drafter/release-drafter@v6
        with:
          config-name: release-drafter/myapp.yaml
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Pull Request

Create a Pull Request with the title `[myapp] Add myapp container image` and add a description.

> Release drafter automatically will label the PR depending on the changes being made, `documentation`, `enhancements`, `bug`, etc.

After the validation you can merge into the main branch so the **release draft** is created.
Also the container image is going to be build using the `main` tag.

## Release

Go to Releases and check for the new created release draft.

In here you can **edit** the tag being created since it's going to be automatically generated and also the Title of the release to match the new tag. `0.1.0` -> `0.17.3`.

Finally, **publish** the release. After this, a new action will be triggered that build and publish the new container image with the specified tag.
