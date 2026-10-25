# Roadmap and safety gates

## Milestone 0 — preflight (this branch)

- [x] Python-independent target OS/version/architecture inspection
- [x] Disk/mount/tool inspection
- [x] Serial execution; explicit --limit required
- [x] Reject force/ensure until implemented
- [ ] Validate on FreeBSD 12.x, 13.x, 14.x, 15.x

## Milestone 1 — release selection/staging (read-only)

- [ ] Discover **supported production** FreeBSD -RELEASE and architecture from official FreeBSD sources, with explicit overrides
- [ ] Check boot scheme, filesystem, free space, console/rollback options, network and SSH configuration
- [ ] Fetch archives over IPv4 where needed; verify against authenticated trusted checksums/signatures
- [ ] Safe staging; no changes to installed base

## Milestone 2 — forced replacement on disposable machines

- [ ] Document exactly what is overwritten/preserved
- [ ] Test UFS and ZFS bootloader/boot-environment paths
- [ ] Design a static-tools recovery strategy for libsys/libc/SSH failures
- [ ] Implement explicit opt-in destructive action, one test host at a time
- [ ] Reconnect checks after deliberate reboot; test interrupted upgrade
- [ ] Preserve configuration policy and restore Ansible connectivity

## Milestone 3 — ensure/repair

- [ ] Verify filesystem integrity using vetted release manifests
- [ ] Detect differences in OS-owned files only; avoid replacing managed local configuration
- [ ] Repair missing/mismatched runtime libraries and SSH helpers
- [ ] Prove idempotency: second run produces no changes

## Milestone 4 — package reconciliation

- [ ] Fix pkg/pkg-devel conflicts safely
- [ ] Reconcile repositories and ABI after major upgrade
- [ ] Clean stale shared libraries only after boot/reconnect validation

## Critical non-goals

No automatic execution against production servers; no unsafe blind overwrite of active root filesystems; no trust in `freebsd-version` alone as an integrity check.
