import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../services/maps.dart';
import '../services/store.dart';
import '../widgets/pandal_card.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('জরুরি সহায়তা'), backgroundColor: const Color(0xffb71c1c)),
      body: ListView(padding: const EdgeInsets.all(12), children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xffffebee), borderRadius: BorderRadius.circular(14)),
          child: const Text(
            'ভিড়ে কেউ হারিয়ে গেলে কাছের পুজো কমিটির অনুসন্ধান কেন্দ্র বা পুলিশ সহায়তা বুথে যোগাযোগ করুন। '
            'নম্বরে চাপ দিলেই ফোন ডায়াল হবে।',
            style: TextStyle(fontSize: 13),
          ),
        ),
        const SizedBox(height: 10),
        for (final e in emergencyNumbers)
          Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xffffcdd2),
                child: Icon(e.$4, color: const Color(0xffb71c1c)),
              ),
              title: Text('${e.$2} — ${e.$1}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(e.$3),
              trailing: const Icon(Icons.call, color: Colors.green),
              onTap: () async {
                final ok = await Links.call(e.$1);
                if (!ok && context.mounted) snack(context, 'ফোন ডায়ালার খোলা যায়নি');
              },
            ),
          ),
        const SectionTitle('কাছাকাছি খুঁজুন'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final n in const [
            ('থানা', Icons.local_police, 'police station'),
            ('হাসপাতাল', Icons.local_hospital, 'hospital'),
            ('ওষুধের দোকান', Icons.medication, 'pharmacy'),
            ('ব্লাড ব্যাংক', Icons.bloodtype, 'blood bank'),
          ])
            ActionChip(
              avatar: Icon(n.$2, size: 18),
              label: Text(n.$1),
              onPressed: () => Links.searchNear(n.$3, store.base),
            ),
        ]),
        const SizedBox(height: 16),
        Text('অবস্থান হিসেবে ধরা হচ্ছে: ${store.baseArea}, $appCity',
            style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
      ]),
    );
  }
}
