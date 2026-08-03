# Test Result

## Technical decision

`partial_evidence_record`

The exact repaired APK is stable and usable on Sony Android 13, but the retired
project backend prevents end-to-end project participation. HTC reaches the real
main page with the same APK, while its tutorial Skip control is severely clipped.

## Sony Xperia 1 III / Android 13

- Real `MainActivity`: passed
- Portrait and landscape: passed
- Font scale 1.3: passed
- Search, overflow, tutorial, legal, Retry: passed
- Deep controls: 11 passed, 0 failed, 0 skipped
- Lifecycle stress: passed
- Attributable fatal/ANR: 0/0

## HTC One M8 / Android 6.0.1

- Ordinary non-Root installation: passed
- Pulled installed APK hash: exact match
- Real main page: passed
- Portrait and landscape main page: passed
- Representative search/legal actions: passed
- Tutorial Skip visual/touch geometry: failed, approximately 6 px usable height
- Lifecycle stress: passed
- Package and test settings restored: passed

## External limitation

The App reports no projects because its Sony/Firebase service is retired. Retry
correctly exercises the original error path but cannot restore server content.
