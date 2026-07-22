# Practical repair v1

This patch is intentionally limited to the repeated message-row action geometry.
It requires a user-supplied Sony Email `17.0.A.0.12` APK whose SHA-256 is exactly:

`de9d4f5a0fb4cb5abfe38ac522acc6bd92dd05a3ebcaa42eed2763e17730da3f`

The tool adds a `40dp` end padding dimension and applies it to exactly two
containers in `message_list_item_normal.xml`: the star/flag action and the thread
count. It does not edit the manifest, DEX code, account logic, protocol handling,
permissions, network policy, strings, icons, or other layouts.

The original APK is not included. The user must decode it with apktool, run the
script, rebuild it, and sign the result with a key they control. A re-signed APK
cannot update the Sony-signed package in place; backup and an uninstall/install
boundary are required.
