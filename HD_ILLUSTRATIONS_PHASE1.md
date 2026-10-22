# HD illustration integration — Phase 1

This is an **incremental implementation**, not a finished ten-page art package.

- Uses the uploaded `coding-urban-safety-urban-safety-v2 (1).zip` as the base.
- Replaces Safety background with newly generated standalone artwork, not a collage crop.
- Desktop WebP preserves original 1672 × 941 detail; mobile WebP uses a native-resolution portrait-friendly crop. Neither file is falsely upscaled to 4K.
- The Safety widget selects the appropriate asset for viewport width and uses high-quality image filtering.
- The nine other page illustrations remain as in the uploaded project pending creation of distinct standalone artworks.
- Form data, navigation, Google Maps and Firebase logic were not intentionally modified.

## Verification needed
No Flutter SDK / browser compilation was run. Test Safety on desktop and mobile, especially readability and whether crop preserves the intended subject. Then commission standalone artwork for the remaining nine pages.
