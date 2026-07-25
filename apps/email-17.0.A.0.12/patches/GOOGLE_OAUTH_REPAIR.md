# Google OAuth repair v3b recovery record

## Status

This is an evidence-only recovery record for the exact private Sony Email
artifact whose SHA-256 is:

`5cbf595ce53140b217619be58a7da6a0687776f6894e26c59bca34020ea7a2df`

The artifact was recovered byte-for-byte from the installed package on the
tested Sony Xperia 1 III. The original local build tree had been removed before
the replacement artifact completed publication and archival. This document does
not claim bit-for-bit reproducibility and does not include Sony decompiled code,
Google library code, credentials, tokens, signing keys, or the APK.

## Observed delta from Practical repair v1

The recovered artifact retains the two resource edits from Practical repair v1.
Compared with that superseded artifact, its functional delta is limited to:

1. Two added non-exported activities:
   `com.sonymobile.email.oauth.GoogleOAuthActivity` and Google Play Services'
   `GoogleApiActivity`.
2. Google Play Services Identity/Auth support in a second DEX.
3. A hook from Sony Email's Gmail account setup action to the new authorization
   activity.
4. A result bridge that returns the provider, access token, account identifier,
   and token lifetime through Sony Email's existing setup data object.
5. An XOAUTH2 refresh path that requests a current token from Google Play
   Services for the selected Android Google account.

No IMAP/SMTP endpoint, TLS policy, message database, attachment path, permission,
launcher component, icon, or non-Gmail account flow was intentionally changed.

## Authorization contract

- Requested scope: `https://mail.google.com/`
- Account type: `com.google`
- Token source: Google Play Services Identity API on the device
- Embedded OAuth client secret: none observed
- Embedded private account or password: none observed
- Embedded pre-issued access or refresh token: none observed
- OAuth activity export state: `false`

The full-mail scope is broad because Sony Email uses IMAP/SMTP XOAUTH2 rather
than a narrow Gmail REST operation. Users should review and revoke access from
their Google Account when they no longer use the app.

## Exact-artifact validation

The exact artifact reached the Sony Email account flow and real inbox on Sony
Android 13. The retained Stage 7 record reports 12 screens and 171 of 171 unique
controls passed. The same artifact could not be installed on the designated HTC
Android 6 device because its declared minimum is API 30 and the HTC is API 23.
That is recorded as a completed failed portability attempt, not as a crash.

## Recovery and rollback

The exact private APK is retained only in the owner's private App Store and NAS
research archive. It uses the project's local test signer and cannot update the
Sony-signed package in place. Back up mail data before crossing the
uninstall/install boundary.

To roll back, uninstall the private OAuth artifact and reinstall a legally
obtained original or the previously retained private Practical repair v1
artifact after verifying its hash. Revoke the Google authorization separately
from the user's Google Account if it is no longer required.
