# Kynx Upgrade Repository

This repository is the content source used by the `kynx k-upgrade` command.

## Purpose

`kynx k-upgrade` checks `version.txt`, downloads the repository archive, copies its content into the Kynx OS filesystem, and runs `scripts/post-upgrade.sh` if it exists.

## Official Sites

- https://kynx.xyz
- https://kynx-os.org

## Repository Layout

- `apps/`
  - Copied to `/opt/kynx/apps`
- `assets/`
  - Copied to `/usr/share/kynx/assets`
- `packages/`
  - Every `*.sh` file is installed into `/usr/bin` without the `.sh` suffix
- `system/`
  - Copied to `/usr/share/kynx/system`
- `manifest.json`
  - Copied to `/usr/share/kynx/manifest.json`
- `version.txt`
  - Copied to `/usr/share/kynx/version.txt`
- `scripts/post-upgrade.sh`
  - Executed after upgrade

## Notes

- Content inside `system/` is stored under `/usr/share/kynx/system` and is not auto-applied unless `scripts/post-upgrade.sh` applies it.
- This repository is designed for Kynx GitHub-based upgrade flow.
- Current base kernel release: `6.12.76-kynx`

## Current Channel

`development`
