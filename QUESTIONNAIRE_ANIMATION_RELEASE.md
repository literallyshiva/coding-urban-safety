# Coding Urban Safety — questionnaire-wide animated UI

Source: previous animated-colourful-research-ui ZIP.

Changes:
- Safety 1–5 rating uses gently animated emoji faces, equal visual prominence,
  selection border, theme-aware gradients.
- Unsafe conditions use 8 icon-supported animated cards rather than plain chips.
- Spatial conditions use 10 animated emoji cards.
- Ludic qualities use 8 animated emoji cards; interest 1–5 rating uses the
  same accessible emoji rating component.
- Design responses use 12 animated emoji cards.
- Headings, supporting text, selected text, dividers and progress track on
  these four pages use ColorScheme for dark/light contrast.
- Existing Experience of Place, Spend More Time and homepage animations retained.
- Animations loop and respect reduced-motion preference.

No change to option strings, response keys, rating values, state methods,
Firestore, Google Maps, route planning, or submission flow.

IMPORTANT: Flutter SDK not installed; no Flutter compile or runtime browser
validation was possible. Test on a Vercel feature-branch Preview before merging:
1. Beige + Dark Ocean readability.
2. Select/unselect each option in every section; check values in Review.
3. Test ratings 1..5 and next-step validation.
4. Confirm emojis visibly move without interaction; test reduced motion.
5. Confirm submit/researcher dashboard, route planner and Clear Stops.
