import 'package:flutter/material.dart';
import '../data/models.dart';
import '../services/maps.dart';
import '../services/store.dart';
import '../screens/pandal_detail_screen.dart';

void snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
}

void openPandal(BuildContext context, Pandal p) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => PandalDetailScreen(pandalId: p.id)));
}

/// ছবি না থাকলে বা লোড না হলে সুন্দর প্লেসহোল্ডার
class PandalImage extends StatelessWidget {
  final Pandal pandal;
  final double iconSize;
  const PandalImage({super.key, required this.pandal, this.iconSize = 50});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff0b1743), Color(0xff7a1f12)],
        ),
      ),
      child: Center(child: Icon(Icons.temple_hindu, color: const Color(0xffffc107), size: iconSize)),
    );
    if (pandal.imageUrl.isEmpty) return placeholder;
    return Image.network(pandal.imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => placeholder);
  }
}

/// গ্রিড/তালিকার জন্য প্যান্ডেল কার্ড
class PandalCard extends StatelessWidget {
  final Pandal pandal;
  final double? width;
  const PandalCard({super.key, required this.pandal, this.width});

  @override
  Widget build(BuildContext context) {
    final p = pandal;
    final inTour = store.inTour(p.id);
    final visited = store.visited.contains(p.id);
    return SizedBox(
      width: width,
      child: Card(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () => openPandal(context, p),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Stack(fit: StackFit.expand, children: [
                PandalImage(pandal: p),
                Positioned(
                  left: 8,
                  top: 8,
                  child: _Tag(text: formatKm(store.distanceFromBase(p)), color: const Color(0xcc000000)),
                ),
                if (visited)
                  const Positioned(right: 8, top: 8, child: _Tag(text: '✓ দেখা হয়েছে', color: Color(0xff2e7d32))),
                if (!p.verified && !visited)
                  const Positioned(right: 8, top: 8, child: _Tag(text: 'ডেমো', color: Color(0xffe65100))),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 4, 0),
              child: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
            Row(children: [
              const SizedBox(width: 8),
              const Icon(Icons.location_on, size: 14, color: Colors.deepOrange),
              Expanded(
                child: Text(p.area, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: inTour ? 'ট্যুর থেকে বাদ দিন' : 'ট্যুরে যোগ করুন',
                icon: Icon(inTour ? Icons.playlist_add_check_circle : Icons.add_circle_outline,
                    color: inTour ? Colors.green : const Color(0xffc62828)),
                onPressed: () {
                  store.toggleTour(p.id);
                  snack(context, store.inTour(p.id) ? 'ট্যুরে যোগ হয়েছে' : 'ট্যুর থেকে বাদ দেওয়া হয়েছে');
                },
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'রুট',
                icon: const Icon(Icons.directions, color: Colors.blue),
                onPressed: () async {
                  final ok = await Links.directions(p.lat, p.lng, mode: store.travelMode);
                  if (!ok && context.mounted) snack(context, 'Google Maps খোলা যায়নি');
                },
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionTitle(this.title, {super.key, this.action, this.onAction});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 8, 8),
        child: Row(children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
          if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
        ]),
      );
}

class DemoNotice extends StatelessWidget {
  final String text;
  const DemoNotice(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xfffff3e0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffffcc80)),
        ),
        child: Row(children: [
          const Icon(Icons.info_outline, color: Color(0xffe65100), size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xff8d3c14)))),
        ]),
      );
}
