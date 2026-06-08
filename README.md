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

| Container                                                                     | Channel | Image                      |
| ----------------------------------------------------------------------------- | ------- | -------------------------- |
| [toolbox](https://github.com/jsa4000/containers/pkgs/container/toolbox)       | stable  | ghcr.io/jsa4000/toolbox    |
| [opentofu](https://github.com/jsa4000/containers/pkgs/container/opentofu)     | stable  | ghcr.io/jsa4000/opentofu   |
| [excalidraw](https://github.com/jsa4000/containers/pkgs/container/excalidraw) | stable  | ghcr.io/jsa4000/excalidraw |
| [unoserver](https://github.com/jsa4000/containers/pkgs/container/unoserver)   | stable  | ghcr.io/jsa4000/unoserver  |

## Development

### Prerequisites

This repo relies on [Task](https://taskfile.dev) as its command runner and [pre-commit](https://pre-commit.com) for git hooks. The fastest way to get all required tooling is via [Homebrew](https://brew.sh):

```bash
task brew:init
```

This installs `direnv`, `gitleaks`, `ipcalc`, `markdownlint-cli`, `pre-commit`, `prettier`, `yamllint`, `gettext`, `mkdocs`, `go-task`, `jq` and `yq`.

> If you don't use Homebrew, install at least [`go-task`](https://taskfile.dev/installation/) and [`pre-commit`](https://pre-commit.com/#install) manually.

### Initialize the repository

After cloning, install the git hooks so checks run automatically on every commit:

```bash
task init
```

This runs `pre-commit install --install-hooks`, wiring up the `.git/hooks/pre-commit` hook from [.pre-commit-config.yaml](.pre-commit-config.yaml). On each commit it will lint YAML/Markdown, fix trailing whitespace and line endings, and tidy up CODEOWNERS, smart quotes and ligatures.

### Common tasks

Run `task` (or `task -l`) to list every available task. The most useful ones:

```bash
task precommit:run      # run all pre-commit hooks against every file
task precommit:update   # update pinned hook versions (pre-commit autoupdate)

task lint:all           # lint Markdown, YAML and general formatting
task format:all         # auto-format Markdown and YAML with Prettier

task container:new -- myapp   # scaffold a new container image
```

Tasks are defined in [Taskfile.yaml](Taskfile.yaml) and the included files under [.github/taskfiles/](.github/taskfiles/).

### Add a new container

Run `task container:new -- myapp` to scaffold a new container (directory, `Dockerfile`, `README.md` and its `release-drafter` config). The build and release workflows discover containers automatically, so no workflow edits are needed.

### Documentation

- [Create a new container](.github/workflows/docs/create-container.md) — scaffold and open a PR.
- [Releases (automatic & manual)](.github/workflows/docs/releases.md) — versioning, publishing drafts and cutting specific versions.
- [FAQ & troubleshooting](.github/workflows/docs/faq.md) — common issues and errors.

## Credits

A lot of inspiration and ideas are thanks to the hard work of [hotio.dev](https://hotio.dev/) and [linuxserver.io](https://www.linuxserver.io/) contributors.
