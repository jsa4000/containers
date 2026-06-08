# Releases

This repository is a `mono-repo`: every container is **versioned and released independently**
using git tags of the form `<app>-v<semver>` (e.g. `toolbox-v1.0.0`, `opentofu-v1.8.6`).

There are two ways to publish a versioned image:

- [Automatic release](#automatic-release) — let `release-drafter` accumulate the changelog and
  compute the next version, then publish the draft. Use this for normal releases.
- [Manual release](#manual-release) — cut a specific version on demand with the **Cut Release**
  workflow. Use this for patches, fixes and hotfixes.

Both paths end the same way: a `<app>-v<semver>` tag is pushed, which triggers
[`build-push-image-release.yaml`](../build-push-image-release.yaml) to build the multi-arch
image and push it to `ghcr.io/<owner>/<app>` with the derived semver tags
(`<major>.<minor>.<patch>`, `<major>.<minor>`, `<major>`).

## How versioning works

- Versions are **git-tag driven** — there is no `VERSION` file to maintain.
- Each container has its own draft release and its own tag prefix, configured in
  `.github/release-drafter/<app>.yaml` (`tag-prefix: <app>-v`).
- The next version is computed by `release-drafter` from the labels on the merged PRs since the
  last release, using the `version-resolver` in
  [`.github/release-drafter/base.yaml`](../../release-drafter/base.yaml):

  | Label                | Bump              |
  | -------------------- | ----------------- |
  | `major` / `breaking` | `MAJOR`           |
  | `minor`              | `MINOR`           |
  | `patch`              | `PATCH`           |
  | _none of the above_  | `PATCH` (default) |

- PRs are auto-labeled by the `autolabeler` rules (branch name / changed files / title), e.g.
  `feature/*` -> `enhancement`, `fix/*` or a title matching `fix` -> `bug`, `*.md` ->
  `documentation`. You can also add `major` / `minor` / `patch` labels manually to control the
  bump.

## Automatic release

This is the normal flow. `release-drafter` keeps a **draft** release up to date as PRs merge; you
publish it when you are ready to ship.

1. **Merge PRs into `main`.** Each PR should follow the title convention
   `[<app>] <description>` so `release-drafter` attributes it to the right container
   (it also scopes changes by the `include-paths` in `.github/release-drafter/<app>.yaml`).
   - On merge, the [Release Drafter](../release-drafter.yaml) workflow updates the draft release
     for the affected container, with a categorized changelog and the next computed version.
   - The [Build and publish Images](../build-push-images.yaml) workflow also builds the changed
     image and pushes it tagged `main` (a rolling dev build — not a release).

2. **Review the draft.** Go to **Releases** and open the draft named `<app>-v<version>`. Check
   the generated notes and the proposed version. Adjust the tag/title if needed (for example to
   align with an upstream version, `0.1.0` -> `0.17.3`).

3. **Publish the release.** Publishing creates the `<app>-v<version>` tag, which triggers
   [`build-push-image-release.yaml`](../build-push-image-release.yaml). The image is built for
   `linux/amd64` + `linux/arm64` and pushed to `ghcr.io/<owner>/<app>` with the semver tags.

### Regenerating a draft (recovery)

Use this when the [Release Drafter](../release-drafter.yaml) run **failed or was skipped**, or a
draft looks **stale or wrong** and you want to rebuild it from the latest changes since the
previous version.

1. Go to **Actions -> [Release Drafter](../release-drafter.yaml) -> Run workflow** and select
   the **`main`** branch.
2. Run it. The workflow re-runs the per-app matrix and **rebuilds each container's draft** from
   all PRs merged since that app's last published release.

This is safe to run anytime:

- It is **idempotent** — `release-drafter` updates the existing draft **in place**, it never
  creates duplicate drafts.
- **All apps regenerate**, which is intentional and harmless: each draft is computed
  **independently** from that app's own `tag-prefix` and `include-paths` (see
  [How versioning works](#how-versioning-works)), so there is no cross-app contamination, and
  apps without new changes are left effectively unchanged.

## Manual release

Use the **Cut Release** workflow to publish a specific version without editing the draft. This is
ideal for patches, fixes and hotfixes where you want a deterministic, one-click release.

1. Go to **Actions -> [Cut Release](../cut-release.yaml) -> Run workflow**.
2. Fill in the inputs:
   - `app` — the container to release, e.g. `opentofu` (must match an existing top-level
     directory).
   - `version` — the semantic version **without** prefix, e.g. `1.0.5` (must be
     `MAJOR.MINOR.PATCH`).
3. Run it. The workflow validates the inputs, then creates and pushes the tag
   `<app>-v<version>` (e.g. `opentofu-v1.0.5`).
4. The tag triggers the release build, publishing `ghcr.io/<owner>/opentofu:1.0.5`, `:1.0` and
   `:1`.

> The Cut Release workflow only pushes a tag and builds the image — it does **not** create a
> GitHub Release entry or changelog. If you also want published release notes, use the
> [automatic release](#automatic-release) flow instead (or create the GitHub Release for the tag
> afterwards).

## Resulting image tags

Tag extraction is configured via `docker/metadata-action` in
[`build-push-image.yaml`](../build-push-image.yaml). For a release tag `toolbox-v1.4.2` the image
`ghcr.io/<owner>/toolbox` is published with:

- `1.4.2` (full version)
- `1.4` (major.minor)
- `1` (major)

Pushes to `main` (and PRs) instead produce rolling `main` / `pr-<n>` tags via the
[Build and publish Images](../build-push-images.yaml) workflow.

## See also

- [Create a new container](create-container.md)
- [FAQ & troubleshooting](faq.md)
