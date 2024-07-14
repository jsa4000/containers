<div align="center">

# Containers

An opinionated collection of container images

</div>

<div align="center">

![GitHub Repo stars](https://img.shields.io/github/stars/jsa4000/containers?style=for-the-badge)
![GitHub forks](https://img.shields.io/github/forks/jsa4000/containers?style=for-the-badge)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/jsa4000/containers/release-scheduled.yaml?style=for-the-badge&label=Scheduled%20Release)

</div>

Welcome to my container images, if looking for a container start by [browsing the GitHub Packages page for this repo's packages](https://github.com/jsa4000?tab=packages&repo_name=containers).

## Mission statement

The goal of this project is to support [semantically versioned](https://semver.org/), [rootless](https://rootlesscontaine.rs/), and [multiple architecture](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/) containers for various applications.

It also adheres to a [KISS principle](https://en.wikipedia.org/wiki/KISS_principle), logging to stdout, [one process per container](https://testdriven.io/tips/59de3279-4a2d-4556-9cd0-b444249ed31e/), no [s6-overlay](https://github.com/just-containers/s6-overlay) and all images are built on top of [Alpine](https://hub.docker.com/_/alpine) or [Ubuntu](https://hub.docker.com/_/ubuntu).

## Tools

Below are some of the tools I find useful.

| Tool                                                                  | Purpose                                                                             |
| --------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| [Renovate](https://github.com/renovatebot/renovate)                   | Automatically finds new releases for the applications and issues corresponding PR's |
| [super-linter](https://github.com/super-linter/super-linter)          | A collection of linters and code analyzers, to help validate your source code.      |
| [release-drafter](https://github.com/release-drafter/release-drafter) | Drafts your next release notes as pull requests are merged into master.             |

## Available Images

Current available Images are the following.

| Container                                                                 | Channel | Image                    |
| ------------------------------------------------------------------------- | ------- | ------------------------ |
| [toolbox](https://github.com/jsa4000/containers/pkgs/container/toolbox)  | stable  | ghcr.io/jsa4000/toolbox  |
| [opentofu](https://github.com/jsa4000/containers/pkgs/container/opentofu) | stable  | ghcr.io/jsa4000/opentofu |
| [excalidraw](https://github.com/jsa4000/containers/pkgs/container/excalidraw) | stable  | ghcr.io/jsa4000/excalidraw |

## Credits

A lot of inspiration and ideas are thanks to the hard work of [hotio.dev](https://hotio.dev/) and [linuxserver.io](https://www.linuxserver.io/) contributors.
