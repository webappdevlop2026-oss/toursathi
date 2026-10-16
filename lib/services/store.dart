import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/demo_data.dart';
import '../data/models.dart';

/// অ্যাপের সব ডেটা ও সেটিংস — ফোনে সংরক্ষিত থাকে।
class AppStore extends ChangeNotifier {
  SharedPreferences? _prefs;

  List<Pandal> imported = [];
  List<Pandal> custom = [];
  List<PujaDay> schedule = List.of(defaultSchedule);
  List<String> tour = [];
  Set<String> visited = {};
  Set<String> favorites = {};
  List<BudgetItem> budget = [];
  String baseArea = areas.first.name;
  int modeIndex = 0;
  int radiusKm = 10;
  int people = 2;
  String dataSource = 'ডেমো ডেটা';

  /// ট্যাব বদলের জন্য (হোম থেকে অন্য ট্যাবে যাওয়া)
  final tab = ValueNotifier<int>(0);

  List<Pandal> get pandals => [...(imported.isNotEmpty ? imported : demoPandals), ...custom];
  bool get usingDemo => imported.isEmpty;
  Area get base => areaByName(baseArea);
  String get travelMode => travelModes[modeIndex].$3;

  Pandal? byId(String id) {
    for (final p in pandals) {
      if (p.id == id) return p;
    }
    return null;
  }

  List<Pandal> get tourPandals => [for (final id in tour) if (byId(id) != null) byId(id)!];

  double distanceFromBase(Pandal p) => distanceKm(base.lat, base.lng, p.lat, p.lng);

  Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      _prefs = p;
      imported = _list(p.getString('imported')).map(Pandal.fromJson).toList();
      custom = _list(p.getString('custom')).map(Pandal.fromJson).toList();
      final sch = _list(p.getString('schedule')).map(PujaDay.fromJson).toList();
      if (sch.isNotEmpty) schedule = sch;
      budget = _list(p.getString('budget')).map(BudgetItem.fromJson).toList();
      tour = p.getStringList('tour') ?? [];
      visited = (p.getStringList('visited') ?? []).toSet();
      favorites = (p.getStringList('favorites') ?? []).toSet();
      baseArea = p.getString('baseArea') ?? baseArea;
      modeIndex = (p.getInt('modeIndex') ?? 0).clamp(0, travelModes.length - 1).toInt();
      radiusKm = p.getInt('radiusKm') ?? 10;
      people = p.getInt('people') ?? 2;
      dataSource = p.getString('dataSource') ?? dataSource;
    } catch (e) {
      debugPrint('Store load error: $e');
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> _list(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final v = jsonDecode(raw);
      if (v is List) return v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {}
    return [];
  }

  Future<void> _save() async {
    final p = _prefs;
    if (p == null) return;
    await p.setString('imported', jsonEncode(imported.map((e) => e.toJson()).toList()));
    await p.setString('custom', jsonEncode(custom.map((e) => e.toJson()).toList()));
    await p.setString('schedule', jsonEncode(schedule.map((e) => e.toJson()).toList()));
    await p.setString('budget', jsonEncode(budget.map((e) => e.toJson()).toList()));
    await p.setStringList('tour', tour);
    await p.setStringList('visited', visited.toList());
    await p.setStringList('favorites', favorites.toList());
    await p.setString('baseArea', baseArea);
    await p.setInt('modeIndex', modeIndex);
    await p.setInt('radiusKm', radiusKm);
    await p.setInt('people', people);
    await p.setString('dataSource', dataSource);
  }

  void _changed() {
    notifyListeners();
    _save();
  }

  // ---------- ট্যুর ----------
  bool inTour(String id) => tour.contains(id);
  void toggleTour(String id) {
    inTour(id) ? tour.remove(id) : tour.add(id);
    _changed();
  }

  void reorderTour(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final id = tour.removeAt(oldIndex);
    tour.insert(newIndex, id);
    _changed();
  }

  /// নিকটতম-প্রতিবেশী পদ্ধতিতে রুট সাজানো (শুরু: বেস এলাকা)
  void optimizeTour() {
    final remaining = tourPandals.toList();
    final ordered = <Pandal>[];
    var lat = base.lat, lng = base.lng;
    while (remaining.isNotEmpty) {
      remaining.sort((a, b) =>
          distanceKm(lat, lng, a.lat, a.lng).compareTo(distanceKm(lat, lng, b.lat, b.lng)));
      final next = remaining.removeAt(0);
      ordered.add(next);
      lat = next.lat;
      lng = next.lng;
    }
    tour = ordered.map((e) => e.id).toList();
    _changed();
  }

  double get tourDistanceKm {
    var total = 0.0;
    var lat = base.lat, lng = base.lng;
    for (final p in tourPandals) {
      total += distanceKm(lat, lng, p.lat, p.lng);
      lat = p.lat;
      lng = p.lng;
    }
    return total;
  }

  void clearTour() {
    tour.clear();
    _changed();
  }

  void toggleVisited(String id) {
    visited.contains(id) ? visited.remove(id) : visited.add(id);
    _changed();
  }

  void toggleFavorite(String id) {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    _changed();
  }

  // ---------- সেটিংস ----------
  void setBaseArea(String a) {
    baseArea = a;
    _changed();
  }

  void setMode(int i) {
    modeIndex = i;
    _changed();
  }

  void setRadius(int r) {
    radiusKm = r;
    _changed();
  }

  void setPeople(int n) {
    people = n < 1 ? 1 : n;
    _changed();
  }

  // ---------- নিজের প্যান্ডেল ----------
  void addCustom(Pandal p) {
    custom.add(p);
    _changed();
  }

  void removeCustom(String id) {
    custom.removeWhere((e) => e.id == id);
    tour.remove(id);
    _changed();
  }

  // ---------- বাজেট ----------
  double get budgetTotal => budget.fold(0.0, (s, e) => s + e.amount);
  void addBudget(BudgetItem b) {
    budget.add(b);
    _changed();
  }

  void removeBudget(String id) {
    budget.removeWhere((e) => e.id == id);
    _changed();
  }

  // ---------- Admin ডেটা ইমপোর্ট ----------
  /// Admin প্যানেলের এক্সপোর্ট করা JSON গ্রহণ করে। সফল হলে প্যান্ডেলের সংখ্যা ফেরত দেয়।
  int importJson(String raw) {
    final data = jsonDecode(raw.trim());
    List rawPandals;
    List rawSchedule = const [];
    if (data is List) {
      rawPandals = data;
    } else if (data is Map) {
      rawPandals = (data['pandals'] as List?) ?? const [];
      rawSchedule = (data['schedule'] as List?) ?? const [];
    } else {
      throw const FormatException('JSON ফরম্যাট সঠিক নয়');
    }
    final list = rawPandals
        .whereType<Map>()
        .map((e) => Pandal.fromJson(Map<String, dynamic>.from(e)))
        .where((p) => p.lat != 0 && p.lng != 0)
        .toList();
    if (list.isEmpty) throw const FormatException('কোনো বৈধ প্যান্ডেল পাওয়া যায়নি (lat/lng দরকার)');
    imported = list;
    if (rawSchedule.isNotEmpty) {
      schedule = rawSchedule
          .whereType<Map>()
          .map((e) => PujaDay.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    dataSource = 'ইমপোর্ট করা ডেটা (${list.length}টি)';
    tour.removeWhere((id) => byId(id) == null);
    _changed();
    return list.length;
  }

  void resetToDemo() {
    imported = [];
    schedule = List.of(defaultSchedule);
    dataSource = 'ডেমো ডেটা';
    tour.removeWhere((id) => byId(id) == null);
    _changed();
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
    imported = [];
    custom = [];
    schedule = List.of(defaultSchedule);
    tour = [];
    visited = {};
    favorites = {};
    budget = [];
    baseArea = areas.first.name;
    modeIndex = 0;
    radiusKm = 10;
    people = 2;
    dataSource = 'ডেমো ডেটা';
    notifyListeners();
  }

  // ---------- পুজোর দিন ----------
  PujaDay? get todayOrNext {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sorted = schedule.toList()..sort((a, b) => a.date.compareTo(b.date));
    for (final d in sorted) {
      if (!d.date.isBefore(today)) return d;
    }
    return null;
  }
}

final store = AppStore();
