# Publication privacy review

Review date: 2026-07-18
Release context: unrestricted public GitHub repository
Candidate: the complete tracked repository at the final reachable `main` commit

## Scope

All files tracked for the Calculator 8.0.0 public patchset were checked before
repository creation. The review covered documentation, ledgers, scripts, patches,
screenshots, hashes, file types, Git commit metadata, all reachable Git history,
and the rendered screenshot gallery. The candidate contains 20 tracked files.

## Automated checks

- The exact tracked tree and all reachable Git history were scanned with
  `public-artifact-deidentification-gate` and `gitleaks`.
- File names, textual content, forbidden private/binary artifact types, PNG
  structure, media metadata, trailing bytes, and commit author/committer metadata
  were included.
- The final post-remediation run returned no automated finding; `gitleaks` found
  no secret. Automated clearance does not replace the rendered/manual review.

## Findings and remediation

- One physical HTC device serial was found in the rollback record. It was replaced
  with the non-identifying label `htc-test-device-01`.
- The initial Git commit exposed a private `.local` address in author and
  committer metadata. The sole reachable commit was rewritten to the
  intentional public identity `Bee-Breeze@users.noreply.github.com`, and all refs
  and reachable history were rescanned.
- No Sony or HTC serial remains in the public files.
- No account name, email address, home-directory path, IP address, SSID, Android
  ID, IMEI, IMSI, MAC address, location, contact, calendar item, message, photo,
  token, API key, password, private key, or keystore was found.
- No APK, database, archive, app-private backup, or signing key is included.
- Screenshot pixels were manually reviewed. They contain only the Calculator UI,
  ordinary status-bar time/connectivity/battery indicators, and no notification
  content or user data.
- PNG metadata was inspected. No GPS, account, device serial, filename path, or
  other private identifier was present. Nonessential metadata and trailer bytes
  were removed before final hashing.

## Motivated-intruder test

- `singling_out`: the screenshots show only deterministic calculator controls and
  test expressions. They do not isolate a person, account, household, or private
  device identifier.
- `linkability`: the public device-class labels, app/package identifiers, hashes,
  Android versions, and public GitHub identity describe the research artifact but
  do not provide a stable key to private user data. The former physical-device
  serial and local Git address are absent from reachable public state.
- `inference`: ordinary status-bar time, connectivity, and battery icons reveal
  low-value test state only. Combined with the rest of this release, they do not
  reasonably reveal identity, location, account activity, communications, or
  another sensitive fact.

The project owner supervised the device evidence and public-content review. This
is a human-supervised engineering review, not an independent privacy-specialist
or legal determination.

## Result

`passed_after_redaction`

This result applies only to the exact public commit and must be rerun whenever a
tracked file, Git ref, tag, screenshot, metadata field, or rendered gallery
changes. Reassess if new auxiliary data makes the device labels, timestamps, or
evidence linkable. If a disclosure is found after publication, remove access,
preserve private incident evidence, rotate any credential, rewrite affected
history where necessary, and publish a corrected review.
