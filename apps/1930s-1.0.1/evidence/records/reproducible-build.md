# Reproducible repair verification

The public `scripts/build-and-sign.sh` was executed on 2026-07-19 with:

- 1930's original input SHA-256
  `a8831dd72c66bf48e26e09509d975c8a11f3bfbcfb16825943c88ac3aa291e26`
- Style portrait original input SHA-256
  `0f844f1cbc37154370642fab3398b74a2804003dd2825953a3ce0919d53d8c5f`
- Apktool 3.0.2, Android build-tools 36.0.0 and JDK 17
- A disposable output directory and the same local test signer used by the exact
  device-tested artifacts

Both outputs passed `apksigner verify` with v2/v3 signatures, `unzip -t`,
CRC verification and `zipalign -c -p 4`. The host is rebuilt entry by entry
from the exact Sony input, with signature entries removed and all malformed or
signer-generated local/central ZIP extra fields cleared. Comparison by ZIP entry
name and uncompressed-entry SHA-256, excluding signature metadata, showed:

| Artifact | Public rebuild entries | Exact tested entries | Added | Removed | Changed |
| --- | ---: | ---: | ---: | ---: | ---: |
| 1930's portable | 21 | 21 | 0 | 0 | 0 |
| Style portrait max-aspect | 1,899 | 1,899 | 0 | 0 | 0 |

`aapt dump xmltree` confirmed the add-on's `com.sony.device` declaration has
typed boolean value `0x0`. The host keeps the original string-pool label for its
reused attribute slot, while the binary resource-map ID is changed to
`0x01010560` and the typed float value is `0x40400000` (`3.0`); Android resolves
the attribute by resource ID.

The public rebuild's whole-file hashes differ from the exact tested APK hashes
because ZIP metadata and APK signing are not bit-for-bit reproducible across
build times. Logical payload equality proves the public procedure reconstructs
the tested patch, not the user's private signing identity.

An earlier v3 host used in-place `zip -d` / `zip` replacement. It remained
installable on Android but failed Stage 9 independent restore validation because
`unzip -t` found a malformed extra-field length on
`lib/armeabi-v7a/libDefocus.so`. That candidate is rejected. The exact v4 host
documented here uses the clean rebuild path and passed the independent ZIP gate.
