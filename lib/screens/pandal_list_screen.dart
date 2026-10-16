import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../data/models.dart';
import '../services/store.dart';
import '../widgets/pandal_card.dart';
import 'add_pandal_screen.dart';

class PandalListScreen extends StatefulWidget {
  const PandalListScreen({super.key});

  @override
  State<PandalListScreen> createState() => _PandalListScreenState();
}

class _PandalListScreenState extends State<PandalListScreen> {
  String query = '';
  String areaFilter = 'সব';
  bool withinRadius = false;
  bool onlyFavorites = false;
  String sort = 'distance';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        var list = store.pandals.where((p) {
          final q = query.toLowerCase();
          final text = '${p.name} ${p.area} ${p.theme}'.toLowerCase();
          if (q.isNotEmpty && !text.contains(q)) return false;
          if (areaFilter != 'সব' && p.area != areaFilter) return false;
          if (withinRadius && store.distanceFromBase(p) > store.radiusKm) return false;
          if (onlyFavorites && !store.favorites.contains(p.id)) return false;
          return true;
        }).toList();
        if (sort == 'distance') {
          list.sort((a, b) => store.distanceFromBase(a).compareTo(store.distanceFromBase(b)));
        } else {
          list.sort((a, b) => a.name.compareTo(b.name));
        }
        final areaNames = {'সব', ...areas.map((a) => a.name), ...store.pandals.map((p) => p.area)}
            .where((e) => e.isNotEmpty)
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('প্যান্ডেল (${bn(list.length)})'),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort),
                initialValue: sort,
                onSelected: (v) => setState(() => sort = v),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'distance', child: Text('দূরত্ব অনুযায়ী')),
                  PopupMenuItem(value: 'name', child: Text('নাম অনুযায়ী')),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPandalScreen())),
            icon: const Icon(Icons.add_location_alt),
            label: const Text('প্যান্ডেল যোগ'),
          ),
          body: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: TextField(
                  onChanged: (v) => setState(() => query = v.trim()),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'প্যান্ডেল, এলাকা বা থিম খুঁজুন',
                    isDense: true,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(children: [
                  FilterChip(
                    label: Text('${bn(store.radiusKm)} কিমির মধ্যে'),
                    avatar: const Icon(Icons.radar, size: 18),
                    selected: withinRadius,
                    onSelected: (v) => setState(() => withinRadius = v),
                  ),
                  const SizedBox(width: 6),
                  FilterChip(
                    label: const Text('পছন্দের'),
                    avatar: const Icon(Icons.favorite, size: 18, color: Colors.red),
                    selected: onlyFavorites,
                    onSelected: (v) => setState(() => onlyFavorites = v),
                  ),
                  const SizedBox(width: 6),
                  for (final a in areaNames)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(a),
                        selected: areaFilter == a,
                        onSelected: (_) => setState(() => areaFilter = a),
                      ),
                    ),
                ]),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                child: Text('দূরত্ব মাপা হচ্ছে: ${store.baseArea} থেকে (সরলরেখায়, আনুমানিক)',
                    style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
              ),
            ),
            if (list.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text('কোনো প্যান্ডেল পাওয়া যায়নি।\nফিল্টার বদলে দেখুন।', textAlign: TextAlign.center),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 90),
                sliver: SliverGrid.builder(
                  itemCount: list.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 260, mainAxisExtent: 215, crossAxisSpacing: 2, mainAxisSpacing: 2),
                  itemBuilder: (ctx, i) => PandalCard(pandal: list[i]),
                ),
              ),
          ]),
        );
      },
    );
  }
}
