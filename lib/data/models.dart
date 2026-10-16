import 'dart:math' as math;

/// একটি প্যান্ডেল / দর্শনীয় স্থান।
class Pandal {
  final String id;
  final String name;
  final String area;
  final double lat;
  final double lng;
  final String description;
  final String theme;
  final String imageUrl;
  final bool verified;
  final bool userAdded;

  const Pandal({
    required this.id,
    required this.name,
    required this.area,
    required this.lat,
    required this.lng,
    this.description = '',
    this.theme = '',
    this.imageUrl = '',
    this.verified = false,
    this.userAdded = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'area': area,
        'lat': lat,
        'lng': lng,
        'description': description,
        'theme': theme,
        'imageUrl': imageUrl,
        'verified': verified,
        'userAdded': userAdded,
      };

  factory Pandal.fromJson(Map<String, dynamic> j) => Pandal(
        id: (j['id'] ?? DateTime.now().microsecondsSinceEpoch).toString(),
        name: (j['name'] ?? 'নামহীন').toString(),
        area: (j['area'] ?? '').toString(),
        lat: _toDouble(j['lat']),
        lng: _toDouble(j['lng']),
        description: (j['description'] ?? '').toString(),
        theme: (j['theme'] ?? '').toString(),
        imageUrl: (j['imageUrl'] ?? '').toString(),
        verified: j['verified'] == true,
        userAdded: j['userAdded'] == true,
      );
}

/// পুজোর একটি দিন।
class PujaDay {
  final String name;
  final DateTime date;
  final String note;
  const PujaDay(this.name, this.date, [this.note = '']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'date':
            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'note': note,
      };

  factory PujaDay.fromJson(Map<String, dynamic> j) => PujaDay(
        (j['name'] ?? '').toString(),
        DateTime.tryParse((j['date'] ?? '').toString()) ?? DateTime.now(),
        (j['note'] ?? '').toString(),
      );
}

/// বাজেটের একটি খরচ।
class BudgetItem {
  final String id;
  final String title;
  final double amount;
  final String category;
  const BudgetItem(this.id, this.title, this.amount, this.category);

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'amount': amount, 'category': category};

  factory BudgetItem.fromJson(Map<String, dynamic> j) => BudgetItem(
        (j['id'] ?? '').toString(),
        (j['title'] ?? '').toString(),
        _toDouble(j['amount']),
        (j['category'] ?? 'অন্যান্য').toString(),
      );
}

/// এলাকার কেন্দ্র (আনুমানিক)।
class Area {
  final String name;
  final double lat;
  final double lng;
  const Area(this.name, this.lat, this.lng);
}

double _toDouble(dynamic v) {
  if (v is num) return v.toDouble();
  return double.tryParse(v?.toString() ?? '') ?? 0;
}

/// দুই বিন্দুর সরলরেখা দূরত্ব (কিমি)।
double distanceKm(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1);
  final dLng = rad(lng2 - lng1);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(rad(lat1)) *
          math.cos(rad(lat2)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

String formatKm(double km) =>
    km < 1 ? '${(km * 1000).round()} মি' : '${km.toStringAsFixed(1)} কিমি';

const bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
String bn(Object n) =>
    n.toString().split('').map((c) {
      final i = int.tryParse(c);
      return i == null ? c : bnDigits[i];
    }).join();

const bnMonths = [
  'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
  'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
];
const bnWeekdays = ['সোমবার', 'মঙ্গলবার', 'বুধবার', 'বৃহস্পতিবার', 'শুক্রবার', 'শনিবার', 'রবিবার'];

String bnDate(DateTime d) =>
    '${bn(d.day)} ${bnMonths[d.month - 1]}, ${bnWeekdays[d.weekday - 1]}';
