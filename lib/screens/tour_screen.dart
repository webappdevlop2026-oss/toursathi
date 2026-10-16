import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../data/models.dart';
import '../services/maps.dart';
import '../services/store.dart';
import '../widgets/pandal_card.dart';

class TourScreen extends StatelessWidget {
  const TourScreen({super.key});

  String _shareText() {
    final stops = store.tourPandals;
    final b = StringBuffer('🌺 আমার পুজো ট্যুর — TourSathi\n');
    b.writeln('শুরু: ${store.baseArea}');
    for (var i = 0; i < stops.length; i++) {
      b.writeln('${bn(i + 1)}. ${stops[i].name} (${stops[i].area})');
    }
    if (stops.isNotEmpty) {
      b.writeln('\nপুরো রুট: ${Links.routeUri(stops, origin: store.base, mode: store.travelMode)}');
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final stops = store.tourPandals;
        final done = stops.where((p) => store.visited.contains(p.id)).length;
        return Scaffold(
          appBar: AppBar(
            title: const Text('আমার পুজো ট্যুর'),
            actions: [
              if (stops.length > 1)
                IconButton(
                  tooltip: 'কাছ থেকে দূরে সাজান',
                  icon: const Icon(Icons.auto_fix_high),
                  onPressed: () {
                    store.optimizeTour();
                    snack(context, 'রুট সবচেয়ে কাছের ক্রমে সাজানো হয়েছে');
                  },
                ),
              if (stops.isNotEmpty)
                IconButton(
                  tooltip: 'সব মুছুন',
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('ট্যুর খালি করবেন?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('না')),
                          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('হ্যাঁ')),
                        ],
                      ),
                    );
                    if (ok == true) store.clearTour();
                  },
                ),
            ],
          ),
          body: stops.isEmpty
              ? _Empty()
              : Column(children: [
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xff0b1743), Color(0xffb52f16)]),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        _Stat('প্যান্ডেল', bn(stops.length)),
                        _Stat('দেখা হয়েছে', '${bn(done)}/${bn(stops.length)}'),
                        _Stat('মোট পথ*', formatKm(store.tourDistanceKm * 1.3)),
                      ]),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: stops.isEmpty ? 0 : done / stops.length,
                          minHeight: 8,
                          backgroundColor: Colors.white24,
                          color: const Color(0xffffc107),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('শুরু: ${store.baseArea} • ${travelModes[store.modeIndex].$1} • *রাস্তার আনুমানিক দূরত্ব',
                          style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ]),
                  ),
                  if (stops.length > Links.maxWaypoints + 1)
                    DemoNotice('Google Maps একবারে ${bn(Links.maxWaypoints + 1)}টি স্টপ পর্যন্ত দেখায় — '
                        'বাকিগুলো পরের ধাপে খুলুন।'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('ধরে টেনে ক্রম বদলান • বাঁদিকে সোয়াইপ করে বাদ দিন',
                        style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
                  ),
                  Expanded(
                    child: ReorderableListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                      itemCount: stops.length,
                      onReorder: store.reorderTour,
                      itemBuilder: (ctx, i) {
                        final p = stops[i];
                        final seen = store.visited.contains(p.id);
                        return Dismissible(
                          key: ValueKey('tour-${p.id}'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.red,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (_) => store.toggleTour(p.id),
                          child: Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              onTap: () => openPandal(context, p),
                              leading: CircleAvatar(
                                backgroundColor: seen ? Colors.green : const Color(0xffc62828),
                                foregroundColor: Colors.white,
                                child: seen ? const Icon(Icons.check) : Text(bn(i + 1)),
                              ),
                              title: Text(p.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: seen ? TextDecoration.lineThrough : null,
                                  )),
                              subtitle: Text('${p.area} • ${formatKm(store.distanceFromBase(p))}'),
                              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                IconButton(
                                  icon: const Icon(Icons.directions, color: Colors.blue),
                                  onPressed: () => Links.directions(p.lat, p.lng, mode: store.travelMode),
                                ),
                                Checkbox(value: seen, onChanged: (_) => store.toggleVisited(p.id)),
                              ]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                      child: Row(children: [
                        Expanded(
                          flex: 3,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(padding: const EdgeInsets.all(14)),
                            icon: const Icon(Icons.map),
                            label: const Text('পুরো রুট Maps-এ'),
                            onPressed: () async {
                              final remaining = stops.where((p) => !store.visited.contains(p.id)).toList();
                              final list = remaining.isEmpty ? stops : remaining;
                              final ok = await Links.route(list, origin: store.base, mode: store.travelMode);
                              if (!ok && context.mounted) snack(context, 'Google Maps খোলা যায়নি');
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(14)),
                            icon: const Icon(Icons.share),
                            label: const Text('শেয়ার'),
                            onPressed: () => Links.whatsapp(_shareText()),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ]),
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat(this.label, this.value);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: const TextStyle(color: Color(0xffffc107), fontSize: 20, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ]),
      );
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.route, size: 80, color: Color(0xffc62828)),
            const SizedBox(height: 12),
            const Text('এখনো কোনো প্যান্ডেল বাছাই করা হয়নি',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 6),
            const Text('প্যান্ডেল তালিকা থেকে ⊕ চিহ্নে চাপ দিয়ে ট্যুরে যোগ করুন। '
                'তারপর এখানে ক্রম সাজিয়ে এক ক্লিকে Google Maps-এ পুরো রুট দেখুন।',
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => store.tab.value = 1,
              icon: const Icon(Icons.temple_hindu),
              label: const Text('প্যান্ডেল বাছুন'),
            ),
          ]),
        ),
      );
}
