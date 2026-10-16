import 'package:flutter/material.dart';
import '../data/models.dart';
import '../services/maps.dart';
import '../services/store.dart';
import '../widgets/pandal_card.dart';

class PandalDetailScreen extends StatelessWidget {
  final String pandalId;
  const PandalDetailScreen({super.key, required this.pandalId});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final p = store.byId(pandalId);
        if (p == null) {
          return Scaffold(appBar: AppBar(), body: const Center(child: Text('প্যান্ডেলটি আর পাওয়া যাচ্ছে না')));
        }
        final inTour = store.inTour(p.id);
        final fav = store.favorites.contains(p.id);
        final visited = store.visited.contains(p.id);
        return Scaffold(
          body: CustomScrollView(slivers: [
            SliverAppBar(
              expandedHeight: 230,
              pinned: true,
              actions: [
                IconButton(
                  tooltip: 'পছন্দের',
                  icon: Icon(fav ? Icons.favorite : Icons.favorite_border, color: fav ? Colors.redAccent : Colors.white),
                  onPressed: () => store.toggleFavorite(p.id),
                ),
                IconButton(
                  tooltip: 'WhatsApp-এ শেয়ার',
                  icon: const Icon(Icons.share),
                  onPressed: () => Links.whatsapp(
                    '🌺 ${p.name} (${p.area})\n'
                    'Google Maps: https://www.google.com/maps/search/?api=1&query=${p.lat},${p.lng}\n'
                    '— TourSathi অ্যাপ থেকে',
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: PandalImage(pandal: p, iconSize: 90),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Wrap(spacing: 8, runSpacing: 6, children: [
                    Chip(avatar: const Icon(Icons.location_on, size: 16), label: Text(p.area)),
                    Chip(
                      avatar: const Icon(Icons.straighten, size: 16),
                      label: Text('${store.baseArea} থেকে ${formatKm(store.distanceFromBase(p))}'),
                    ),
                    if (p.theme.isNotEmpty) Chip(avatar: const Icon(Icons.palette, size: 16), label: Text(p.theme)),
                    Chip(
                      backgroundColor: p.verified ? const Color(0xffe8f5e9) : const Color(0xfffff3e0),
                      label: Text(p.verified ? '✓ যাচাই করা' : 'যাচাই বাকি / ডেমো'),
                    ),
                    if (p.userAdded) const Chip(label: Text('আমার যোগ করা')),
                  ]),
                  if (p.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(p.description, style: const TextStyle(fontSize: 15, height: 1.5)),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(padding: const EdgeInsets.all(14)),
                      icon: const Icon(Icons.directions),
                      label: const Text('এখানে যাওয়ার রুট', style: TextStyle(fontSize: 16)),
                      onPressed: () async {
                        final ok = await Links.directions(p.lat, p.lng, mode: store.travelMode);
                        if (!ok && context.mounted) snack(context, 'Google Maps খোলা যায়নি');
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(inTour ? Icons.check : Icons.add),
                        label: Text(inTour ? 'ট্যুরে আছে' : 'ট্যুরে যোগ'),
                        onPressed: () => store.toggleTour(p.id),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(visited ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: visited ? Colors.green : null),
                        label: Text(visited ? 'দেখা হয়েছে' : 'দেখা হলে টিক দিন'),
                        onPressed: () => store.toggleVisited(p.id),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  const Text('আশেপাশে', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final n in const [
                      ('খাবার', Icons.restaurant, 'restaurants'),
                      ('পার্কিং', Icons.local_parking, 'parking'),
                      ('এটিএম', Icons.local_atm, 'ATM'),
                      ('শৌচালয়', Icons.wc, 'public toilet'),
                      ('হাসপাতাল', Icons.local_hospital, 'hospital'),
                    ])
                      ActionChip(
                        avatar: Icon(n.$2, size: 18),
                        label: Text(n.$1),
                        onPressed: () => Links.searchNear(n.$3, Area(p.name, p.lat, p.lng)),
                      ),
                  ]),
                  if (p.userAdded) ...[
                    const SizedBox(height: 24),
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('এই প্যান্ডেল মুছে দিন'),
                      onPressed: () {
                        store.removeCustom(p.id);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                  const SizedBox(height: 30),
                ]),
              ),
            ),
          ]),
        );
      },
    );
  }
}
