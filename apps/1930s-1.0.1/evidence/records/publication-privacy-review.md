# Publication privacy review

- Candidate: `apps/1930s-1.0.1` public documentation, tools and screenshots.
- Intended channel: public GitHub repository.
- APK distribution: none; patchset only.
- Screenshot pixels: manually reviewed. They show only the Sony status/navigation
  chrome and Style portrait's built-in collection artwork/text. No account,
  notification content, contact, message, location, network name, filename,
  personal photo, serial, or device identifier is visible.
- Screenshot metadata: retained only safe PNG structure and a generic Google/Skia
  display color profile. Pixel SHA-256 values matched before and after metadata
  normalization.
- Text and records: public copies omit ADB serials, owner names, private paths,
  credentials, host addresses, and private App Store/NAS locations.
- Tools: contain no key, certificate private material, password, token, cookie, or
  proprietary APK payload. Signing secrets are environment inputs.
- Motivated-intruder review: no useful singling-out, linkability, or inference path
  was found beyond the intentionally public device classes and project identity.
- Reviewer: Codex technical review under human-supervised owner review; this is not
  represented as an independent privacy-specialist opinion.
- Residual risk: public device model/OS and app version are intentional research
  facts; the screenshots retain OEM application artwork owned by Sony.
- Automated staged-tree scan: 41 files and 1,613,946 bytes inventoried. Gitleaks
  scanned all reachable commits and reported no leaks.
- Scanner review items: six email matches all resolve to the repository owner's
  intentionally public GitHub-generated `users.noreply.github.com` commit identity
  in existing history/documentation. They are neither a private mailbox nor an
  authentication secret and are retained as normal public authorship metadata.
- Decision: `passed` for the exact staged public candidate after automated,
  metadata, pixel, manual visual, and motivated-intruder review. Publication must
  still rerun this gate against the immutable commit and separately pass rendered
  desktop/narrow browser review.
