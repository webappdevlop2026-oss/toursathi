import 'package:url_launcher/url_launcher.dart';
import '../data/models.dart';

/// Google Maps, ফোন কল ও WhatsApp খোলার সহায়ক।
class Links {
  static Future<bool> _open(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> directions(double lat, double lng, {String mode = 'driving'}) => _open(
        Uri.https('www.google.com', '/maps/dir/', {
          'api': '1',
          'destination': '$lat,$lng',
          'travelmode': mode,
        }),
      );

  static Future<bool> showOnMap(double lat, double lng) => _open(
        Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': '$lat,$lng'}),
      );

  /// এলাকার কাছাকাছি কিছু খোঁজা (যেমন restaurants near City Centre)
  static Future<bool> searchNear(String what, Area area) => _open(
        Uri.https('www.google.com', '/maps/search/', {
          'api': '1',
          'query': '$what near ${area.lat},${area.lng}',
        }),
      );

  /// Google Maps-এ সর্বোচ্চ ৯টি ওয়েপয়েন্ট সমর্থিত।
  static const maxWaypoints = 9;

  static Uri routeUri(List<Pandal> stops, {required Area origin, String mode = 'driving'}) {
    final last = stops.last;
    final mid = stops.take(stops.length - 1).take(maxWaypoints).map((p) => '${p.lat},${p.lng}').join('|');
    final params = <String, String>{
      'api': '1',
      'origin': '${origin.lat},${origin.lng}',
      'destination': '${last.lat},${last.lng}',
      'travelmode': mode,
    };
    if (mid.isNotEmpty) params['waypoints'] = mid;
    return Uri.https('www.google.com', '/maps/dir/', params);
  }

  static Future<bool> route(List<Pandal> stops, {required Area origin, String mode = 'driving'}) =>
      _open(routeUri(stops, origin: origin, mode: mode));

  static Future<bool> call(String number) async {
    try {
      return await launchUrl(Uri(scheme: 'tel', path: number));
    } catch (_) {
      return false;
    }
  }

  static Future<bool> whatsapp(String text) =>
      _open(Uri.https('wa.me', '/', {'text': text}));

  static Future<bool> web(String url) => _open(Uri.parse(url));
}
