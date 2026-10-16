# Readable place names — October 2026

Existing place documents store coordinates but not a human-readable name. This upgrade
adds a best-effort reverse-geocoded address to the **Existing places** list and
researcher place summary cards. Coordinates and research IDs remain available.

- Uses Google Maps JavaScript Geocoder; **enable Geocoding API** in the same Google Cloud
  project as the Maps browser key and ensure the key permits it.
- Geocoding can incur Google Maps Platform usage charges. Responses are cached in memory
  for the current browser session, not stored in Firestore.
- Addresses are approximate: reverse geocoding is not guaranteed to return the name of
  the precise venue. The fallback is `Location near LAT, LNG`.
- No Firestore schema/rules changes; existing assessments remain intact.
- The existing list still loads the first 100 places, not a geographic nearest-neighbor search.
- Consider future explicit place-name capture at submission time, plus a reviewed migration
  for older records. Do not automatically write guessed geocoder names to research data.

Build verification: requires GitHub Actions / Vercel Preview; Flutter SDK unavailable here.
