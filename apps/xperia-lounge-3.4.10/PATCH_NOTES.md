# Patch Notes

## Final artifact

- Package: `com.sonyericsson.xhs`
- Version: `3.4.10` (`30410`)
- Final SHA-256:
  `0e82466808e21550c29cb463832d65ef7c0788c0d24f9cffa50ab6e3efcb8ea2`
- Final signer SHA-256:
  `982bb9a5d74a6ba9bd4589ed498062b903f6f29aa75537770a5dacf6d494584c`

## Minimal change

The retired client-configuration request reaches the original failure callback.
That callback was redirected from the existing error-and-finish path to the
App's existing bundled-configuration continuation path.

No endpoint, permission, package identity, version, resource, account check, or
content model was added or bypassed. The rebuilt artifact is signed with a local
preservation test key and is distributed only through the owner's private App
Store.

## Known limitations

- Sony login and online content endpoints are retired or unavailable.
- Drawer content categories remain disabled when no server configuration enables
  them.
- A fully offline cold start displays the original no-network dialog and exits
  cleanly after confirmation.
