import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/demo_data.dart';
import '../services/maps.dart';
import '../services/store.dart';
import '../widgets/pandal_card.dart';
import 'add_pandal_screen.dart';
import 'budget_screen.dart';
import 'emergency_screen.dart';
import 'schedule_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  void _push(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  Future<void> _import(BuildContext context) async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ডেটা ইমপোর্ট'),
        content: SizedBox(
          width: 400,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Admin প্যানেল থেকে "JSON কপি করুন" চেপে এখানে পেস্ট করুন।', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 10),
            TextField(
              controller: ctrl,
              maxLines: 8,
              minLines: 5,
              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
              decoration: const InputDecoration(hintText: '{"pandals": [...]}'),
            ),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final data = await Clipboard.getData(Clipboard.kTextPlain);
              ctrl.text = data?.text ?? '';
            },
            child: const Text('পেস্ট'),
          ),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('বাতিল')),
          FilledButton(
            onPressed: () {
              try {
                final n = store.importJson(ctrl.text);
                Navigator.pop(ctx);
                snack(context, '${n}টি প্যান্ডেল ইমপোর্ট হয়েছে');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ইমপোর্ট ব্যর্থ: ${e is FormatException ? e.message : e}')),
                );
              }
            },
            child: const Text('ইমপোর্ট'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('আরও')),
        body: ListView(padding: const EdgeInsets.symmetric(vertical: 8), children: [
          const _Header('পরিষেবা'),
          _tile(Icons.calendar_month, 'পুজোর সময়সূচি', 'ষষ্ঠী থেকে দশমী', () => _push(context, const ScheduleScreen())),
          _tile(Icons.emergency, 'জরুরি নম্বর', 'পুলিশ, অ্যাম্বুলেন্স, হেল্পলাইন', () => _push(context, const EmergencyScreen())),
          _tile(Icons.account_balance_wallet, 'ট্যুর বাজেট', 'খরচ ও জনপ্রতি হিসাব', () => _push(context, const BudgetScreen())),
          _tile(Icons.add_location_alt, 'নিজের প্যান্ডেল যোগ', 'জানা প্যান্ডেল তালিকায় রাখুন', () => _push(context, const AddPandalScreen())),
          _tile(Icons.restaurant, 'কাছাকাছি খাবার', 'Google Maps-এ', () => Links.searchNear('restaurants', store.base)),
          _tile(Icons.hotel, 'কাছাকাছি হোটেল', 'Google Maps-এ', () => Links.searchNear('hotels', store.base)),
          const _Header('সেটিংস'),
          ListTile(
            leading: const Icon(Icons.my_location),
            title: const Text('শুরুর এলাকা'),
            trailing: DropdownButton<String>(
              value: store.baseArea,
              underline: const SizedBox(),
              items: [for (final a in areas) DropdownMenuItem(value: a.name, child: Text(a.name))],
              onChanged: (v) {
                if (v != null) store.setBaseArea(v);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.commute),
            title: const Text('যাতায়াতের মাধ্যম'),
            trailing: DropdownButton<int>(
              value: store.modeIndex,
              underline: const SizedBox(),
              items: [
                for (var i = 0; i < travelModes.length; i++)
                  DropdownMenuItem(value: i, child: Text(travelModes[i].$1)),
              ],
              onChanged: (v) => store.setMode(v ?? 0),
            ),
          ),
          const _Header('ডেটা'),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('বর্তমান ডেটা'),
            subtitle: Text('${store.dataSource} • নিজের যোগ করা: ${store.custom.length}টি'),
          ),
          _tile(Icons.download, 'ডেটা ইমপোর্ট (Admin JSON)', 'আসল প্যান্ডেল তালিকা ও তারিখ যোগ করুন', () => _import(context)),
          if (!store.usingDemo)
            _tile(Icons.restore, 'ডেমো ডেটায় ফিরুন', 'ইমপোর্ট করা তালিকা সরান', store.resetToDemo),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('সব ডেটা মুছুন', style: TextStyle(color: Colors.red)),
            subtitle: const Text('ট্যুর, বাজেট, নিজের প্যান্ডেল — সব'),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('সব ডেটা মুছবেন?'),
                  content: const Text('এটি আর ফেরানো যাবে না।'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('না')),
                    FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('মুছুন')),
                  ],
                ),
              );
              if (ok == true) await store.clearAll();
            },
          ),
          const _Header('অ্যাপ সম্পর্কে'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('TourSathi — ট্যুরসাথী'),
            subtitle: const Text('সংস্করণ ১.০.০ • দুর্গাপুর পুজো ও ভ্রমণ গাইড'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'TourSathi',
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(Icons.temple_hindu, color: Color(0xffc62828), size: 40),
              children: const [
                Text('প্যান্ডেল খোঁজা, পুজো ট্যুরের রুট, খাবার-হোটেল-পার্কিং ও জরুরি নম্বর — সব এক অ্যাপে।\n\n'
                    'ডেভেলপার: Digital Agency by Chandan Das'),
              ],
            ),
          ),
          _tile(Icons.language, 'ডেভেলপারের ওয়েবসাইট', 'digitalagencybychandandas.in',
              () => Links.web('https://digitalagencybychandandas.in')),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _tile(IconData icon, String title, String sub, VoidCallback onTap) => ListTile(
        leading: Icon(icon, color: const Color(0xffc62828)),
        title: Text(title),
        subtitle: Text(sub),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      );
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xffc62828))),
      );
}
