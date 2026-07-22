# Technical test summary

| Gate | Result |
| --- | --- |
| Exact identity | `com.sonymobile.moviecreator.rmm` 5.8.A.0.1, versionCode 11534337 |
| Unchanged original | Passed; Sony signer retained, no rebuild or resigning |
| Sony Android 13 | Passed; real main page, layout, editing, playback, export, offline and lifecycle |
| HTC Android 6.0.1 | Completed failure; exact APK rejected because `com.sony.device` is absent |
| Layout | Passed portrait and landscape; no black bar, clipping, overlap or touch drift |
| Deep-control inventory | 22 screens; 76 controls; 74 passed; 2 evidenced duplicate destructive skips; 0 failed; 0 blocked |
| Logs | 0 attributable fatal, ANR, verification, linkage, security or native failures |
| Final cleanup | Synthetic projects, media and exports removed; test state restored |

The tested Sony device completed a synthetic end-to-end movie workflow including
media selection, editing, local playback, share routing and Full HD export. The two
skipped controls duplicate already-tested destructive project deletion entry points;
they are not untested user-visible features. The HTC result is recorded as a genuine
cross-OEM failure rather than hidden with a substituted APK or fabricated platform
library.
