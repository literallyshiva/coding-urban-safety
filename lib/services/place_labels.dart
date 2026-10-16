import 'dart:js_util' as js_util;
import 'package:cloud_firestore/cloud_firestore.dart';

/// Best-effort readable labels for legacy places stored with coordinates only.
/// Results are cached for the current browser session. No Firestore writes.
class PlaceLabels {
  static final Map<String, Future<String>> _cache = {};

  static String coordinates(GeoPoint point) =>
      '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';

  static Future<String> forPoint(GeoPoint point) {
    final key = coordinates(point);
    return _cache.putIfAbsent(key, () async {
      try {
        final promise = js_util.callMethod<Object>(
          js_util.globalThis,
          'urbanSafetyReverseGeocode',
          [point.latitude, point.longitude],
        );
        final result = await js_util.promiseToFuture<Object?>(promise);
        final label = result?.toString().trim() ?? '';
        return label.isEmpty ? 'Location near $key' : label;
      } catch (_) {
        // Missing Geocoding API permissions, quota, or network issues.
        return 'Location near $key';
      }
    });
  }
}
