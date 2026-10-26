# freebsd-steamroll

Experimental, safety-first Ansible tooling for replacing or repairing FreeBSD base releases.

## Design

Two standalone roles:

- `freebsd_release`: inspect the installed system, discover/stage/verify releases (future), and eventually implement `forcerelease` and `ensurerelease`.
- `freebsd_packages`: inspect package tooling and eventually reconcile packages after base upgrade.

**Current implementation is read-only. No archive extraction, package installation, or reboot takes place.** The future write path remains intentionally blocked until verified against disposable VMs.

Unlike `freebsd-update`, the eventual aim is noninteractive, verifiable direct release replacement (including tests from FreeBSD 12.x/13.x) without hand-merging base-system files. Major-version upgrades cannot be assumed safe merely because an archive can be extracted.

## Quick start

Requires `uv` on the controller and SSH access to disposable FreeBSD machines. The initial preflight uses Ansible `raw` to avoid requiring working Python on legacy FreeBSD targets.

```sh
uv sync
cp inventory.example.ini inventory.ini
# edit inventory.ini; keep secrets out of Git
uv run ansible-playbook -i inventory.ini freebsd-release.yml --limit freebsd_test
```

The playbook refuses to run without `--limit` and never modifies the target in this milestone. You can inspect a specific host with `--limit hostname`. Defaults use `freebsd_release_mode: inspect`. **`ensure` and `force` are NOT implemented, and selecting either fails closed.**

## Project decisions

- Target only supported production `-RELEASE` versions, never `CURRENT` or `STABLE`; release discovery needs a verified official source and policy for architecture/support lifecycle.
- Preflight before downloading or changing anything; independently verify distribution archives and hashes before installation.
- Never assume the dynamic linker or Python survives a partially completed upgrade; static recovery tools and rollback must be designed and tested.
- Separate operating-system-owned files from administrator-owned configuration. `ensure` must not simply overwrite arbitrary differing files.
- Explicit support/test plans for UFS, ZFS, bootloaders, SSH, network configuration and reconnect after reboot.
- Never commit an operational inventory or authentication details.

## Test matrix

| Start | Filesystem | Goal |
|---|---|---|
| 12.4 | UFS | Legacy boot/ABI and direct upgrade feasibility |
| 13.x | UFS | Older major version |
| 14.1 | UFS | Upgrade and old runtime |
| 14.3 | UFS | Typical upgrade |
| 14.x | ZFS | Boot environments/rollback |
| Current 15.x | UFS | Idempotency/repair |
| Current 15.x | ZFS | Idempotency/repair/rollback |

See [docs/roadmap.md](docs/roadmap.md).
