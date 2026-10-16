# TourSathi (ট্যুরসাথী) 🛕

দুর্গাপুরের দুর্গাপূজা ও ভ্রমণ গাইড — **Android অ্যাপ (Flutter) + ওয়েবসাইট + Admin ডেটা ম্যানেজার**।

## অ্যাপের ফিচার
- **প্যান্ডেল তালিকা** — সার্চ, এলাকা ফিল্টার, দূরত্ব অনুযায়ী সাজানো, ব্যাসার্ধ ফিল্টার, পছন্দের তালিকা
- **প্যান্ডেল বিস্তারিত** — রুট, ট্যুরে যোগ, “দেখা হয়েছে” টিক, আশেপাশের খাবার/পার্কিং/এটিএম/শৌচালয়, WhatsApp শেয়ার
- **আমার পুজো ট্যুর** — টেনে ক্রম বদল, এক ক্লিকে কাছ-থেকে-দূরে সাজানো, অগ্রগতি, Google Maps-এ পুরো রুট, WhatsApp-এ শেয়ার
- **খাবার, হোটেল, পার্কিং, পেট্রোল পাম্প, এটিএম, হাসপাতাল** — বাছাই করা এলাকার কাছে Google Maps সার্চ
- **জরুরি নম্বর** (112, 100, 108, 101, 1091, 1098) — এক ট্যাপে কল
- **পুজোর সময়সূচি** — কাউন্টডাউন সহ
- **ট্যুর বাজেট** — খরচ লেখা ও জনপ্রতি হিসাব
- **নিজের প্যান্ডেল যোগ** এবং **Admin JSON ইমপোর্ট**
- সব ডেটা ফোনে সংরক্ষিত থাকে (shared_preferences) — অ্যাপ বন্ধ করলেও হারায় না

## ফোল্ডার
```
lib/
  main.dart                 অ্যাপ, থিম, নিচের ন্যাভিগেশন
  data/models.dart          মডেল, দূরত্ব, বাংলা সংখ্যা/তারিখ
  data/demo_data.dart       এলাকা, ডেমো প্যান্ডেল, সময়সূচি, ক্যাটাগরি
  services/store.dart       অ্যাপের স্টেট + ফোনে সংরক্ষণ + JSON ইমপোর্ট
  services/maps.dart        Google Maps / কল / WhatsApp লিংক
  screens/                  হোম, প্যান্ডেল, বিস্তারিত, ট্যুর, সময়সূচি, জরুরি, বাজেট, আরও
  widgets/                  স্লাইডার, প্যান্ডেল কার্ড
website/index.html          ল্যান্ডিং পেজ
admin/index.html            প্যান্ডেল ও সময়সূচি ম্যানেজার (JSON এক্সপোর্ট)
.github/workflows/          প্রতি push-এ অটো APK বিল্ড
```

## APK পাওয়ার সহজ উপায় (কম্পিউটারে Flutter ছাড়াই)
1. GitHub-এ repo-র **Actions** ট্যাবে যান → **Build Android APK**
2. সর্বশেষ সবুজ ✓ রানে ঢুকুন → নিচে **Artifacts → TourSathi-apk** ডাউনলোড করুন
3. zip খুলে `app-release.apk` ফোনে ইনস্টল করুন

## Windows-এ নিজে চালানো (PowerShell)
```powershell
cd D:\
git clone https://github.com/webappdevlop2026-oss/toursathi.git TourSathi
cd D:\TourSathi
flutter create --platforms=android --org in.digitalagencybychandandas --project-name toursathi .
flutter pub get
flutter run
```
APK বানাতে: `flutter build apk --release` → `build\app\outputs\flutter-apk\app-release.apk`

পরে আপডেট: `git pull; flutter pub get; flutter run`

## আসল প্যান্ডেলের তথ্য যোগ করা
1. `admin/index.html` ব্রাউজারে খুলুন
2. প্যান্ডেলের নাম, এলাকা, Google Maps থেকে কপি করা `lat, lng` দিন → সংরক্ষণ
3. **📋 JSON কপি** চাপুন
4. অ্যাপে **আরও → ডেটা ইমপোর্ট** → পেস্ট → ইমপোর্ট

> Admin প্যানেলে লগইন নেই, ডেটা শুধু সেই ব্রাউজারে থাকে — পাবলিক সার্ভারে রাখবেন না।

## ওয়েবসাইট হোস্টিং
`website/` ফোল্ডারটি Vercel / Netlify / GitHub Pages-এ সরাসরি ডিপ্লয় করা যায়।

## সীমাবদ্ধতা
- ডেমো প্যান্ডেলের নাম ও অবস্থান কাল্পনিক — আসল তালিকা Admin থেকে ইমপোর্ট করুন
- দূরত্ব সরলরেখায় আনুমানিক; GPS / লাইভ লোকেশন, লগইন, সার্ভার ডেটাবেস এখনো নেই
- পুজোর তিথি স্থানীয় পঞ্জিকার সঙ্গে মিলিয়ে নিন

---
তৈরি করেছে **[Digital Agency by Chandan Das](https://digitalagencybychandandas.in)**
