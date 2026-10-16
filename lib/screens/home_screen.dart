import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../data/models.dart';
import '../services/maps.dart';
import '../services/store.dart';
import '../widgets/festival_slider.dart';
import '../widgets/pandal_card.dart';
import 'budget_screen.dart';
import 'emergency_screen.dart';
import 'schedule_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Future<void> runAction(BuildContext context, String action) async {
    final parts = action.split(':');
    final kind = parts.first;
    final value = parts.sublist(1).join(':');
    switch (kind) {
      case 'tab':
        store.tab.value = int.parse(value);
        return;
      case 'maps':
        final ok = await Links.searchNear(value, store.base);
        if (!ok && context.mounted) snack(context, 'Google Maps খোলা যায়নি');
        return;
      case 'share':
        if (store.tour.isEmpty) {
          store.tab.value = 2;
          snack(context, 'আগে প্যান্ডেল বেছে ট্যুর তৈরি করুন, তারপর বন্ধুদের পাঠান');
          return;
        }
        final stops = store.tourPandals;
        final b = StringBuffer('🛵 চল একসাথে ঠাকুর দেখতে যাই! — TourSathi\n');
        b.writeln('শুরু: ${store.baseArea}');
        for (var i = 0; i < stops.length; i++) {
          b.writeln('${bn(i + 1)}. ${stops[i].name}');
        }
        b.writeln('\nরুট: ${Links.routeUri(stops, origin: store.base, mode: store.travelMode)}');
        await Links.whatsapp(b.toString());
        return;
      case 'screen':
        final Widget page = switch (value) {
          'emergency' => const EmergencyScreen(),
          'schedule' => const ScheduleScreen(),
          _ => const BudgetScreen(),
        };
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final nearby = store.pandals.toList()
          ..sort((a, b) => store.distanceFromBase(a).compareTo(store.distanceFromBase(b)));
        return CustomScrollView(slivers: [
          SliverToBoxAdapter(child: _Hero()),
          SliverToBoxAdapter(child: _PlannerCard()),
          SliverToBoxAdapter(
            child: FestivalSlider(onTap: (i) {
              const actions = ['tab:1', 'tab:2', 'maps:restaurants', 'screen:emergency'];
              runAction(context, actions[i]);
            }),
          ),
          const SliverToBoxAdapter(child: SectionTitle('কী খুঁজছেন?')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid.builder(
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: .92, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (ctx, i) {
                final c = categories[i];
                return Semantics(
                  button: true,
                  label: c.title,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => runAction(context, c.action),
                    child: Image.asset(
                      c.asset,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffffe0b3),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(6),
                        child: Text(c.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SectionTitle('📍 ${store.baseArea}-এর কাছের প্যান্ডেল',
                action: 'সব দেখুন', onAction: () => store.tab.value = 1),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 215,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: nearby.length > 8 ? 8 : nearby.length,
                separatorBuilder: (_, __) => const SizedBox(width: 4),
                itemBuilder: (ctx, i) => PandalCard(pandal: nearby[i], width: 200),
              ),
            ),
          ),
          if (store.usingDemo)
            const SliverToBoxAdapter(
              child: DemoNotice('এখন ডেমো প্যান্ডেল দেখানো হচ্ছে — নাম ও অবস্থান আনুমানিক। '
                  'আসল তালিকা Admin প্যানেল থেকে "আরও → ডেটা ইমপোর্ট"-এ যোগ করুন।'),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              child: Row(children: [
                Expanded(
                  child: _PromoTile('আমার পুজো ট্যুর', '${bn(store.tour.length)}টি প্যান্ডেল বাছাই',
                      Colors.green, Icons.route, () => store.tab.value = 2),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _PromoTile('বন্ধুদের পাঠান', 'WhatsApp-এ রুট শেয়ার',
                      Colors.deepPurple, Icons.groups, () => store.tab.value = 2),
                ),
              ]),
            ),
          ),
        ]);
      },
    );
  }
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final next = store.todayOrNext;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    String badge = 'পুজোর সময়সূচি দেখুন';
    if (next != null) {
      final days = next.date.difference(today).inDays;
      badge = days == 0 ? 'আজ ${next.name} 🌺' : '${next.name} আর ${bn(days)} দিন বাকি';
    }
    return Container(
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 10, 16, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff031038), Color(0xff172258), Color(0xffb52f16)],
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.location_on, color: Colors.white),
          const SizedBox(width: 4),
          Expanded(
            child: Text('$appCity, পশ্চিমবঙ্গ',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          IconButton(
            tooltip: 'জরুরি',
            onPressed: () => HomeScreen.runAction(context, 'screen:emergency'),
            icon: const Icon(Icons.sos, color: Color(0xffff8a80)),
          ),
        ]),
        const SizedBox(height: 14),
        const Text('শুভ দুর্গাপূজা',
            style: TextStyle(fontSize: 34, color: Color(0xffffc107), fontWeight: FontWeight.w900)),
        const Text('ঠাকুর দেখুন • ঘুরুন • খান • থাকুন',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => HomeScreen.runAction(context, 'screen:schedule'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(color: const Color(0xfff5083c), borderRadius: BorderRadius.circular(30)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.event, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(badge, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _PlannerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('ট্যুর পরিকল্পনা', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: store.baseArea,
          decoration: const InputDecoration(
            labelText: 'কোথা থেকে শুরু করবেন?',
            prefixIcon: Icon(Icons.my_location, color: Colors.green),
            isDense: true,
          ),
          items: [for (final a in areas) DropdownMenuItem(value: a.name, child: Text(a.name))],
          onChanged: (v) {
            if (v != null) store.setBaseArea(v);
          },
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (var i = 0; i < travelModes.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  selected: store.modeIndex == i,
                  onSelected: (_) => store.setMode(i),
                  avatar: Icon(travelModes[i].$2, size: 18),
                  label: Text(travelModes[i].$1),
                ),
              ),
          ]),
        ),
        Row(children: [
          const Text('সার্চ ব্যাসার্ধ'),
          const Spacer(),
          DropdownButton<int>(
            value: const [3, 5, 10, 15, 20, 30].contains(store.radiusKm) ? store.radiusKm : 10,
            underline: const SizedBox(),
            items: [for (final v in const [3, 5, 10, 15, 20, 30]) DropdownMenuItem(value: v, child: Text('${bn(v)} কিমি'))],
            onChanged: (v) => store.setRadius(v ?? 10),
          ),
        ]),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => store.tab.value = 1,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xfff5083c),
              padding: const EdgeInsets.all(14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.search),
            label: const Text('কাছের প্যান্ডেল খুঁজুন', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
      ]),
    );
  }
}

class _PromoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _PromoTile(this.title, this.subtitle, this.color, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 90,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
          child: Stack(children: [
            Positioned(right: 0, bottom: 0, child: Icon(icon, size: 60, color: Colors.white24)),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ]),
        ),
      );
}
