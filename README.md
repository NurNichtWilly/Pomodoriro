# Pomodoriro

Pomodoriro is a simple, elegant Pomodoro timer application for macOS, built with SwiftUI.

<img src="appicon/Gemini_Generated_Image_t0ohxct0ohxct0oh Background Removed.png" width="128" height="128" />

## Features

*   **Customizable Timer**: Work and break intervals.
*   **Menu Bar Support**: View timer status and control it directly from the menu bar.
*   **Full Screen Mode**: Focus on your work with a distraction-free full screen view.
*   **Release Packaging**: Automated scripts to build `.app` bundles and `.dmg` installers.

## Installation

1.  Download the latest release from the `releases` folder (or GitHub releases if published).
2.  Open `Pomodoriro.dmg`.
3.  Drag `Pomodoriro` to your Applications folder.

## Development

This project uses the Swift Package Manager.

### Prerequisites

*   macOS 13.0 or later
*   Xcode 14.0 or later (for Swift 5.7+)

### Building Locally

```bash
swift build
```

### Running

```bash
swift run Pomodoriro
```

### Creating a Release

To create a distributable `.dmg` with the custom icon:

```bash
./package_release.sh
```

This will output:
*   `releases/Pomodoriro.app`
*   `releases/Pomodoriro.dmg`

## License

MIT
