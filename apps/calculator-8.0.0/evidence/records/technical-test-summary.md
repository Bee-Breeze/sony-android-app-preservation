# Calculator 8.0.0 portable repair v1 - technical test summary

## Identity

- Catalog index: 72
- Package: `com.android.calculator2.preserved8`
- Version: `8.0.0` (`versionCode 26`)
- Final artifact SHA-256: `5414327493a0f24d1e36f9b613fa512c8575605bf6bd4b35ad634a98c0bd8542`
- Minimum Android API: 23
- Runtime Root requirement: none
- Signing: local Android debug certificate; this is not the Sony production signer

## Repair scope

The unchanged Sony 8.0.0 APK requires API 26 and therefore cannot install on the
HTC Android 6.0.1/API 23 test device. On Sony Android 13 it runs, but long-press
Copy/Paste does not expose its floating ActionMode menu. The portable repair:

1. uses a coexistence package name;
2. lowers the declared minimum SDK from 26 to 23;
3. routes result and formula long-press actions through the app's existing legacy
   context-menu implementation.

No permissions, native libraries, arithmetic logic, layouts, strings, icons, or
network behavior were added. The manifest declares zero permissions, disables
backup, contains two activities, and contains no native libraries.

## Sony Android 13 result

- Ordinary non-root install passed and the pulled installed APK exactly matches
  the final artifact hash.
- Cold start reached the real Calculator page in 227 ms.
- Portrait and landscape render to the usable app bounds without an app-owned
  bottom black bar; controls at both landscape edges remained touchable.
- All 49 inventoried controls or state variants passed. This includes all digits,
  arithmetic, scientific and inverse functions, DEG/RAD, error handling, menu
  items, dialogs, license navigation/scroll, and repaired Copy/Paste.
- Home/resume preserved the result. Back and force-stop produced clean relaunches.
- No fatal exception or ANR was observed in the captured logs.
- Accessibility inventory: 33 clickable controls, zero unlabeled, all enabled and
  focusable.

## HTC Android 6.0.1 result

- The unchanged Sony APK was attempted first and failed with
  `INSTALL_FAILED_OLDER_SDK`, as expected from its API 26 minimum.
- The exact repaired artifact installed through ordinary non-root ADB.
- The real main page, `2 + 3 = 5`, Copy/Paste, portrait, and landscape passed.
- The APK pulled from HTC has the same SHA-256 as the Sony-installed and local
  final artifact.
- The pre-existing HTC system Calculator was not replaced.

## Inventory closure

- Inventory: 49
- Passed: 49
- Failed: 0
- Blocked: 0
- Intentionally skipped: 0
- Not applicable: 0

The per-control record is `final_deep_sony/deep_control_ledger.tsv`. Evidence is
stored beside the ledger and in the repair directory's HTC and Sony capture sets.

## Distribution note

Sony retains ownership of the original application and its assets. Publication
must separately decide whether to distribute only documentation and a reproducible
patchset requiring a user-supplied original, rather than redistributing the OEM
binary. Project-owned documentation and patch tooling may use an open-source
license; that license cannot be applied to Sony material.
