
import 'package:cloud_firestore/cloud_firestore.dart';

import '../state/assessment_state.dart';

class AssessmentRepository {
  AssessmentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<DocumentReference<Map<String, dynamic>>> submit(
    AssessmentState state,
  ) async {
    final location = state.location;
    final safetyRating = state.safetyRating;
    final ludicRating = state.ludicRating;
    final gender = state.gender;

    if (location == null) {
      throw StateError('Assessment location is required.');
    }
    if (safetyRating == null) {
      throw StateError('Safety rating is required.');
    }
    if (state.spendMoreTime == null) {
      throw StateError('Spend-more-time response is required.');
    }
    if (ludicRating == null) {
      throw StateError('Ludic rating is required.');
    }

    // Gender is optional, but selected values must be valid.
    if (gender != null &&
        !['Male', 'Female', 'Other'].contains(gender)) {
      throw StateError('Invalid gender selection.');
    }

    String? placeId = state.contributedLocationId;

    if (placeId == null) {
      final place = await _firestore.collection('places').add({
        'location': GeoPoint(
          location.latitude,
          location.longitude,
        ),
        'created_at': FieldValue.serverTimestamp(),
      });

      placeId = place.id;
    }

    // Build assessment data.
    final assessmentData = <String, dynamic>{
      'place_id': placeId,
      'location_source': state.locationSource,
      'location': GeoPoint(
        location.latitude,
        location.longitude,
      ),
      'safety_rating': safetyRating,
      'unsafe_conditions':
          List<String>.from(state.unsafeConditions),
      'place_experience':
          List<String>.from(state.placeExperience),
      'spend_more_time': state.spendMoreTime,
      'spatial_conditions':
          List<String>.from(state.spatialConditions),
      'ludic_qualities':
          List<String>.from(state.ludicQualities),
      'ludic_rating': ludicRating,
      'design_responses':
          List<String>.from(state.designResponses),
      'other_suggestion':
          state.otherSuggestion.trim(),
      'created_at': FieldValue.serverTimestamp(),
    };

    // Save gender only when the participant selects an option.
    if (gender != null) {
      assessmentData['gender'] = gender;
    }

    return _firestore
        .collection('assessments')
        .add(assessmentData);
  }
}
