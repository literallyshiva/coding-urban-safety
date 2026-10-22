# Safety UI — approved illustrated mockup implementation

Based on the latest user-provided urban-safety-v2 ZIP and the previously corrected scaffold.

Changes:
- Immersive illustrated Safety background; on desktop the form overlays the right
  side of the scene, rather than sitting beside an isolated picture.
- On mobile the illustration is a header behind the content; form scrolls below.
- Clean teal progress, five labeled emoji ratings, condition tiles with selection state.
- Existing 8 unsafe-condition values, safety rating state, validation, route to the
  next questionnaire page, Firestore schema and all other screens remain unchanged.
- App theme choices still exist; Safety has a deliberate unified visual treatment.

Important: The Safety illustration is still the existing 957x1521 asset; this patch
DOES NOT deliver newly rendered 4K source artwork. Image quality remains a limitation.
No Flutter SDK available for compile testing. Verify on Vercel Preview before merge.
