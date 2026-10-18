# Route Planner, Colour Themes and Infographics — October 2026

## Route Planner
- Add stops by clicking the map or selecting search results.
- **Three stops** unlock **ASSESS SELECTED STOP**. Twenty stops is only the maximum allowed, not a required count.
- Select a stop using its chip or by clicking its map marker (blue marker = selected), then press **ASSESS SELECTED STOP**.
- The assessment questionnaire opens for the selected stop. Existing assessment persistence continues through the app's existing submission flow. This release does **not** automatically save the whole route or all stops to Firestore, and it does not fetch existing assessments for each route stop.
- Route lines remain straight-line visual connections, not Google walking directions.
- Switching to New place / Existing places / GPS exits route mode.

## Colour palettes
- Open the settings gear and choose Sage & cream, Ocean & sky, Sunset & sand, Lavender & pearl, or Forest & mint.
- Palette choice persists in SharedPreferences; Light / Dark / System mode remains available separately.
- Google Maps base-map styling is unchanged.

## Infographics
- Route progress bar shows how many stops have been selected toward the three-stop minimum.
- Researcher Dashboard adds a safety snapshot of low, mixed, and positive safety ratings based on currently filtered assessments; existing rating-distribution charts remain.

## Testing before production
1. GitHub Actions: run Flutter build and Firestore rules tests.
2. Vercel preview: select 1, 2, then 3 stops; assessment button should enable at 3.
3. Select a non-last stop and confirm the assessment targets its coordinates.
4. Submit an assessment, then confirm it appears in researcher data.
5. Switch each colour palette, refresh, and verify persistence; test light/dark.
6. Verify Google Maps, Google login, readable place names, and CSV/report export.

No Firestore security rules or Firebase configuration were changed.
