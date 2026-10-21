# Ironfox-OLED

Automated builds of [IronFox](https://gitlab.com/ironfox-oss/IronFox) for Android with a **true black (OLED) dark theme that also applies when the theme follows your system setting**.

This is a maintained continuation of [ArtikusHG/Ironfox-OLEDDark](https://github.com/ArtikusHG/Ironfox-OLEDDark), which was archived after IronFox added its own OLED theme in v147.

## Why this still exists

Since v147, IronFox has a built-in OLED option, but it only takes effect when you pick the dark theme manually. If the theme is set to **Follow device theme**, IronFox still uses the regular dark grey palette at night, not pure black.

This project patches the dark color resources directly, so the browser is pure black whenever it is dark, including when it follows the system theme.

## What gets patched

The build script decompiles the official IronFox APK, changes a handful of color values, and rebuilds it. Nothing else is modified.

- In `res/values-night/colors.xml`, the surface and background colors are set to `#000000`, and the secondary layer color is set to a near-black grey.
- In `PhotonColors.smali`, the default dark greys used by Firefox's Photon color palette are replaced with black and a very dark grey.

See [`build.sh`](build.sh) for the exact changes.

## Install

The easiest way to install and stay updated is [Obtainium](https://github.com/ImranR98/Obtainium): add this repository's URL, `https://github.com/xaver985/Ironfox-OLED`, as a new app.

You can also download `patched_signed.apk` manually from the [Releases](https://github.com/xaver985/Ironfox-OLED/releases) page.

Notes:

- Builds are for **arm64-v8a** devices only.
- The APK is signed with this project's own key, not IronFox's. Android won't install it over the official IronFox app, so uninstall IronFox first (export your bookmarks and settings beforehand if you need them).

## How the builds work

A GitHub Actions workflow runs once a day (00:00 UTC). It checks the IronFox F-Droid repository for a new version, and if one hasn't been built yet, it:

1. downloads the official APK from IronFox's GitLab releases,
2. applies the patch with [Apktool](https://github.com/iBotPeaches/Apktool),
3. aligns and signs the APK,
4. publishes a release tagged with the IronFox version, reusing IronFox's release notes.

## Why not build from source?

Building the whole browser from source just to change a few color values would take hours of CI time per release. Patching the official APK is fast and keeps the result as close to upstream as possible.

## Build it yourself

If you'd rather not trust my signing key, fork this repository and add your own secrets:

- `KEYSTORE`: your keystore file, base64-encoded
- `KEYSTORE_PASSPHRASE`: its password

To build locally, you need `curl`, `jq`, `wget`, Java, and `zipalign`, then run `./build.sh` and sign `patched_signed.apk` with `apksigner`.

## Credits

Original project and build script by [ArtikusHG](https://github.com/ArtikusHG), with contributions from the community. Thanks to the [IronFox](https://gitlab.com/ironfox-oss/IronFox) team for the browser itself.

## License

[MIT](LICENSE)
