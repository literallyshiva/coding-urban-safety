# Theme consistency update

This patch preserves the working three-stop route planner, assessment saving, and safety infographic logic.

- The selected palette now tints both light and dark scaffold surfaces and app bars.
- The home page primary action and divider follow the selected palette.
- The route polyline follows the selected palette.
- Theme selection is persisted by the existing `AppPreferences.setPalette` SharedPreferences implementation.

**Limitations:** Some legacy illustration, questionnaire, and dashboard widgets still use hardcoded brand colours. A full cross-screen theme migration requires reviewing each widget and verifying contrast in light/dark mode. Google Maps map tiles themselves are not recoloured by Flutter's Material theme.

Validation: run Flutter web build, then preview all five palettes and light/dark modes. Do not merge until the build passes.
