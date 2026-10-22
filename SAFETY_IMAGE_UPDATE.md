# Safety image clarity update

Based on the uploaded `coding-urban-safety-urban-safety-v2 (1).zip`.

New illustration is an original generated image with 1672x941 native pixels.
It is **not 4K** and is not upscaled or sharpened from the old cropped illustration.

- `assets/images/illustrated/safety_street_desktop.webp` (1672x941)
- `assets/images/illustrated/safety_street_mobile.webp` (900x941 crop)
- `lib/pages/safety_assessment_page.dart`: points to new artwork.
- `lib/widgets/research_scaffold.dart`: chooses portrait crop below desktop breakpoint, high quality filtering.
- `pubspec.yaml`: ensure illustrated assets folder registered.

Existing Safety questionnaire logic and all other page images remain unchanged.
Test in Vercel Preview on desktop and mobile. Some blur may remain on very high-DPI screens because the source is 1672px wide, not 4K. Flutter build not run.
