# Illustration implementation — 22 October 2026

## Implemented
- Twenty new procedurally drawn illustrated backgrounds (ten unique scenes, independent desktop and portrait mobile compositions), each 1920×1080 or 1080×1920, exported as WebP. These are **new vector-like procedural illustrations**, not converted PNGs or cropped approved previews.
- All ResearchScaffold-based questionnaire pages use the responsive `_desktop.webp` / `_mobile.webp` asset pair, and the immersive Safety-style layout with BoxFit.cover. Safety now also uses newly drawn images; the original approved Safety files remain in assets as a fallback.
- Existing questionnaire widgets, Firestore, Google Maps, and navigation logic were not modified.

## Known limitations
- The procedural artwork is **not a faithful recreation of the approved detailed painterly previews**; inspect the included `ILLUSTRATION_CONTACT_SHEET.jpg` before deploying. The images are technically full resolution, but visual style is simpler than the original Safety art.
- Gender is a section of Study Area rather than a standalone page in this codebase; `gender_*` files are provided but not separately routed.
- Location uses an interactive Google Map, so `location_*` images are included but deliberately not substituted for the map.
- Review is mapped to the gender scene because the requested ten-page list excludes Review. This can be changed after visual QA.
- Flutter/Dart CLI was unavailable in this runtime, so no compile or browser rendering verification was possible.
