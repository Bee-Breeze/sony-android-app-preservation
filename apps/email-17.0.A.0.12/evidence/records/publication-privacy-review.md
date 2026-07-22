# Publication privacy review

- Decision: `passed_after_redaction`
- Public mode: documentation, project-owned patch tool and two screenshots; no APK
- Screenshots: two exact final PNGs, original-pixel and OCR reviewed
- Content: reserved `.test` addresses and explicit synthetic fixtures only
- Status/navigation bars: removed
- PNG metadata and appended trailer data: removed and checked
- Account, notification, device ID, private mail, location, path and credential content: absent
- Exact Email candidate scan: 8 files, zero findings; no allowlist required
- Whole-repository pre-commit scan: two review items, both an already-public
  GitHub-generated no-reply commit identity in existing records; the exact value
  was allowlisted, none originates from the Email candidate, and it is not a
  private mailbox
- Gitleaks reachable-history scan: zero secret findings
- Manual visual rerun: both final PNGs show only app UI, reserved `.test`
  addresses and explicit synthetic content; no status bar or unrelated overlay
- Motivated-intruder review: no material singling-out, linkability or inference risk

Any change to a screenshot, README, patch, checksum, Git history or adjacent public
context invalidates this summary and requires a new exact-commit privacy review.
