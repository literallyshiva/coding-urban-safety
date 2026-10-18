# Coding Urban Safety V4 — Phase 1 Preview

## Material redesigns in this release

- Replaced the static sketch-and-single-walker homepage hero with an entirely Flutter-painted colourful urban scene: multi-colour skyline, sun, drifting clouds, street trees, pedestrians and cyclist moving independently across a city street. The scene adapts to the active ColorScheme, has no external image dependency and respects reduced-motion settings.
- Redesigned the five-section questionnaire progress tracker into a colourful, large, labelled five-step visual journey with animated fill, current-section highlighting and draft-save explanation.
- Rounded and strengthened the homepage primary action and headline visual hierarchy.
- Retains V3 interactive route stop timeline, existing researcher dashboard filters and charts, animated questionnaire choice cards, Firestore and Google Maps functionality, language and themes.

## Honest release status

This is **V4 Phase 1**, not a finished comprehensive V4. The route planner and researcher dashboard have not yet received a ground-up V4 redesign. The current enhancements to those pages come from V3. No Flutter SDK is installed in this environment, so Dart compilation and real browser interaction testing have NOT been performed. Do not merge this into production without passing a Vercel Preview build and regression tests.

## Test checklist

1. Create feature branch `v4-phase1-preview`; upload the ZIP contents preserving directory structure.
2. Check Vercel Preview build logs for Dart errors before opening preview.
3. On homepage, verify pedestrians, cyclist and clouds move continuously; verify mobile width and reduced-motion setting.
4. In each questionnaire section, verify five-step progress, text contrast in Beige and all dark themes, card selections and rating values.
5. Validate the existing 3-stop route planner, remove/clear stops and map tap suppression.
6. Submit a sample assessment, check researcher dashboard access, filters, maps and exports.
7. Check Malayalam, theme persistence and saved draft restoration.

No production environment configuration or Firestore rules were intentionally changed.
