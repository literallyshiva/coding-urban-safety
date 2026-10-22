# Illustrated UX layout correction

Source: `coding-urban-safety-urban-safety-v2.zip` supplied by the user.

## Root cause
`ResearchScaffold` rendered every illustration inside a 310–360 px high
`BoxFit.cover` banner, then placed a narrow card beneath it. Desktop image
cropping and blank page space were structural, not an image-loading bug.

## New behavior
- Desktop (>=1000 logical pixels): split-screen layout, illustration on the
  left (46%), scrollable questionnaire on the right (54%).
- Mobile/tablet: illustration fills the entire screen behind the form; the
  content floats over it with an accessible near-opaque panel.
- Existing section-specific images remain unchanged.
- Existing controls, navigation, Firestore, maps, themes, language,
  validation, progress and state logic remain unchanged.
- Unillustrated pages keep the original centered layout.

## Files changed
- `lib/widgets/research_scaffold.dart`
- `lib/pages/safety_assessment_page.dart` (removes redundant spacing)

## Validation
No Flutter SDK was available, so the project was not compiled.
Run Vercel Preview and verify mobile and desktop, especially Google Maps
interaction, scrolling, form focus, navigation, and dark themes.
