# FAQ & Troubleshooting

Common questions, issues and errors when adding containers or cutting releases.

## Adding a container

### `task: command not found` / `task container:new` does nothing

You need the [Task](https://taskfile.dev) runner. Install the tooling with `task brew:init`, or
install [`go-task`](https://taskfile.dev/installation/) manually. Run the task **from the
repository root**.

### `ERROR: invalid name '<name>'. Use lowercase letters, digits and hyphens.`

The app name must match `^[a-z0-9][a-z0-9-]*$`. It maps 1:1 to the directory and to the image
name `ghcr.io/<owner>/<name>`, so no spaces, uppercase or special characters. Prefer
hyphen-free names when possible.

### `ERROR: container '<name>' already exists`

A directory `<name>/` or a `.github/release-drafter/<name>.yaml` config already exists. Pick a
different name, or remove the partial scaffold if a previous run failed midway.

### I added a container but no draft release appears

Checklist:

- The PR is **merged into `main`** (drafts are created/updated on merge, not on PR open).
- `.github/release-drafter/<app>.yaml` exists and is valid (the
  [Release Drafter](../release-drafter.yaml) workflow discovers it automatically from
  `.github/release-drafter/*.yaml`).
- The PR actually changed files under `<app>/` — the config's `include-paths` scopes the
  container to its folder.
- The PR title follows `[<app>] <description>` so changes are attributed correctly.

### Do I still need to edit the `release-drafter.yaml` workflow when adding a container?

**No.** The workflow discovers every `.github/release-drafter/*.yaml` (except `base.yaml`) and
runs a matrix job per container. Adding the config file (done for you by `task container:new`) is
enough. The build workflows likewise auto-detect the new directory.

## Releases

### Release Drafter failed / my draft is out of date — how do I regenerate it?

Manually re-run the drafter: **Actions -> [Release Drafter](../release-drafter.yaml) -> Run
workflow**, with the branch set to **`main`**. This rebuilds every container's draft from all PRs
merged since each app's last published release. It is idempotent (the existing draft is updated in
place, never duplicated), and regenerating all apps is safe because each draft is computed
independently from its own `tag-prefix` and `include-paths`. See
[Releases -> Regenerating a draft (recovery)](releases.md#regenerating-a-draft-recovery).

### My image didn't get built after publishing a release

The image build is triggered by the **tag push**, not by the GitHub Release UI itself. Confirm:

- A tag `<app>-v<semver>` was actually created (check the repo **Tags**).
- The [Build and publish Images Release](../build-push-image-release.yaml) workflow ran for that
  tag (check **Actions**).
- The tag matches the `*-v*` pattern the workflow listens for.

### `ERROR: version '<x>' must be semver MAJOR.MINOR.PATCH`

The **Cut Release** workflow requires a strict `MAJOR.MINOR.PATCH` version **without** a prefix.
`1.0.5` is valid; `1.2`, `v1.2.3` and `1.0.5-rc1` are rejected.

### `ERROR: container directory '<app>/' does not exist`

The `app` input to **Cut Release** must match an existing top-level directory. Check spelling and
case.

### `ERROR: tag '<app>-v<version>' already exists`

That version was already released. Pick a higher patch/minor/major version. Tags are immutable —
don't re-point an existing tag.

### The wrong app name was parsed from my tag

Release tags are parsed by stripping the `-v<semver>` suffix (`<app>-v1.0.0` -> `<app>`), so
hyphenated app names like `my-app-v1.0.0` -> `my-app` work correctly. The app name must still map
to an existing directory.

### Conflict between a manual cut and the release draft

If you cut a version manually with **Cut Release**, then later try to **publish the draft** with
that same version, publishing fails because the tag already exists. Either:

- bump the draft to the next version before publishing, or
- delete the draft if the manual cut already shipped what you needed.

The manual cut does not consume or clear the draft — the draft keeps accumulating notes for the
next version.

## Images & registry

### `denied` / `unauthorized` when pushing to `ghcr.io`

The build workflows authenticate with the built-in `GITHUB_TOKEN` and need `packages: write`
permission (already set in the workflows). If you fork the repo, ensure Actions are enabled and
the package visibility/permissions allow publishing under your owner.

### Multi-arch / `exec format error` at runtime

Images are built for `linux/amd64` and `linux/arm64`. If you hit an architecture error, confirm
your base image and any downloaded binaries support the target platform (use `TARGETPLATFORM` in
the `Dockerfile` to select the right artifact).

## Labels & changelog

### My PR landed in the wrong changelog category (or none)

Categories are driven by labels (see [`base.yaml`](../../release-drafter/base.yaml)). Add the
right label (`enhancement`, `bug`, `documentation`, `chore`, `dependencies`, `breaking`) or rely
on the `autolabeler` (branch prefix `feature/*`, `fix/*`, `docs/*`; title containing `fix`;
`*.md` files). Use `skip-changelog` to exclude a PR entirely.

### Why don't Renovate PRs follow the `[<app>] <description>` title convention?

They do, automatically. [`renovate.json`](../../renovate.json) sets
`commitMessagePrefix: "[{{packageFileDir}}]"`, so each Renovate PR is prefixed with the folder of
the file it updates (e.g. `[toolbox] Update ...`). Updates outside an app folder (GitHub Actions in
`.github/workflows/`) are prefixed `[ci]`. `additionalBranchPrefix` splits updates per folder, so a
base image shared by two apps opens one PR per app instead of a single cross-app PR. Renovate PRs
are labelled `dependencies` (also covered by the `autolabeler` for `renovate/*` and `ci/*` branches),
so they land under **📦 Dependency updates**.

### The version bump wasn't what I expected

The bump comes from PR labels via `version-resolver` (default `patch`). For a minor/major
release, label the PR `minor` / `major` (or `breaking`) before merging, or adjust the version on
the draft before publishing. See [Releases -> How versioning works](releases.md#how-versioning-works).

## See also

- [Create a new container](create-container.md)
- [Releases (automatic & manual)](releases.md)
