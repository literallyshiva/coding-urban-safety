# Illustrated layout correction (partial delivery)

- Applied the approved Safety immersive overlay layout to all pages using `ResearchScaffold` with an illustration.
- Retained the original form widgets, buttons, navigation, Firestore code, and question data.
- Fixed the hard-coded mobile SAFETY badge to use each page’s section label.
- Kept Safety desktop/mobile WebP selection unchanged.
- Did **not** claim to generate 20 new high-resolution illustrations. The nine legacy WebP files remain lower-resolution artwork.
- Map page and any screens not using `ResearchScaffold` were not redesigned.
- Flutter SDK is not installed in this environment, so compilation and browser responsive tests are not verified.

Do not merge this untested layout patch into production. Test on a feature branch first.
