# Instant theme switching and Clear stops click fix

- The MaterialApp palette is recalculated inside AnimatedBuilder, so changing
  a theme updates the app without requiring a browser refresh.
- Floating map controls suppress accidental Google Map taps for 650 ms.
  Clear stops also suppresses taps before removing stops.
- Existing route assessment, infographics and Firestore rules are preserved.

Test in preview:
1. Change Beige -> Dark Ocean -> Sunset without refreshing.
2. Add three route stops, click Clear stops; count should remain zero.
3. Click an uncovered area of the map; exactly one stop should be added.
4. Verify three-stop assessment and both infographics.

Flutter SDK was not available for local compilation. Run the Vercel build and
test browser and mobile click behaviour before merging to production.
