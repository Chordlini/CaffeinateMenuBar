# CaffeinateMenuBar

A minimal, beautiful macOS menu bar app that prevents your Mac from sleeping with a single click. No windows, no menus, no fuss — just a coffee cup in your menu bar.

<p align="center">
  <img src="Assets/logo.png" width="128" alt="CaffeinateMenuBar Logo">
</p>

## Features

- **One-Click Toggle** — Click the cup to keep your Mac awake. Click again to let it sleep.
- **Animated Steam** — When active, steam rises from the cup in your macOS Accent Color (blue, orange, green, purple, yellow, red, or graphite).
- **Zero UI Chrome** — No dock icon, no dropdown menus, no preferences window. It just lives in the menu bar.
- **App Store Safe** — Uses IOKit's `IOPMAssertionCreateWithName` (the Apple-approved way to prevent idle sleep), not the shell `caffeinate` command.
- **Auto-Start** — Automatically registers as a login item so it starts with your Mac.
- **Remembers State** — If it was ON when you logged out, it'll be ON when you log back in.

## Screenshots

| Off | On (Accent Color) |
|-----|-------------------|
| <img src="Assets/preview_off_88.png" width="88"> | <img src="Assets/preview_on_88.png" width="88"> |

## Requirements

- macOS 13.0 (Ventura) or later
- Apple Silicon or Intel Mac

## Installation

### Option 1: Download & Run (Current)
1. Open `CaffeinateMenuBar.app`
2. Look for the coffee cup in your menu bar

### Option 2: Build from Source
```bash
cd ~/CaffeinateMenuBar/src
swiftc -framework Cocoa -framework IOKit *.swift -o ../CaffeinateMenuBar.app/Contents/MacOS/CaffeinateMenuBar
codesign --force --deep --sign - ../CaffeinateMenuBar.app
open ../CaffeinateMenuBar.app
```

### Auto-Start Setup
The app self-registers as a login item on first launch via `SMAppService`.  
If you used the LaunchAgent plist during setup, it is located at:
```
~/Library/LaunchAgents/com.rami.CaffeinateMenuBar.plist
```

To disable auto-start:
```bash
launchctl unload ~/Library/LaunchAgents/com.rami.CaffeinateMenuBar.plist
rm ~/Library/LaunchAgents/com.rami.CaffeinateMenuBar.plist
```

## Usage

| Action | Result |
|--------|--------|
| **Click** the cup | Toggle sleep prevention ON / OFF |
| **Steam visible** | Mac will not idle-sleep |
| **No steam** | Mac sleeps normally |

## Architecture

```
CaffeinateMenuBar/
├── CaffeinateMenuBar.app/          # Compiled app bundle
│   ├── Contents/MacOS/             # Binary
│   └── Contents/Info.plist         # LSUIElement = true (no dock icon)
├── src/
│   ├── main.swift                  # NSApplication bootstrap + SMAppService
│   ├── StatusBarController.swift   # NSStatusItem, click toggle, animation timer
│   ├── CaffeinateManager.swift     # IOKit sleep assertion wrapper
│   └── IconRenderer.swift          # Core Graphics cup + steam generator
├── entitlements.plist              # App Sandbox
└── README.md
```

## How It Works

1. **StatusBarController** creates an `NSStatusItem` in the system menu bar.
2. Clicking the status button toggles a boolean state.
3. When **ON**, `CaffeinateManager` creates an IOKit `NoIdleSleepAssertion` — this is the same mechanism the `caffeinate` CLI uses, but called directly via API.
4. Simultaneously, a 15fps `Timer` drives the steam animation. Each frame calls `IconRenderer`, which draws a coffee cup + 3 rising steam wisps tinted to `NSColor.controlAccentColor`.
5. When **OFF**, the assertion is released and the timer stops, returning to a static cup.

## App Store Notes

- Uses App Sandbox (`com.apple.security.app-sandbox`)
- No prohibited APIs (no `NSTask`, no `caffeinate` binary calls)
- Ready for code signing with your Apple Developer Team ID

## License

MIT
