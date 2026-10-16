# Coding Urban Safety — integrated upgrade

Source: coding-urban-safety-main (5).zip.

## Included
- Theme selector: light, dark and system, persisted with shared_preferences.
- English/Malayalam language selector with partial translated interface text.
- Debounced location search with suggestions.
- Research route waypoint planner (maximum 20 stops, straight-line connections, not walking navigation).
- Dashboard date, gender, condition and safety-rating filters.
- Safety rating distribution chart, comparisons of up to three places, place summaries and printable HTML reports.

## Preserved from latest source
- Firebase Firestore rules and researcher permissions.
- GitHub Actions update-changelog workflow.
- Existing web/index.html and Maps key configuration.
- Existing questionnaire, Firestore schema and waterfront illustration.

## Known limitations
- Flutter SDK unavailable here; compilation and browser behavior unverified.
- Malayalam coverage and dark mode styling are partial on some questionnaire screens.
- Dashboard uses the latest 500 assessments loaded.
- Route is a visual waypoint polyline, not turn-by-turn navigation.

Commit to a feature branch, check GitHub Actions and Vercel Preview, then merge only after verification.
