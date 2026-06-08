# Create New Container

This guide explains how to **add** a new container image and how it is automatically **built** and **released**.

Considerations:

- Every modification must be done by creating a new **branch** and a **Pull Request** for validation.
- **Pull Requests** must follow the **title** convention "[`APP_NAME`] `DESCRIPTION`" so the Release Notes read consistently. (Attribution itself is by **changed path** via each config's `include-paths`, not by the title.) **Renovate** PRs follow this convention automatically: the `[`APP_NAME`]` prefix is derived from the folder of the updated file (`{{packageFileDir}}`), and dependency updates outside an app folder — e.g. GitHub Actions — are prefixed `[ci]`.
- The build and release workflows are app-agnostic and discover containers automatically. **You never edit a workflow to add a container.**

## Scaffold the container

Run the scaffold task from the repository root, passing the new app name:

```bash
task container:new -- myapp
```

This creates, from the templates in `.github/templates/container/`:

```bash
├── myapp
│   ├── Dockerfile
│   └── README.md
└── .github/release-drafter/myapp.yaml
```

The generated `.github/release-drafter/myapp.yaml` inherits from `.github/release-drafter/base.yaml`:

```yaml
_extends: containers:base.yaml
name-template: "myapp-v$RESOLVED_VERSION"
tag-template: "myapp-v$RESOLVED_VERSION"
tag-prefix: myapp-v
include-paths:
  - "myapp/"
```

> Use lowercase letters, digits and hyphens for the app name. The name maps 1:1 to the directory and to the image `ghcr.io/<owner>/myapp`.

Then:

1. Edit `myapp/Dockerfile` and `myapp/README.md`.
2. Add the image to the table in the root `README.md`.

No workflow changes are required: the `Release Drafter` workflow discovers the new config in `.github/release-drafter/*.yaml`, and the build workflows detect the new directory automatically.

## Pull Request

Create a Pull Request titled `[myapp] Add myapp container image` with a description.

> Release drafter automatically labels the PR depending on the changes (`documentation`, `enhancement`, `bug`, etc.).

After validation, merge into `main`. This creates/updates the **release draft** and builds the image with the `main` tag.

## Release

Once the container is on `main`, publish a versioned image in one of two ways:

- **Automatic** — publish the auto-generated `release-drafter` draft (normal releases).
- **Manual** — cut a specific version with the **Cut Release** workflow (patches / hotfixes).

See [Releases (automatic & manual)](releases.md) for the full flow, and the
[FAQ & troubleshooting](faq.md) if something goes wrong.
