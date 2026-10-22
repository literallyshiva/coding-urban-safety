# CODING URBAN SAFETY — Illustrated UX implementation

Based on the uploaded `coding-urban-safety-main (12).zip`.

## Changes
- Distinct illustrated artwork for welcome, study area, safety, experience, spatial,
  ludic, design, review and thank-you screens.
- Shared illustrated hero, contextual section label, gradient transition, elevated
  questionnaire surface and consistent fixed bottom action bar.
- Replaced the embedded framed artwork on Welcome and Safety with the hero layout.
- Rounded action buttons and choice cards.
- All original questionnaire logic, field values, validation, Firebase services,
  draft storage, researcher dashboard, and route navigation remain in place.

## Important notes
- The gender question is part of the Study Area page in the actual source, not a
  separate route. It is preserved there. The separate gender illustration is included
  as an optional future asset.
- The Location page is a live Google Map; it intentionally remains interactive
  rather than replacing the map with a static illustration. The location illustration
  is included as an optional future asset.
- The 10 illustrations are crops of the approved multi-panel image, and their
  source resolution is limited. They were upscaled for display, not regenerated
  at native resolution. They should be replaced with higher-res art before launch.
- No new dependencies. No database/rules/schema changes.
- This environment does not include the Flutter SDK. A build and browser check
  are required in GitHub Actions/Vercel Preview before merging.

## Deployment
Upload all changed project files to a new feature branch or use the ZIP as a
replacement source. Do not merge directly into production without preview testing.
