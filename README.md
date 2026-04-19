<p align="center">
  <img src="miner.jpg" width="160" style="border-radius: 24px" /><br/>
  <b>⛏ Шахтёр</b>
</p>


> Tap. Mine. Survive. Upgrade.

A dark-themed mobile mining game built with Flutter for Android.

---

## 🎮 About the Game

**Шахтёр** is a mines grid game where every tap is a risk.  
Each round you face a 5×5 hidden field. Behind every cell could be a diamond — or a bomb.  
Collect resources, build your base, upgrade your gear, and become the ultimate miner.

---

## 🕹 How to Play

1. Press **НАЧАТЬ ДОБЫЧУ** to start a new round
2. Tap cells to reveal what's hidden inside:
   - 💎 **Diamond** — rare, high value
   - 🪨 **Iron** — common metal
   - ⬛ **Coal** — most common resource
   - 💣 **Mine** — game over for the round
3. Press **ЗАБРАТЬ РЕСУРСЫ** at any time to keep what you've found
4. Hit a mine → lose all resources collected that round
5. Own a 🛡 **Shield**? It automatically defuses the first mine you hit

---

## ⛏ Upgrades (Shop)

Spend your resources to get stronger:

| Upgrade | Effect |
|---|---|
| ⛏ Pickaxe (Lvl 1–5) | Increases diamond spawn chance up to +50% |
| 🛡 Mine Shield | Each charge survives one mine hit per round |
| ⚡ Reward Boost (×1–×3) | Multiplies all collected resources |

---

## 🏭 Base (Passive Income)

Buy a base for **500 💎** and put your miners to work while you're away:

- Each upgrade adds **+1 worker**
- Workers produce random resources **every hour**
- Storage holds up to **12 hours** of production — collect before it overflows
- Infinite upgrade levels — costs scale exponentially
- Level names: Землянка → Сарай → Мастерская → Цех → Завод → Комбинат → Корпорация → ...

---

## 📋 Daily Quests

Three new quests every day at **10:00 Moscow time**:

- Collect X diamonds / iron / coal
- Play X games
- Survive X rounds without exploding
- Cash out X times

Miss them → they burn and refresh the next day.  
Complete them → claim random resource rewards.

---

## 👤 Profile

- Set your miner nickname on first launch
- Track your stats: games played, best round score, total score, mines defused
- View your current upgrades and resource stockpile

---

## 💥 Features

- Animated cell reveals with elastic pop
- Full-screen explosion animation when you hit a mine
- 3-second cooldown between rounds (no spamming)
- Glow effects on diamonds, mines, and active upgrades
- Gradient dark UI with glass-morphism cards
- Portrait-only, smooth 60fps

---

## 💾 Data

Everything is saved locally — nickname, resources, upgrades, base level, quest progress.  
Close the app, come back later — nothing is lost.

---

## 📦 Install

Download the latest APK from [Releases](../../releases) and install on Android 5.0+.

> Enable **Install from unknown sources** in your Android settings before installing.

---

## 🔨 Build Locally

```bash
flutter pub get
dart run flutter_launcher_icons
flutter run                      # debug on device
flutter build apk --release      # production APK
```

**Requirements:** Flutter 3.22+, Android 5.0+ (API 21), ARM64

---

## ⚙️ CI/CD

On every push to `main`:
- Reads version from `miner.txt`
- Skips build if tag `vX.X.X` already exists
- Runs `flutter analyze` + `flutter test`
- Builds release APK signed with a consistent keystore
- Creates a Git tag and publishes a GitHub Release with the APK attached
- Auto-generates a unique release description each time

---

*Made with Flutter 💙*
