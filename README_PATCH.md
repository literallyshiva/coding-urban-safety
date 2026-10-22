# Urban Safety 2.0 — Editorial Illustration Patch

Source baseline: uploaded `coding-urban-safety-main (11).zip`.

## Files
- `lib/widgets/editorial_city_artwork.dart` (new)
- `lib/pages/home_page.dart` (replace)
- `lib/pages/safety_assessment_page.dart` (replace)

## What changes
- Original graphic-design-led city illustrations drawn by Flutter CustomPainter.
- Bold city-poster palette, decorative street grid, crossing and people, caption stickers.
- Home editorial note and redesigned headline.
- Safety illustration and stronger hierarchy.

## What stays unchanged
- Assessment state, question choices, navigation, Google Maps, Firebase, security rules,
  drafts, researcher dashboard and submission logic.
- No external fonts, images, packages or API requests.

## IMPORTANT: integration with current branch
These page files are based on the latest uploaded main ZIP, not the newer V2 patch
already committed to `urban-safety-v2`. Review the diff before replacing files;
if newer edits exist, merge the changes instead of blindly overwriting them.

## Deployment
Use a feature branch, preserve directory paths, and test Vercel Preview.
No Flutter build was run in this environment.
