# Research Dashboard 2.0 — initial implementation

This archive is based on the user's latest `coding-urban-safety-main (3).zip`.

## Included
- Researcher-only dashboard pin map of assessment locations, colored by mean safety score.
- Gender, unsafe-condition and safety-rating filters.
- Per-place assessment count, mean safety and ludic ratings, top unsafe condition and top requested intervention.
- Printable one-page HTML reports for each place (open the downloaded HTML in a browser, then choose Print / Save as PDF).
- Existing sign-in, Firestore permissions, CSV export, home image, questionnaire and map code retained.

## Important limitations
- Dashboard aggregates the most recent 500 loaded assessments only. This is NOT an all-time map or total.
- Place pins are located at the first assessment's GeoPoint and do not deduplicate nearby place IDs.
- Filters use existing stored fields; time-of-day filtering requires additional data capture.
- Reports are based on the currently selected dashboard filters and are researcher-only. Avoid publishing small groups.
- The app requires a valid Google Maps JavaScript API key and enabled API in the deployed environment.
- Flutter SDK was not available in this environment. Run GitHub Actions Flutter Web Build and Vercel Preview before merging.

## GitHub
Only `lib/pages/research_dashboard_page.dart` was changed in the app. This README was added.
No Firestore rule changes or database migrations are required.
