
import 'dart:js_util' as js_util;

class PlaceSuggestion {
  const PlaceSuggestion(this.id, this.description);

  final String id;
  final String description;
}

class PlaceSearch {
  static Future<List<PlaceSuggestion>> search(String query) async {
    final promise = js_util.callMethod<Object>(
      js_util.globalThis,
      'urbanSafetySearchPlaces',
      [query],
    );

    final result = await js_util.promiseToFuture<Object?>(promise);
    final items = js_util.dartify(result);

    if (items is! List) return [];

    return items.whereType<Map>().map((entry) {
      return PlaceSuggestion(
        entry['id'].toString(),
        entry['text'].toString(),
      );
    }).toList();
  }

  static Future<({double lat, double lng})> resolve(String id) async {
    final promise = js_util.callMethod<Object>(
      js_util.globalThis,
      'urbanSafetyResolvePlace',
      [id],
    );

    final result = await js_util.promiseToFuture<Object?>(promise);
    final data = js_util.dartify(result) as Map;

    return (
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
    );
  }
}
