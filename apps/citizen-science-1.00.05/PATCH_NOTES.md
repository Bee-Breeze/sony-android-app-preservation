# Patch Notes

## Final artifact

- Package: `com.sonymobile.activityathome`
- Version: `1.00.05` (`10005`)
- Original SHA-256:
  `1b088329394a9f4e72fc3693f77d57fca06328d8e23663bc30c5f69411fda1a3`
- Final SHA-256:
  `702085b33dda9d9e7a4de43a0f27b111767edc859cb89e73f6b44a7c83baa6ed`
- Final signer certificate SHA-256:
  `b5e26a13f091dd593e8f8024e7de21cc0426d0d383feae3300035b84def9d618`

## Minimal changes

1. `MainActivity.onCreate` no longer invokes the retired online-service disclaimer
   fragment. It does not call the acceptance callback and does not persist a false
   acceptance record.
2. The application and ordinary App activities opt into resizable modern window
   geometry. The historical portrait-only tutorial remains portrait-only.
3. `PermissionInfo.getTitle` maps Android 13's legacy
   `android.permission-group.UNDEFINED` result to the system Contacts permission
   group, retaining the platform's localized label.

No endpoint, account, project, survey, authorization, telemetry payload or remote
content was added. The rebuilt artifact is signed with a local preservation test
key and is distributed only through the owner's private App Store.

## Known limitations

- The Sony Citizen Science/Lifelog/Firebase backend is retired.
- HTC Android 6 renders the tutorial Skip button in a 6 px bottom hit area.
- The package must be uninstalled before switching between Sony and local signers.
