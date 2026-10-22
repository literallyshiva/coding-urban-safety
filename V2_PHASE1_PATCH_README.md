# Urban Safety 2.0 — Phase 1 UI patch

Apply the four `lib/` files and this README to `feature/urban-safety-v2`, retaining their paths.

## Changes
- V2 optional layout mode in ResearchScaffold, enabled only on Safety page.
- Compact accessible 5-section progress component (shared across pages).
- New reusable V2QuestionCard.
- Safety page adopts question cards, removes duplicate progress bar, retains existing ratings, unsafe conditions, state, navigation, and validation.

## Not changed
- Firestore rules, data fields, repositories, authentication, maps, and dashboard.
- Adaptive follow-ups and new research fields are reserved for a later coordinated patch.

## Testing
1. Commit these files to `feature/urban-safety-v2`.
2. Wait for Vercel Preview to become Ready; open the Preview URL.
3. Start a questionnaire and visit Safety. Check mobile and desktop widths.
4. Choose a rating, select unsafe conditions, navigate Next and Back; verify selections persist.
5. Check remaining section progress headers, theme switching, and no Flutter errors.

This patch was source-reviewed but not Flutter-compiled in this environment.
