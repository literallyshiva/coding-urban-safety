# Coding Urban Safety — Interactive UI Upgrade V3

## Source
Based on `coding-urban-safety-questionnaire-animated-redesign.zip`, the latest
version previously produced in this conversation. The user-uploaded production
source `(10).zip` is older than that redesign.

## Included
- Animated city illustration overlay: keeps original waterfront sketch; walking
  emoji travels across the image; honours reduced-motion accessibility setting.
- Interactive homepage research journey and colourful emoji cards retained.
- Questionnaire: five-stage themed tracker (Safety, Experience, Spatial,
  Qualities, Design), section progress and auto-save notice; animated emoji
  ratings/cards and selected-count badges on four multi-select sections.
- Route Planner 2.0: compact, scrollable numbered stop timeline; focus map on
  stop, remove individual stops, open assessment; status clearly distinguishes
  `Assessment opened` from `Not assessed` (not proof of submission). Existing
  3-stop threshold, 20-stop limit, clear-stops tap suppression preserved.
- Research dashboard: quick last-seven-days / safety-one filters, reset filters,
  map help panel. Existing date/gender/condition/rating filters, assessment map,
  charts, comparisons, reports, CSV export and auth preserved.
- UI polish: theme-aware components, rounded hero, constrained scrollable map
  controls on smaller screens, and draft auto-save information.

## Deliberate limits
- Stop assessment completion is not persisted separately or linked to
  confirmed submissions. This would require a data-model and Firestore rules
  design, and is NOT claimed here.
- Route lines remain straight segments, not walking directions.
- Dashboard results remain limited to the latest 500 loaded assessments.
- Animation is built with Flutter; no new animation packages or API keys.

## Required verification before merging
1. Commit ZIP contents to a feature branch and check Vercel Preview build.
2. On desktop/mobile, verify the homepage animated walking emoji and reduced
   motion; test all 12 themes and language options.
3. Navigate all five questionnaire sections; verify selected counts and
   saved answers after refresh, 1–5 ratings, Review and submission.
4. Route: add three stops, select/zoom/remove one, clear, add again, open
   assessment. Verify map controls don't obscure action buttons on mobile.
5. Researcher: sign in, load data, apply/reset quick filters, inspect map,
   export filtered CSV, verify access control.

**Local Flutter SDK is unavailable.** ZIP structure and text-level checks were
performed, but Flutter compilation and browser runtime tests were not possible.
