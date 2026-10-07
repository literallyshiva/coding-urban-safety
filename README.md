# CODING URBAN SAFETY

A mobile-first Flutter field-research application for assessing perceived safety, experience and behaviour, spatial conditions, ludic potential, and possible urban-design responses.

## Implemented flow

HomePage → StudyAreaPage → MapPage → SafetyAssessmentPage → LudicAssessmentPage → SpatialAssessmentPage → LudicPotentialPage → DesignResponsePage → Firestore submission

Each submission creates a **new** document in the `assessments` collection.

## Firestore schema

- `location`: GeoPoint
- `safety_rating`: int
- `unsafe_conditions`: List<String>
- `place_experience`: List<String>
- `spend_more_time`: String
- `spatial_conditions`: List<String>
- `ludic_qualities`: List<String>
- `ludic_rating`: int
- `design_responses`: List<String>
- `other_suggestion`: String
- `created_at`: server timestamp

## 1. Create the Flutter platform folders

This package contains the application source. From the project root, run:

```bash
flutter create .
flutter pub get
```

If `flutter create .` rewrites `lib/main.dart` or `pubspec.yaml`, restore the versions from this package afterward.

## 2. Connect Firebase

Create a Firebase project, enable **Cloud Firestore**, then install/configure FlutterFire.

Recommended:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

For Android/iOS, the generated Firebase platform configuration files must be present. The app intentionally does not contain project credentials.

The app uses `Firebase.initializeApp()` in `lib/main.dart`. If your FlutterFire setup generates `firebase_options.dart` and requires explicit options (for example, for web), change initialization to:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

and import the generated `firebase_options.dart`.

## 3. Deploy Firestore rules

A prototype create-only unauthenticated rule set is included at:

`firebase/firestore.rules`

These rules allow public participants to create assessment records without Firebase Authentication, but deny client reads/updates/deletes. This is appropriate only for a controlled research prototype. Add App Check and stronger abuse controls before public deployment.

## 4. Google Maps API key

Enable the Google Maps SDK for the target platform(s) in Google Cloud and configure an API key.

### Android

In `android/app/src/main/AndroidManifest.xml`, inside `<application>`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY" />
```

Also add these permissions above `<application>`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

The current `google_maps_flutter` release requires Android SDK 24+.

### iOS

In `ios/Runner/Info.plist` add:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Your location is used to record where the urban safety assessment is completed.</string>
```

Configure the Google Maps iOS API key using the current `google_maps_flutter` iOS setup instructions for your generated Flutter project.

## 5. Run

```bash
flutter run
```

Use a physical phone where possible because the study workflow depends on current device location.

## State-management behavior

`AssessmentState` is created once at the application root and passed through the complete questionnaire. All multi-select responses are stored as full `List<String>` collections. Numeric ratings are stored as `int`. The state is only reset after a successful Firestore submission and when the participant chooses to assess another place.

## Submission behavior

`AssessmentRepository.submit()` calls:

```dart
FirebaseFirestore.instance.collection('assessments').add({...});
```

so every submission creates a separate document. Location is converted from Google Maps `LatLng` to Firestore `GeoPoint`, and `created_at` uses `FieldValue.serverTimestamp()`.
