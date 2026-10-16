# Coding Urban Safety — Theme, Search, Routes, and Analytics Upgrade

## Included in this ZIP
- System / light / dark Material theme selector in the top app bar. Theme choice persists in browser storage.
- English / Malayalam selector persists in browser storage. Initial Malayalam coverage includes the landing page, study-area introduction, map assessment action, and theme controls. **Questionnaire questions, answer options, and researcher analytics are still English.** This is a partial localization, not a full translation.
- Place search starts after 450 ms of typing (3+ characters); users can still press Search. The existing Google Places (New) JavaScript integration is retained.
- Research route planning: tap the map or select a search result to add up to 20 waypoints; clear them with Clear stops. Lines connect points directly and **do not follow streets or provide turn-by-turn directions**. Routes are temporary and not stored in Firebase.
- Research dashboard: date-range filter (7/30/90 days), safety-rating distribution chart, comparison table for up to three selected places. Existing gender/condition/safety filters and place reports remain.

## Important limitations
- Dashboard figures are calculated from the latest 500 loaded assessments, not all historical records.
- Charts and comparisons depend on existing Firestore fields; missing values are shown as unavailable.
- No Firestore security rule changes or new Firebase permissions are required for these UI features.
- The source ZIP used here may contain an older Maps API key in `web/index.html`. **Before deployment, compare that file against your current GitHub main branch and keep the working key and restrictions from main.** Do not publish a key with unrestricted website access.
- The Google Maps basemap may not automatically switch to a dark style; this requires a Google Maps map style or map ID configuration.
- The Flutter SDK is not installed in this workspace; compilation and browser behavior have not been verified. Run GitHub Actions and Vercel Preview before merging.

## Verification
1. Create a feature branch and upload changed files; preserve production Maps key.
2. Check Flutter Web build and Firestore tests in GitHub Actions.
3. Verify theme persistence after refresh, both language options, search suggestions, waypoint adding/clearing, dashboard filters, and comparison with real assessment data.
4. Check small mobile screens and Firestore permission behavior before merging.
5. Merge to main only after preview passes; the changelog workflow should record the merged PR.
