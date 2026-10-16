import 'package:flutter/material.dart';
import 'models.dart';

const appCity = 'দুর্গাপুর';
const appCityEn = 'Durgapur, West Bengal';

/// এলাকার কেন্দ্রবিন্দু — আনুমানিক, শুধু দূরত্ব হিসাবের জন্য।
const areas = <Area>[
  Area('সিটি সেন্টার', 23.5383, 87.2913),
  Area('বেনাচিতি', 23.5500, 87.2990),
  Area('বিধাননগর', 23.5180, 87.3200),
  Area('এ-জোন', 23.5460, 87.3150),
  Area('বি-জোন', 23.5390, 87.3320),
  Area('মুচিপাড়া', 23.5080, 87.3650),
  Area('দুর্গাপুর স্টেশন', 23.4930, 87.3110),
];

Area areaByName(String name) =>
    areas.firstWhere((a) => a.name == name, orElse: () => areas.first);

/// ডেমো প্যান্ডেল — নাম ও অবস্থান কাল্পনিক/আনুমানিক।
/// আসল তথ্য Admin প্যানেল থেকে JSON এক্সপোর্ট করে অ্যাপে ইমপোর্ট করুন।
const demoPandals = <Pandal>[
  Pandal(id: 'd1', name: 'ডেমো প্যান্ডেল — সিটি সেন্টার', area: 'সিটি সেন্টার', lat: 23.5400, lng: 87.2890, theme: 'আলোকসজ্জা', description: 'শহরের কেন্দ্রে বড় মণ্ডপ (ডেমো তথ্য)।'),
  Pandal(id: 'd2', name: 'ডেমো প্যান্ডেল — বেনাচিতি বাজার', area: 'বেনাচিতি', lat: 23.5520, lng: 87.2970, theme: 'সাবেকি প্রতিমা', description: 'বাজার এলাকার পুরোনো পুজো (ডেমো তথ্য)।'),
  Pandal(id: 'd3', name: 'ডেমো প্যান্ডেল — বিধাননগর', area: 'বিধাননগর', lat: 23.5220, lng: 87.3120, theme: 'থিম পুজো', description: 'আবাসিক এলাকার থিম মণ্ডপ (ডেমো তথ্য)।'),
  Pandal(id: 'd4', name: 'ডেমো প্যান্ডেল — এ-জোন', area: 'এ-জোন', lat: 23.5470, lng: 87.3160, theme: 'শিল্পকর্ম', description: 'হস্তশিল্পে সাজানো মণ্ডপ (ডেমো তথ্য)।'),
  Pandal(id: 'd5', name: 'ডেমো প্যান্ডেল — বি-জোন', area: 'বি-জোন', lat: 23.5385, lng: 87.3340, theme: 'পরিবেশবান্ধব', description: 'প্রাকৃতিক উপকরণে তৈরি (ডেমো তথ্য)।'),
  Pandal(id: 'd6', name: 'ডেমো প্যান্ডেল — মুচিপাড়া', area: 'মুচিপাড়া', lat: 23.5090, lng: 87.3630, theme: 'লোকশিল্প', description: 'গ্রামবাংলার থিম (ডেমো তথ্য)।'),
  Pandal(id: 'd7', name: 'ডেমো প্যান্ডেল — স্টেশন রোড', area: 'দুর্গাপুর স্টেশন', lat: 23.4950, lng: 87.3100, theme: 'ঐতিহ্য', description: 'স্টেশনের কাছে (ডেমো তথ্য)।'),
  Pandal(id: 'd8', name: 'ডেমো প্যান্ডেল — সিটি সেন্টার পার্ক', area: 'সিটি সেন্টার', lat: 23.5360, lng: 87.2950, theme: 'শিশুদের আকর্ষণ', description: 'মেলা ও খাবারের স্টল (ডেমো তথ্য)।'),
];

/// দুর্গাপূজা ২০২৬ — স্থানীয় পঞ্জিকার সঙ্গে মিলিয়ে নিন। Admin থেকে বদলানো যায়।
final defaultSchedule = <PujaDay>[
  PujaDay('মহাষষ্ঠী', DateTime(2026, 10, 16), 'বোধন ও আমন্ত্রণ'),
  PujaDay('মহাসপ্তমী', DateTime(2026, 10, 18), 'নবপত্রিকা স্নান'),
  PujaDay('মহাষ্টমী', DateTime(2026, 10, 19), 'অঞ্জলি ও সন্ধিপুজো'),
  PujaDay('মহানবমী', DateTime(2026, 10, 20), 'নবমী পুজো ও ভোগ'),
  PujaDay('বিজয়া দশমী', DateTime(2026, 10, 21), 'সিঁদুর খেলা ও বিসর্জন'),
];

/// হোম স্ক্রিনের ক্যাটাগরি। action: tab:<i> | maps:<query> | screen:<name>
class Category {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color bg;
  final Color fg;
  final String action;
  const Category(this.icon, this.title, this.subtitle, this.bg, this.fg, this.action);
}

const categories = <Category>[
  Category(Icons.temple_hindu, 'সব প্যান্ডেল', 'শহর ও এলাকা', Color(0xffffe0b3), Color(0xffc62828), 'tab:1'),
  Category(Icons.route, 'প্যান্ডেল হপিং', 'রুট প্ল্যান', Color(0xffffd9df), Color(0xffd81b60), 'tab:2'),
  Category(Icons.restaurant, 'খাবার', 'কাছাকাছি রেস্তোরাঁ', Color(0xffe4d7ff), Color(0xff5e35b1), 'maps:restaurants'),
  Category(Icons.hotel, 'হোটেল', 'থাকার ব্যবস্থা', Color(0xffd0eefd), Color(0xff1565c0), 'maps:hotels'),
  Category(Icons.local_parking, 'পার্কিং', 'নিকটবর্তী পার্কিং', Color(0xffe6f1cc), Color(0xff2e7d32), 'maps:parking'),
  Category(Icons.local_atm, 'এটিএম', 'টাকা তোলা', Color(0xfffff3c4), Color(0xffef6c00), 'maps:ATM'),
  Category(Icons.local_gas_station, 'পেট্রোল পাম্প', 'জ্বালানি ও গ্যারেজ', Color(0xffffe5c3), Color(0xffe65100), 'maps:petrol pump'),
  Category(Icons.wc, 'শৌচালয়', 'পাবলিক টয়লেট', Color(0xffe0f2f1), Color(0xff00695c), 'maps:public toilet'),
  Category(Icons.local_hospital, 'হাসপাতাল', 'চিকিৎসা', Color(0xffdbecff), Color(0xff1565c0), 'maps:hospital'),
  Category(Icons.emergency, 'জরুরি নম্বর', 'পুলিশ, অ্যাম্বুলেন্স', Color(0xffffdada), Color(0xffc62828), 'screen:emergency'),
  Category(Icons.calendar_month, 'পুজোর সময়সূচি', 'তিথি ও দিন', Color(0xffeadcff), Color(0xff5e35b1), 'screen:schedule'),
  Category(Icons.account_balance_wallet, 'ট্যুর বাজেট', 'খরচের হিসাব', Color(0xffdef9d2), Color(0xff2e7d32), 'screen:budget'),
];

/// গাড়ির ধরন → Google Maps travelmode
const travelModes = <(String, IconData, String)>[
  ('গাড়ি', Icons.directions_car, 'driving'),
  ('বাইক', Icons.two_wheeler, 'driving'),
  ('বাস/ট্রেন', Icons.directions_bus, 'transit'),
  ('হেঁটে', Icons.directions_walk, 'walking'),
];

const emergencyNumbers = <(String, String, String, IconData)>[
  ('112', 'জাতীয় জরুরি নম্বর', 'সব ধরনের জরুরি অবস্থায়', Icons.emergency),
  ('100', 'পুলিশ', 'আইনশৃঙ্খলা ও নিরাপত্তা', Icons.local_police),
  ('108', 'অ্যাম্বুলেন্স', 'চিকিৎসা জরুরি', Icons.medical_services),
  ('101', 'দমকল', 'অগ্নিকাণ্ড', Icons.fire_truck),
  ('1091', 'মহিলা হেল্পলাইন', 'মহিলাদের নিরাপত্তা', Icons.woman),
  ('1098', 'চাইল্ড হেল্পলাইন', 'হারানো / বিপদগ্রস্ত শিশু', Icons.child_care),
];
