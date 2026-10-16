# Review and targeted fixes — 2026-10-16

Based on user-provided `coding-urban-safety-main (6).zip`.

## Fixes applied
- Map search: invalidate pending autocomplete requests when input is cleared/shortened, and prevent stale results/errors/spinner state from overriding newer searches.
- Map search: show a friendly error instead of leaking the raw exception to participants (technical details remain in debug logs).
- Research route mode: keep selected route waypoints separate from assessment selection and disable the assessment action while route planning.
- Research dashboard: CSV export now respects active dashboard filters and has an explicit filtered filename/label.
- Research dashboard: comparison/sample-size caveat made clearer; selected card uses theme-aware color.

## Further improvements recommended
1. Add a dedicated Flutter web build and analyzer GitHub Action (current workflow covers Firestore tests only).
2. Replace `dart:html` and `dart:js_util` with `package:web`/JS interop when preparing Android/iOS support.
3. Make the full questionnaire bilingual (only selected interface strings are translated today).
4. Replace straight-line research waypoints with a Directions/Routes API integration if actual walking directions are required.
5. Add Firestore pagination or server-side aggregate statistics to remove the 500-assessment analytics limitation.
6. Make existing-place discovery geospatial rather than `.limit(100)`.
7. Add app check, consent, and privacy-safe public analytics before wide release.

## Verification limits
- Checked code patterns and ZIP archive integrity.
- Flutter SDK and dependency installation were unavailable here, so no `flutter analyze`, `flutter test`, or web compilation was run.
- Run GitHub Actions and Vercel preview before merging.
