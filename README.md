# Шахтёр (Miner)

A dark-themed mines grid mobile game built with Flutter.

## Gameplay

- 5×5 grid, each cell hides: 💎 Diamond, 🪨 Iron, ⬛ Coal, or 💣 Mine
- Reveal cells to collect resources
- Hit a mine → lose the round (resources not awarded)
- **Cash Out** any time to keep what you've collected
- If you own a shield charge, the first mine per round is automatically defused

## Screens

| Screen | Description |
|--------|-------------|
| ⛏ Mine | Main game grid |
| 🏪 Shop | Spend resources on upgrades |
| 👤 Profile | Stats and nickname |

## Upgrades

| Upgrade | Effect |
|---------|--------|
| ⛏ Pickaxe (Lvl 1–5) | Increases diamond spawn chance by +10% per level |
| 🛡 Mine Shield | Each charge protects against one mine per round |
| ⚡ Reward Boost (x1–x3) | Multiplies all collected resources |

## Tech Stack

- **Flutter 3.22** + Dart 3
- **Riverpod** — state management
- **Hive** — local persistence
- **flutter_animate** — smooth cell-reveal animations
- **google_fonts** — Rajdhani typeface

## Data Persistence

All data is saved locally via Hive:
- Nickname, diamonds, iron, coal
- Pickaxe level, shield charges, multiplier
- Games played, best score, total score

Data survives app restarts automatically.

## CI/CD

On every push to `main`:

1. Reads version from `miner.txt`
2. Checks if the git tag `vX.X.X` already exists
3. If tag exists → skip (no duplicate builds)
4. If tag doesn't exist →
   - Runs `flutter analyze` + `flutter test`
   - Builds release APK (`--target-platform android-arm64`)
   - Creates git tag
   - Publishes a GitHub Release with the APK attached
   - Auto-generates a unique changelog each time

## Build Locally

```bash
flutter pub get
flutter run                         # debug on device/emulator
flutter build apk --release         # production APK
```

## Requirements

- Android 5.0+ (API 21), ARM64
- Flutter 3.22+
