import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const TourSathiApp());

class Pandal {
  final String name, locality, description;
  final double latitude, longitude;
  const Pandal(this.name, this.locality, this.description, this.latitude, this.longitude);
}

// Demo locations only. Confirm actual pandal coordinates before public launch.
const pandals = <Pandal>[
  Pandal('ডেমো প্যান্ডেল ১', 'সিটি সেন্টার, দুর্গাপুর', 'এখানে যাচাই করা প্যান্ডেল তথ্য যুক্ত হবে।', 23.5400, 87.2890),
  Pandal('ডেমো প্যান্ডেল ২', 'বেনাচিতি, দুর্গাপুর', 'ছবি, সময়, দর্শনার্থী তথ্য ও রুট যুক্ত হবে।', 23.5580, 87.2840),
  Pandal('ডেমো প্যান্ডেল ৩', 'বিধাননগর, দুর্গাপুর', 'এটি পরীক্ষামূলক তালিকা, বাস্তব প্যান্ডেল নয়।', 23.5220, 87.3120),
];

class TourSathiApp extends StatelessWidget {
  const TourSathiApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'TourSathi', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xfff52245), scaffoldBackgroundColor: const Color(0xfffff9f2)),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int selected = 0;
  String search = '';
  Future<void> openRoute(Pandal p) async {
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${p.latitude},${p.longitude}&travelmode=driving');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ম্যাপ খোলা যাচ্ছে না')));
    }
  }
  @override Widget build(BuildContext context) {
    final shown = pandals.where((p) => (p.name + p.locality).contains(search)).toList();
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xff101c46), foregroundColor: Colors.white,
        title: const Text('📍 দুর্গাপুর, পশ্চিমবঙ্গ'), actions: [
          IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('নোটিফিকেশন শীঘ্রই যুক্ত হবে'))), icon: const Icon(Icons.notifications_outlined)),
        ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(23), decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(colors: [Color(0xff0c163a), Color(0xffe32935)])),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('শুভ দুর্গাপূজা 🌺', style: TextStyle(color: Color(0xffffcf52), fontSize: 34, fontWeight: FontWeight.bold)),
            SizedBox(height: 7), Text('ঠাকুর দেখুন • ঘুরুন • খান • থাকুন', style: TextStyle(color: Colors.white, fontSize: 17)),
            SizedBox(height: 16), Text('সব এক অ্যাপে — TourSathi', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ]),
        ),
        const SizedBox(height: 18),
        TextField(onChanged: (v) => setState(() => search = v.trim()), decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search), hintText: 'প্যান্ডেল বা এলাকা খুঁজুন',
          filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
        const SizedBox(height: 18),
        Wrap(spacing: 10, runSpacing: 10, children: [
          _category(Icons.temple_hindu, 'সব প্যান্ডেল'),
          _category(Icons.route, 'প্যান্ডেল হপিং'),
          _category(Icons.restaurant, 'খাবার'),
          _category(Icons.hotel, 'হোটেল'),
          _category(Icons.local_parking, 'পার্কিং'),
          _category(Icons.group, 'গ্রুপ ট্যুর'),
          _category(Icons.map, 'মন্দির দর্শন'),
          _category(Icons.local_hospital, 'জরুরি পরিষেবা'),
        ]),
        const SizedBox(height: 22),
        const Text('দুর্গাপুরের প্যান্ডেল', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        const Text('ডেমো তালিকা — আসল প্যান্ডেল ও রুট যাচাই করে যোগ করতে হবে', style: TextStyle(color: Colors.deepOrange)),
        const SizedBox(height: 8),
        ...shown.map((p) => Card(color: Colors.white, child: ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xffffd9a1), child: Icon(Icons.temple_hindu, color: Color(0xffce263f))),
          title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${p.locality}\n${p.description}'),
          isThreeLine: true,
          trailing: IconButton(tooltip: 'ম্যাপে রুট', icon: const Icon(Icons.directions, color: Colors.blue), onPressed: () => openRoute(p)),
        ))),
        const SizedBox(height: 18),
        FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('লাইভ GPS ও মাল্টি-স্টপ রুট পরবর্তী ধাপে যুক্ত হবে'))),
          icon: const Icon(Icons.route), label: const Text('আমার পুজো ট্যুর তৈরি করুন')),
      ]),
      bottomNavigationBar: NavigationBar(selectedIndex: selected, onDestinationSelected: (i) {
        setState(() => selected = i);
        if (i != 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('এই বিভাগটি পরবর্তী আপডেটে আসবে')));
      }, destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'হোম'),
        NavigationDestination(icon: Icon(Icons.temple_hindu_outlined), label: 'প্যান্ডেল'),
        NavigationDestination(icon: Icon(Icons.route_outlined), label: 'রুট'),
        NavigationDestination(icon: Icon(Icons.person_outline), label: 'প্রোফাইল'),
      ]),
    );
  }
  Widget _category(IconData icon, String title) => SizedBox(width: 150, child: Card(color: Colors.white, child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
    child: Column(children: [Icon(icon, color: const Color(0xfff52245), size: 29), const SizedBox(height: 6), Text(title, textAlign: TextAlign.center)]))));
}
