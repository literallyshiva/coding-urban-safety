# Community place contributions

New place: choose **New place**, tap the map, and complete the existing questionnaire.
Existing place: choose **Existing places**, select a contributed place, and complete the same questionnaire.
GPS: choose **My GPS** for the original flow.

Deploy `firebase/firestore.rules` separately in Firebase Console or Firebase CLI before testing. The app now writes a `places` document for new GPS/manual locations and adds `place_id` and `location_source` to new `assessments`. Existing assessment records remain untouched.

Prototype limitations: places are displayed as a list of up to 100 (not geo-filtered), may duplicate nearby locations, and have no moderation. Unauthenticated public place reads/creates and assessment creates are abuse risks. Do not publicly launch without App Check, anti-spam controls, validation, and privacy review. New place creation and assessment submission are separate writes: an assessment failure can leave an unused place document.
