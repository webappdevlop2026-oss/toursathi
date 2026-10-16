import 'dart:async';
import 'package:flutter/material.dart';

/// হোম স্ক্রিনের অটো-স্লাইডার। ছবি নেটওয়ার্ক না পেলে গ্রেডিয়েন্ট দেখায়।
class FestivalSlider extends StatefulWidget {
  final void Function(int index)? onTap;
  const FestivalSlider({super.key, this.onTap});

  @override
  State<FestivalSlider> createState() => _FestivalSliderState();
}

class _FestivalSliderState extends State<FestivalSlider> {
  final controller = PageController(viewportFraction: .92);
  Timer? timer;
  int index = 0;

  static const slides = [
    ('শুভ দুর্গাপূজা', 'আলোর উৎসবে ট্যুরসাথী', 'প্যান্ডেল • রুট • খাবার', 'https://images.unsplash.com/photo-1604541915015-5c2f956bf2c2?w=1200&q=80', Color(0xffb72c12), Icons.temple_hindu),
    ('নিজের পুজো ট্যুর', 'পছন্দের প্যান্ডেল দিয়ে রুট সাজান', 'সহজে ঘুরুন, সময় বাঁচান', 'https://images.unsplash.com/photo-1518005020951-eccb494ad742?w=1200&q=80', Color(0xff05276f), Icons.route),
    ('পুজোর স্বাদ', 'কাছাকাছি খাবার খুঁজুন', 'বন্ধু ও পরিবারের সঙ্গে', 'https://images.unsplash.com/photo-1547573854-74d2a71d0826?w=1200&q=80', Color(0xff8d3c14), Icons.restaurant),
    ('নিরাপদে ঘুরুন', 'জরুরি নম্বর এক ট্যাপে', 'পুলিশ • অ্যাম্বুলেন্স • হেল্পলাইন', 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=80', Color(0xff174c54), Icons.health_and_safety),
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !controller.hasClients) return;
      final next = (index + 1) % slides.length;
      controller.animateToPage(next, duration: const Duration(milliseconds: 550), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 160,
        child: PageView.builder(
          controller: controller,
          itemCount: slides.length,
          onPageChanged: (i) => setState(() => index = i),
          itemBuilder: (context, i) {
            final s = slides[i];
            return GestureDetector(
              onTap: () => widget.onTap?.call(i),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(19), color: s.$5),
                child: Stack(fit: StackFit.expand, children: [
                  Image.network(
                    s.$4,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, e, st) => Container(
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [s.$5, const Color(0xff091539)])),
                      child: Align(alignment: Alignment.centerRight, child: Icon(s.$6, size: 110, color: Colors.white24)),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xee07132d), Color(0x99071124), Color(0x00000000)]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 9),
                        decoration: BoxDecoration(color: const Color(0xfffa1740), borderRadius: BorderRadius.circular(20)),
                        child: const Text('TourSathi • দুর্গাপুর',
                            style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      Text(s.$1, style: const TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.w900)),
                      Text(s.$2, style: const TextStyle(fontSize: 15, color: Color(0xffffd36b), fontWeight: FontWeight.bold)),
                      Text(s.$3, style: const TextStyle(fontSize: 11, color: Colors.white)),
                    ]),
                  ),
                ]),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 7),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (var i = 0; i < slides.length; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: i == index ? 23 : 7,
            height: 7,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: i == index ? const Color(0xfff51c40) : Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
      ]),
    ]);
  }
}
