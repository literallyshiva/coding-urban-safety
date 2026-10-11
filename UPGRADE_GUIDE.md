# Coding Urban Safety — production upgrade (staging branch)

Source baseline: production ZIP at merge commit `21fd0be`.

## Included

1. Google Maps Places search (New API), with selectable result placed on map as a **new** place.
2. Local unfinished-draft saving and resume from the home page. Drafts stay in this browser/device.
3. Private researcher dashboard with Google sign-in, Firestore-enforced verified-email authorization, latest-500 metrics and CSV export.
4. Mobile-friendly map search controls and adaptive questionnaire cards (existing responsive cards retained).
5. Review answers screen before the final Firestore write.
6. GPS permission and service error messages, retry and manual fallback.
7. Atomic batch creation of a new place and its assessment; rules reject standalone orphan places.

## REQUIRED setup before rollout

**Never publish the dashboard rules with the placeholder email.**

- In `firebase/firestore.rules`, replace `REPLACE_WITH_RESEARCHER_EMAIL` with the **exact verified Google account email** allowed to read assessments. Keep only a trusted researcher's email. This is security configuration, not a password.
- In Firebase Console → Authentication → Sign-in method, enable **Google** and configure the authorized Vercel domain(s). Use the researcher account to sign in. Sign-in alone does not authorize access; Firestore rules must match the email.
- In the Google Cloud project holding the Maps JavaScript API key, enable **Places API (New)** and ensure the API key allows both **Maps JavaScript API** and **Places API (New)**. Keep website referrer restrictions. Places API (New) requests may incur billing. Test search on the stable branch Preview URL.
- Flutter web project uses `dart:html` / JS bridge for Places and CSV download. This package is web-targeted, not Android/iOS ready without platform-specific replacements.

## Important deployment ordering (new place submissions)

The atomic-place schema and rules **must be deployed in a coordinated release**:
- New code writes `assessment_id` on newly created places; old rules reject it.
- New rules reject standalone place creation; old app versions cannot create new places.
- Stage and run tests first; schedule a short maintenance window for the production cutover, publish the tested rules and deploy the new app immediately together, then verify both new and existing place submissions.
- Do not apply the new Firestore rules to live production while the old frontend is still in use for an extended period.
- Existing places remain readable and may receive additional assessments.
- Firebase Security Rules unit tests run via the existing GitHub Actions workflow on your feature branch. Do **not** merge until green.

## Suggested browser acceptance test

- Existing place → all five stages → review → edit → confirm → Thank You → Assess Another Place.
- New place by map tap and by Places search → verify exactly one place and one assessment created.
- Deny GPS and verify manual fallback.
- Select gender and leave gender blank in separate submissions.
- Start an assessment, refresh browser, resume; submit and confirm draft disappears.
- Open researcher dashboard signed out; sign in as authorized researcher; load and export.
- Sign in as another account; confirm assessments cannot be read.
- Test a narrow mobile viewport; check map search, choice cards and sticky action buttons.

## Known limits

- Dashboard only loads and exports the latest **500** assessments. It is **not** an all-time total.
- Local drafts are stored in browser preferences, not encrypted and not synchronized. Warn participants on shared devices and offer discard.
- Place search results are new assessment points, **not** matched to existing contributed Firestore places. For those, use Existing places.
- Researcher email is a deployment setting and must be filled in before launch.
- This environment has no Flutter SDK / Firebase emulator installed, so the package is **not build-tested here**. GitHub Actions and Vercel Preview must pass before production.
