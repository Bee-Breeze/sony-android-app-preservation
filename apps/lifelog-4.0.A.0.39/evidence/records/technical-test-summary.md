# Technical test summary

| Gate | Result |
| --- | --- |
| Exact identity | `com.sonymobile.lifelog` 4.0.A.0.39, versionCode 8388647 |
| Unchanged original | Passed; Sony signer retained, no rebuild or resigning |
| Sony Android 13 | Passed; Timeline, layout, deep controls, offline and lifecycle |
| HTC Android 6.0.1 | Passed; same exact APK, ordinary non-root install |
| Layout | Passed portrait; no black bar, clipping, overlap or touch drift |
| Landscape | Not applicable with evidence; activities intentionally lock portrait |
| Deep-control inventory | 18 screens; 132 controls; 122 passed; 2 intentionally skipped; 8 N/A; 0 failed |
| Logs | 0 attributable fatal, ANR, security or linkage failures |
| Final cleanup | Test data, permissions, settings and orientation restored |

The two intentionally skipped actions would have exported activity/location data or
sent content to an external target. Their routes and controls were inspected without
creating an export or transmitting private data.

