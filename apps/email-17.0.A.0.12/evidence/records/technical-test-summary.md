# Technical test summary

| Gate | Result |
| --- | --- |
| Exact identity | `com.sonymobile.email` 17.0.A.0.12, versionCode 35651596 |
| Original APK | Installed and reached a real synthetic-account inbox; one repeated-row edge-touch defect found |
| Practical repair v1 | Passed; only star/flag and thread-count end geometry changed; locally re-signed |
| Google OAuth repair v3b | Passed; Google Play Services authorization returned to Sony Email account setup without embedded credentials |
| Sony Android 13 | Passed; Google authorization, real inbox, layout, 171 controls, send/receive, attachment, offline and lifecycle |
| HTC Android 6.0.1 | Failed to install exact final APK: minSdk 30 exceeds API 23 |
| Layout | Portrait and landscape passed; no black bar, clipping, overlap or touch drift |
| Deep-control inventory | 12 screens; 171 controls passed; 0 failed, blocked, skipped or N/A |
| Logs | 0 attributable fatal, ANR, security or linkage failures |
| Final cleanup | Synthetic mail fixture, temporary folders, permissions, settings and orientation restored |
| Public patch reproduction | Practical repair v1 passed from the exact original hash; OAuth v3b is evidence-only because its original local build tree was removed before replacement publication |

The HTC failure is a platform requirement result, not evidence of an App crash.
No older Android 6 branch was substituted for the exact-final-artifact test.

The exact final private artifact is
`5cbf595ce53140b217619be58a7da6a0687776f6894e26c59bca34020ea7a2df`.
It was recovered from the installed Sony package and compared structurally with
the superseded Practical repair v1 artifact. The comparison found the retained
layout repair plus the documented OAuth activities, Google Play Services support,
account-setup bridge and XOAUTH2 token-refresh bridge.
