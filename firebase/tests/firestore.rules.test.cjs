
const assert = require('node:assert/strict');
const {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} = require('@firebase/rules-unit-testing');
const {
  doc,
  setDoc,
  getDoc,
  updateDoc,
  deleteDoc,
  GeoPoint,
  serverTimestamp,
} = require('firebase/firestore');
const fs = require('node:fs');

async function main() {
  const env = await initializeTestEnvironment({
    projectId: 'demo-urban-safety-tests',
    firestore: {
      host: '127.0.0.1',
      port: 8080,
      rules: fs.readFileSync('firebase/firestore.rules', 'utf8'),
    },
  });

  try {
    const db = env.unauthenticatedContext().firestore();
    const location = new GeoPoint(8.5241, 76.9366);

    const placeRef = doc(db, 'places', 'test-place-001');

    await assertSucceeds(setDoc(placeRef, {
      location,
      created_at: serverTimestamp(),
    }));
    console.log('PASS: Create valid place');

    await assertSucceeds(getDoc(placeRef));
    console.log('PASS: Read contributed place');

    const validAssessment = {
      place_id: 'test-place-001',
      location_source: 'manual',
      location,
      safety_rating: 4,
      unsafe_conditions: [],
      place_experience: [],
      spend_more_time: 'YES',
      spatial_conditions: [],
      ludic_qualities: [],
      ludic_rating: 4,
      design_responses: [],
      other_suggestion: '',
      created_at: serverTimestamp(),
    };

    const assessmentRef = doc(db, 'assessments', 'test-assessment-001');

    await assertSucceeds(setDoc(assessmentRef, validAssessment));
    console.log('PASS: Create linked assessment');

    await assertFails(getDoc(assessmentRef));
    console.log('PASS: Deny public assessment read');

    await assertFails(updateDoc(assessmentRef, { safety_rating: 1 }));
    console.log('PASS: Deny assessment update');

    await assertFails(deleteDoc(assessmentRef));
    console.log('PASS: Deny assessment deletion');

    await assertFails(setDoc(
      doc(db, 'assessments', 'invalid-place'),
      { ...validAssessment, place_id: 'nonexistent-place' },
    ));
    console.log('PASS: Reject nonexistent place');

    await assertFails(setDoc(
      doc(db, 'assessments', 'invalid-rating'),
      { ...validAssessment, safety_rating: 6 },
    ));
    console.log('PASS: Reject invalid rating');

    await assertFails(setDoc(
      doc(db, 'assessments', 'oversized-text'),
      { ...validAssessment, other_suggestion: 'x'.repeat(1001) },
    ));
    console.log('PASS: Reject oversized text');

    await assertFails(setDoc(
      doc(db, 'assessments', 'extra-field'),
      { ...validAssessment, unexpected_field: true },
    ));
    console.log('PASS: Reject unexpected field');

    console.log('ALL FIRESTORE SECURITY TESTS PASSED');
  } finally {
    await env.cleanup();
  }
}

main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
