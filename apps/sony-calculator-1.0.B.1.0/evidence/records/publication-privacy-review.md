# Public artifact de-identification review

- Candidate: Sony Calculator 1.0.B.1.0 evidence-only public record
- Release context: unrestricted public GitHub repository
- Review date: 2026-07-18
- Decision: `passed_after_redaction`

## Scope and remediation

The initial internal evidence directory failed because it contained the Sony
original APK, two recordings that had not received complete frame/audio review,
one black screenshot, and no frozen Git history. A new purpose-built public copy
was created instead of sanitizing the private original directory.

- The Sony APK, MP4 recordings, black screenshot, raw logs, UI dumps, physical
  device serials, local paths, and private working files are excluded.
- Four useful result screenshots, a minimized deep-control ledger, a technical
  summary, and public documentation are included.
- Screenshot pixels were manually reviewed. They show only Calculator UI,
  deterministic test values, and ordinary status-bar indicators; no account,
  notification text, contact, message, location, filename, portrait, or device
  identifier is visible.
- PNG metadata and trailing bytes were checked. No GPS, owner, account, local
  path, serial, or embedded diagnostic is retained.
- The exact tracked tree and reachable Git history were scanned for direct and
  indirect identifiers, secrets, private artifacts, metadata, and local commit
  identity. The intentional public GitHub noreply identity is documented.

## Motivated-intruder test

- `singling_out`: the evidence does not isolate a person, account, household, or
  physical device identifier.
- `linkability`: public model/OS labels, package/version, hashes, and the project
  identity describe the research result but do not link to private user data.
- `inference`: status-bar times and connectivity/battery icons reveal only
  low-value test state and do not reasonably expose location, communications,
  account activity, or another sensitive fact when combined with this record.

The project owner supervised the real-device evidence. This is a technical,
human-supervised review rather than a legal anonymity determination. Any later
file, screenshot, metadata, commit, tag, or gallery change requires a full rerun.
