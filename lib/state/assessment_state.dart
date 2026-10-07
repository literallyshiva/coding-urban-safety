import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AssessmentState extends ChangeNotifier {
  LatLng? location;
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
  }

  void _toggle(List<String> target, String value) {
    if (target.contains(value)) {
      target.remove(value);
    } else {
      target.add(value);
    }
    notifyListeners();
  }

  void reset() {
    location = null;
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
