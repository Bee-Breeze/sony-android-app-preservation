# Technical test summary

| Gate | Result |
| --- | --- |
| Exact identity | `com.sonymobile.email` 17.0.A.0.12, versionCode 35651596 |
| Original APK | Installed and reached a real synthetic-account inbox; one repeated-row edge-touch defect found |
| Practical repair v1 | Passed; only star/flag and thread-count end geometry changed; locally re-signed |
| Sony Android 13 | Passed; real inbox, layout, 171 controls, send/receive, attachment, offline and lifecycle |
| HTC Android 6.0.1 | Failed to install exact final APK: minSdk 30 exceeds API 23 |
| Layout | Portrait and landscape passed; no black bar, clipping, overlap or touch drift |
| Deep-control inventory | 12 screens; 171 controls passed; 0 failed, blocked, skipped or N/A |
| Logs | 0 attributable fatal, ANR, security or linkage failures |
| Final cleanup | Synthetic mail fixture, temporary folders, permissions, settings and orientation restored |
| Public patch reproduction | Passed from the exact original hash; first run changed only the two expected resource files, second run was idempotent, and apktool rebuilt the result |

The HTC failure is a platform requirement result, not evidence of an App crash.
No older Android 6 branch was substituted for the exact-final-artifact test.
