# Technical test summary

- Decision: `accepted_sony_only`
- Exact add-on SHA-256: `ab092774e54ca9527fe7bff03ed6fc8bd478292252240273899446d664462eb7`
- Exact host SHA-256: `70ed69008f644bfe3934e7a2275217e5abfdad2dd49166bdcd808e75f8261d30`
- Sony: Android 13/API 33; ordinary install and runtime; Root/Magisk not used.
- Genuine host: Style portrait collection manager `30.0.A.0.1`.
- Visual: host root 1096 x 2434; no compatibility bottom band, clipping, overlap,
  or black content regression in the final max-aspect build.
- Action: remove `1930年代` from favorites `(9/13 -> 8/13)`, then restore it
  by selecting the collection tile `(8/13 -> 9/13)`.
- Lifecycle: Home/resume, back/reopen and force-stop/cold-reopen retained state.
- Startup: latest measured clean-log cold launch 235 ms; resumed and stable.
- Logs: no attributable fatal exception, ANR, verification, linkage, resource,
  security, or native crash.
- Orientation: actual display rotation remained 0 even under a landscape request;
  landscape is `not_applicable_with_evidence` for this host path.
- Deep controls: not applicable because the add-on has no launcher or standalone
  controls; genuine discovery and the domain-equivalent host action were tested.
- Rollback: final -> original -> final completed; every installed add-on state was
  pulled and matched its expected SHA-256.
- HTC: exact add-on installed and pull-back hash matched; runtime failed because
  HTC lacks the genuine Style portrait host. Root was not used and cleanup passed.
