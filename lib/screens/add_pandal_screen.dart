import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../data/models.dart';
import '../services/store.dart';
import '../widgets/pandal_card.dart';

/// ব্যবহারকারী নিজের জানা প্যান্ডেল যোগ করতে পারেন (শুধু এই ফোনে থাকে)।
class AddPandalScreen extends StatefulWidget {
  const AddPandalScreen({super.key});

  @override
  State<AddPandalScreen> createState() => _AddPandalScreenState();
}

class _AddPandalScreenState extends State<AddPandalScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final theme = TextEditingController();
  final desc = TextEditingController();
  final coords = TextEditingController();
  String area = areas.first.name;

  @override
  void dispose() {
    name.dispose();
    theme.dispose();
    desc.dispose();
    coords.dispose();
    super.dispose();
  }

  (double, double)? _parseCoords(String s) {
    final parts = s.split(RegExp(r'[,\s]+')).where((e) => e.isNotEmpty).toList();
    if (parts.length != 2) return null;
    final lat = double.tryParse(parts[0]);
    final lng = double.tryParse(parts[1]);
    if (lat == null || lng == null || lat.abs() > 90 || lng.abs() > 180) return null;
    return (lat, lng);
  }

  void _save() {
    if (!form.currentState!.validate()) return;
    final a = areaByName(area);
    final c = coords.text.trim().isEmpty ? (a.lat, a.lng) : _parseCoords(coords.text.trim())!;
    store.addCustom(Pandal(
      id: 'u${DateTime.now().microsecondsSinceEpoch}',
      name: name.text.trim(),
      area: area,
      lat: c.$1,
      lng: c.$2,
      theme: theme.text.trim(),
      description: desc.text.trim(),
      userAdded: true,
    ));
    snack(context, 'প্যান্ডেল যোগ হয়েছে');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('নতুন প্যান্ডেল যোগ')),
      body: Form(
        key: form,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          TextFormField(
            controller: name,
            decoration: const InputDecoration(labelText: 'প্যান্ডেলের নাম *'),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'নাম লিখুন' : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: area,
            decoration: const InputDecoration(labelText: 'এলাকা'),
            items: [for (final a in areas) DropdownMenuItem(value: a.name, child: Text(a.name))],
            onChanged: (v) => setState(() => area = v ?? area),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: coords,
            decoration: const InputDecoration(
              labelText: 'লোকেশন (ঐচ্ছিক) — lat, lng',
              hintText: 'যেমন: 23.5400, 87.2890',
              helperText: 'Google Maps-এ জায়গায় লম্বা চাপ দিলে সংখ্যাটি পাবেন। খালি রাখলে এলাকার কেন্দ্র ধরা হবে।',
              helperMaxLines: 3,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty || _parseCoords(v.trim()) != null) ? null : 'সঠিক ফরম্যাট: 23.54, 87.28',
          ),
          const SizedBox(height: 12),
          TextFormField(controller: theme, decoration: const InputDecoration(labelText: 'থিম (ঐচ্ছিক)')),
          const SizedBox(height: 12),
          TextFormField(
            controller: desc,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'বিবরণ (ঐচ্ছিক)'),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            style: FilledButton.styleFrom(padding: const EdgeInsets.all(14)),
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('সংরক্ষণ করুন'),
          ),
        ]),
      ),
    );
  }
}
