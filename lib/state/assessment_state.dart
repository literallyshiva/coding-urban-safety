import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AssessmentState extends ChangeNotifier {
  String? gender;

  void setGender(String? value) {
    gender = value;
    notifyListeners();
  }
  LatLng? location;
  String? contributedLocationId;
  String locationSource = 'gps';
  void selectPlace(LatLng point, {String? placeId, String source = 'manual'}) {
    location = point; contributedLocationId = placeId; locationSource = source; notifyListeners();
  }
  int? safetyRating;
  final List<String> unsafeConditions = [];
  final List<String> placeExperience = [];
  String? spendMoreTime;
  final List<String> spatialConditions = [];
  final List<String> ludicQualities = [];
  int? ludicRating;
  final List<String> designResponses = [];
  String otherSuggestion = '';

  void setLocation(LatLng value) {
    location = value;
    notifyListeners();
  }

  void setSafetyRating(int value) {
    safetyRating = value;
    notifyListeners();
  }

  void toggleUnsafeCondition(String value) {
    _toggle(unsafeConditions, value);
  }

  void togglePlaceExperience(String value) {
    _toggle(placeExperience, value);
  }

  void setSpendMoreTime(String value) {
    spendMoreTime = value;
    notifyListeners();
  }

  void toggleSpatialCondition(String value) {
    _toggle(spatialConditions, value);
  }

  void toggleLudicQuality(String value) {
    _toggle(ludicQualities, value);
  }

  void setLudicRating(int value) {
    ludicRating = value;
    notifyListeners();
  }

  void toggleDesignResponse(String value) {
    _toggle(designResponses, value);
  }

  void setOtherSuggestion(String value) {
    otherSuggestion = value;
    notifyListeners();
  }

  void _toggle(List<String> target, String value) {
    if (target.contains(value)) {
      target.remove(value);
    } else {
      target.add(value);
    }
    notifyListeners();
  }

  bool get hasDraft => gender != null || location != null ||
      safetyRating != null || unsafeConditions.isNotEmpty ||
      placeExperience.isNotEmpty || spendMoreTime != null ||
      spatialConditions.isNotEmpty || ludicQualities.isNotEmpty ||
      ludicRating != null || designResponses.isNotEmpty ||
      otherSuggestion.isNotEmpty;

  String toDraftJson() => jsonEncode({
    'version': 1,
    'gender': gender,
    'lat': location?.latitude,
    'lng': location?.longitude,
    'placeId': contributedLocationId,
    'source': locationSource,
    'safety': safetyRating,
    'unsafe': unsafeConditions,
    'experience': placeExperience,
    'spend': spendMoreTime,
    'spatial': spatialConditions,
    'qualities': ludicQualities,
    'ludic': ludicRating,
    'design': designResponses,
    'other': otherSuggestion,
  });

  void restoreDraft(String raw) {
    final data = jsonDecode(raw);
    if (data is! Map<String, dynamic> || data['version'] != 1) return;
    reset();
    gender = ['Male', 'Female', 'Other'].contains(data['gender'])
        ? data['gender'] as String : null;
    if (data['lat'] is num && data['lng'] is num) {
      final lat = (data['lat'] as num).toDouble();
      final lng = (data['lng'] as num).toDouble();
      if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
        location = LatLng(lat, lng);
      }
    }
    contributedLocationId = data['placeId'] is String
        ? data['placeId'] as String : null;
    locationSource = ['gps', 'manual', 'existing'].contains(data['source'])
        ? data['source'] as String : 'manual';
    safetyRating = data['safety'] is int &&
        (data['safety'] as int) >= 1 && (data['safety'] as int) <= 5
        ? data['safety'] as int : null;
    ludicRating = data['ludic'] is int &&
        (data['ludic'] as int) >= 1 && (data['ludic'] as int) <= 5
        ? data['ludic'] as int : null;
    spendMoreTime = ['YES', 'MAYBE', 'NO'].contains(data['spend'])
        ? data['spend'] as String : null;
    void loadList(List<String> target, String key) {
      final value = data[key];
      if (value is List) target.addAll(value.whereType<String>());
    }
    loadList(unsafeConditions, 'unsafe');
    loadList(placeExperience, 'experience');
    loadList(spatialConditions, 'spatial');
    loadList(ludicQualities, 'qualities');
    loadList(designResponses, 'design');
    otherSuggestion = data['other'] is String
        ? (data['other'] as String).substring(
            0, ((data['other'] as String).length > 1000
                ? 1000 : (data['other'] as String).length)) : '';
    notifyListeners();
  }

  void reset() {
    gender = null;
    location = null;
    contributedLocationId = null;
    locationSource = 'gps';
    safetyRating = null;
    unsafeConditions.clear();
    placeExperience.clear();
    spendMoreTime = null;
    spatialConditions.clear();
    ludicQualities.clear();
    ludicRating = null;
    designResponses.clear();
    otherSuggestion = '';
    notifyListeners();
  }
}
