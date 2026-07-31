# Technical test result

- Decision: `accepted_sony_only`
- Exact APK: unchanged Sony Android 13 variant
- Sony: real main page, portrait, landscape, enlarged text, safe controls, lifecycle and clean-log checks passed
- HTC: exact APK install failed with `INSTALL_FAILED_OLDER_SDK`
- Data transmission: intentionally not enabled; no certificate, private key or CA selected
- Runtime Root or reboot: not required
- Public distribution: `evidence_only`
