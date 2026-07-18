# Technical test summary

- Catalog index: 518
- Package: `com.sonymobile.exactcalculator`
- Version: `1.0.B.1.0` (`2098176`)
- Original APK SHA-256: `abdc035a761a568f2eeff47a7c12fedbd52bb6839f3ecaa23e29492c83233162`
- APK modification: none
- Runtime Root requirement: none
- Sony Android 13: 33/33 deep-control cases passed; no App fatal/ANR
- Sony orientations: portrait and landscape passed with `12 + 34 = 46`
- HTC Android 6: unchanged original installed without Root; main page and
  `12 + 34 = 46` passed in portrait and landscape
- HTC cleanup: test package uninstalled and rotation restored to automatic
- Distribution: `evidence_only`; no Sony APK is in the public candidate

The HTC screen image was extracted from Android's screen recorder because the
device's legacy standalone `screencap` command segmentation-faulted independently
of the App. UI hierarchy and resumed-activity evidence remained available.
