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

/// হোম স্ক্রিনের ক্যাটাগরি (assets/category_icons-এর ছবি)।
/// action: tab:<i> | maps:<query> | screen:<name> | share:tour
class Category {
  final String asset;
  final String title;
  final String action;
  const Category(this.asset, this.title, this.action);
}

const _icon = 'assets/category_icons/';

const categories = <Category>[
  Category('${_icon}pandal.png', 'প্যান্ডেল', 'tab:1'),
  Category('${_icon}route_distance.png', 'রুট ও দূরত্ব', 'tab:1'),
  Category('${_icon}my_plan.png', 'আমার প্ল্যান', 'tab:2'),
  Category('${_icon}food_restaurants.png', 'খাবার ও রেস্তোরাঁ', 'maps:restaurants'),
  Category('${_icon}hotels.png', 'হোটেল ও থাকার ব্যবস্থা', 'maps:hotels'),
  Category('${_icon}parking.png', 'পার্কিং', 'maps:parking'),
  Category('${_icon}temples.png', 'মন্দির দর্শন', 'maps:temple'),
  Category('${_icon}tourist_places.png', 'দর্শনীয় স্থান', 'maps:tourist attractions'),
  Category('${_icon}group_ride.png', 'গ্রুপ রাইড', 'share:tour'),
  Category('${_icon}puja_schedule.png', 'পুজোর সময়সূচি', 'screen:schedule'),
  Category('${_icon}emergency.png', 'জরুরি পরিষেবা', 'screen:emergency'),
  Category('${_icon}more.png', 'আরও', 'tab:3'),
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
