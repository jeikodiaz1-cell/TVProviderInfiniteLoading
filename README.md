# TV Provider Infinite Loading — RootHide

Tweak for iOS 16 / RootHide that targets **Settings.app** and attempts to keep
the activity indicator on the **TV Provider / Video Subscriber** screen from
being stopped or hidden.

## Target

- iOS 16.x
- RootHide / ElleKit
- `iphoneos-arm64e`
- Settings.app (`com.apple.Preferences`)

## Build

The included GitHub Actions workflow installs RootHide Theos, obtains an
iPhoneOS 16.5 SDK, and builds a RootHide package:

```sh
make clean package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=roothide
```

The resulting `.deb` is uploaded as a workflow artifact.

## Important

The exact private class names used by TV Provider vary between iOS releases.
This first version deliberately uses context detection (controller class/title/
accessibility text) rather than hard-coding one private class.

If the spinner does not stay active on iOS 16.3.1, the next revision should
instrument Settings while opening `prefs-tvprovider://` and identify the exact
private controller/view used by that build.
