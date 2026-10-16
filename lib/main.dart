import 'package:flutter/material.dart';
import 'services/store.dart';
import 'screens/home_screen.dart';
import 'screens/pandal_list_screen.dart';
import 'screens/tour_screen.dart';
import 'screens/more_screen.dart';

const brandRed = Color(0xffc62828);
const brandNavy = Color(0xff0b1743);
const brandGold = Color(0xffffc107);
const brandCream = Color(0xfffff9ef);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await store.load();
  runApp(const TourSathiApp());
}

class TourSathiApp extends StatelessWidget {
  const TourSathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TourSathi — ট্যুরসাথী',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: brandRed, primary: brandRed),
        scaffoldBackgroundColor: brandCream,
        appBarTheme: const AppBarTheme(
          backgroundColor: brandNavy,
          foregroundColor: Colors.white,
          centerTitle: false,
          titleTextStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: store.tab,
      builder: (context, index, _) => Scaffold(
        body: IndexedStack(
          index: index,
          children: const [
            HomeScreen(),
            PandalListScreen(),
            TourScreen(),
            MoreScreen(),
          ],
        ),
        bottomNavigationBar: ListenableBuilder(
          listenable: store,
          builder: (context, _) => NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (i) => store.tab.value = i,
            destinations: [
              const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'হোম'),
              const NavigationDestination(icon: Icon(Icons.location_city), selectedIcon: Icon(Icons.temple_hindu), label: 'প্যান্ডেল'),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: store.tour.isNotEmpty,
                  label: Text('${store.tour.length}'),
                  child: const Icon(Icons.alt_route),
                ),
                selectedIcon: const Icon(Icons.route),
                label: 'আমার ট্যুর',
              ),
              const NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'আরও'),
            ],
          ),
        ),
      ),
    );
  }
}
