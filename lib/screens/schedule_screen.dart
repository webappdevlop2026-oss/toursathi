import 'package:flutter/material.dart';
import '../data/models.dart';
import '../services/store.dart';
import '../widgets/pandal_card.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final days = store.schedule.toList()..sort((a, b) => a.date.compareTo(b.date));
    final next = store.todayOrNext;
    return Scaffold(
      appBar: AppBar(title: const Text('পুজোর সময়সূচি')),
      body: ListView(padding: const EdgeInsets.all(12), children: [
        if (next != null)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xff5e35b1), Color(0xffc62828)]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(next.date == today ? 'আজ' : 'পরের দিন',
                  style: const TextStyle(color: Colors.white70)),
              Text(next.name, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
              Text(bnDate(next.date), style: const TextStyle(color: Color(0xffffd36b), fontSize: 16)),
              if (next.date != today)
                Text('আর ${bn(next.date.difference(today).inDays)} দিন বাকি',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ]),
          ),
        const SizedBox(height: 12),
        for (final d in days)
          Card(
            color: d.date == today ? const Color(0xfffff3e0) : Colors.white,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: d.date.isBefore(today) ? Colors.grey : const Color(0xffc62828),
                foregroundColor: Colors.white,
                child: Text(bn(d.date.day)),
              ),
              title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${bnDate(d.date)}${d.note.isEmpty ? '' : '\n${d.note}'}'),
              isThreeLine: d.note.isNotEmpty,
              trailing: d.date == today
                  ? const Chip(label: Text('আজ'))
                  : d.date.isBefore(today)
                      ? const Icon(Icons.check, color: Colors.grey)
                      : null,
            ),
          ),
        const DemoNotice('তিথির সঠিক সময় (অঞ্জলি, সন্ধিপুজো) স্থানীয় পঞ্জিকা বা পুজো কমিটির সঙ্গে মিলিয়ে নিন। '
            'Admin প্যানেল থেকে তারিখ আপডেট করা যায়।'),
      ]),
    );
  }
}
