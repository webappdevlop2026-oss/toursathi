# TourSathi (ট্যুরসাথী)

Durgapur-first Android + website + admin demo. **Not production ready.**

## Android run on Windows PowerShell
Prerequisite: Flutter SDK, Android SDK, USB debugging or Android emulator, Git.

```powershell
cd D:\
git clone https://github.com/webappdevlop2026-oss/toursathi.git TourSathi
cd D:\TourSathi
flutter create --platforms=android .
flutter pub get
flutter devices
flutter run
```

For subsequent pulls, use `cd D:\TourSathi; git pull; flutter run`.

## Website and admin
Open `website/index.html` and `admin/index.html` locally in browser.
Admin is **unsecured UI prototype**, not for public deployment; additions are not persisted.
Backend/database, verified pandal addresses, media assets, authentication, live GPS, notifications, group sharing, transport booking and production infrastructure are **not implemented**.

Demo points are illustrative; do not assume they are real pandals.
