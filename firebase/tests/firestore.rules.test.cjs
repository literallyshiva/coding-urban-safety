
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
  writeBatch,
  getDocs,
  collection,
} = require('firebase/firestore');
const fs = require('node:fs');

async function main() {
  const rulesText = fs.readFileSync('firebase/firestore.rules', 'utf8');
  const researcherEmail = rulesText.match(/request\.auth\.token\.email == '([^']+)'/)?.[1];
  if (!researcherEmail) throw new Error('Researcher email not configured in rules.');
  const env = await initializeTestEnvironment({
    projectId: 'demo-urban-safety-tests',
    firestore: {
      host: '127.0.0.1',
      port: 8080,
      rules: rulesText,
    },
  });

  try {
    const db = env.unauthenticatedContext().firestore();
    const location = new GeoPoint(8.5241, 76.9366);

    const placeRef = doc(db, 'places', 'test-place-001');

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

    const assessmentRef = doc(
      db,
      'assessments',
      'test-assessment-001',
    );

    const initialBatch = writeBatch(db);
    initialBatch.set(placeRef, {
      location,
      created_at: serverTimestamp(),
      assessment_id: 'test-assessment-001',
    });
    initialBatch.set(assessmentRef, validAssessment);
    await assertSucceeds(initialBatch.commit());
    console.log('PASS: Atomically create place and first assessment');

    await assertSucceeds(getDoc(placeRef));
    console.log('PASS: Read contributed place');

    await assertFails(setDoc(doc(db, 'places', 'orphan-place'), {
      location,
      created_at: serverTimestamp(),
      assessment_id: 'nonexistent-assessment',
    }));
    console.log('PASS: Reject orphan place');

    await assertFails(setDoc(doc(db, 'places', 'legacy-orphan'), {
      location,
      created_at: serverTimestamp(),
    }));
    console.log('PASS: Reject legacy standalone place creation');

    const incompleteBatch = writeBatch(db);
    incompleteBatch.set(doc(db, 'places', 'invalid-batch-place'), {
      location,
      created_at: serverTimestamp(),
      assessment_id: 'invalid-batch-assessment',
    });
    incompleteBatch.set(doc(db, 'assessments', 'invalid-batch-assessment'), {
      ...validAssessment,
      place_id: 'invalid-batch-place',
      safety_rating: 9,
    });
    await assertFails(incompleteBatch.commit());
    console.log('PASS: Reject invalid atomic batch');

    console.log('PASS: Create linked assessment');

    await assertFails(getDoc(assessmentRef));
    console.log('PASS: Deny public assessment read');

    const researcher = env.authenticatedContext('researcher-user', {
      email: researcherEmail,
      email_verified: true,
    }).firestore();
    await assertSucceeds(getDoc(doc(researcher, 'assessments', 'test-assessment-001')));
    await assertSucceeds(getDocs(collection(researcher, 'assessments')));
    console.log('PASS: Verified researcher can read assessments');

    const unverified = env.authenticatedContext('unverified-user', {
      email: researcherEmail,
      email_verified: false,
    }).firestore();
    await assertFails(getDoc(doc(unverified, 'assessments', 'test-assessment-001')));
    console.log('PASS: Reject unverified email');

    const outsider = env.authenticatedContext('outsider-user', {
      email: 'other@example.com', email_verified: true,
    }).firestore();
    await assertFails(getDoc(doc(outsider, 'assessments', 'test-assessment-001')));
    console.log('PASS: Reject unauthorized account');

    await assertFails(updateDoc(
      assessmentRef,
      { safety_rating: 1 },
    ));
    console.log('PASS: Deny assessment update');

    await assertFails(deleteDoc(assessmentRef));
    console.log('PASS: Deny assessment deletion');

    await assertFails(setDoc(
      doc(db, 'assessments', 'invalid-place'),
      {
        ...validAssessment,
        place_id: 'nonexistent-place',
      },
    ));
    console.log('PASS: Reject nonexistent place');

    await assertFails(setDoc(
      doc(db, 'assessments', 'invalid-rating'),
      {
        ...validAssessment,
        safety_rating: 6,
      },
    ));
    console.log('PASS: Reject invalid rating');

    await assertFails(setDoc(
      doc(db, 'assessments', 'oversized-text'),
      {
        ...validAssessment,
        other_suggestion: 'x'.repeat(1001),
      },
    ));
    console.log('PASS: Reject oversized text');

    await assertFails(setDoc(
      doc(db, 'assessments', 'extra-field'),
      {
        ...validAssessment,
        unexpected_field: true,
      },
    ));
    console.log('PASS: Reject unexpected field');

    await assertFails(setDoc(
      doc(db, 'assessments', 'invalid-unsafe-option'),
      {
        ...validAssessment,
        unsafe_conditions: ['Not a real option'],
      },
    ));
    console.log('PASS: Reject unrecognized unsafe-condition option');

    await assertFails(setDoc(
      doc(db, 'assessments', 'invalid-experience-option'),
      {
        ...validAssessment,
        place_experience: ['Fake experience'],
      },
    ));
    console.log('PASS: Reject unrecognized experience option');

    await assertFails(setDoc(
      doc(db, 'assessments', 'invalid-spatial-option'),
      {
        ...validAssessment,
        spatial_conditions: ['Fake spatial condition'],
      },
    ));
    console.log('PASS: Reject unrecognized spatial option');

    await assertFails(setDoc(
      doc(db, 'assessments', 'invalid-ludic-option'),
      {
        ...validAssessment,
        ludic_qualities: ['Fake ludic quality'],
      },
    ));
    console.log('PASS: Reject unrecognized ludic option');

    await assertFails(setDoc(
      doc(db, 'assessments', 'invalid-design-option'),
      {
        ...validAssessment,
        design_responses: ['Fake design response'],
      },
    ));
    console.log('PASS: Reject unrecognized design option');

    await assertFails(setDoc(
      doc(db, 'assessments', 'invalid-spend-more-time'),
      {
        ...validAssessment,
        spend_more_time: 'yes',
      },
    ));
    console.log('PASS: Reject invalid spend-more-time value');

    await assertFails(setDoc(
      doc(db, 'assessments', 'wrong-location'),
      {
        ...validAssessment,
        location: new GeoPoint(8.5242, 76.9366),
      },
    ));
    console.log('PASS: Reject mismatched place coordinates');

    await assertSucceeds(setDoc(
      doc(db, 'assessments', 'second-valid-review'),
      {
        ...validAssessment,
        location_source: 'existing',
      },
    ));
    console.log('PASS: Accept second assessment for existing place');

    // Optional gender: accepted values
    for (const gender of ['Male', 'Female', 'Other']) {
      await assertSucceeds(setDoc(
        doc(
          db,
          'assessments',
          `valid-gender-${gender.toLowerCase()}`,
        ),
        {
          ...validAssessment,
          gender,
        },
      ));
      console.log(`PASS: Accept gender ${gender}`);
    }

    // Gender may be omitted entirely.
    await assertSucceeds(setDoc(
      doc(db, 'assessments', 'gender-not-provided'),
      {
        ...validAssessment,
      },
    ));
    console.log('PASS: Accept assessment without gender');

    // Invalid gender values must be rejected.
    const invalidGenders = [
      'Unknown',
      'male',
      '',
      123,
      true,
      null,
      ['Male'],
    ];

    for (let i = 0; i < invalidGenders.length; i++) {
      await assertFails(setDoc(
        doc(db, 'assessments', `invalid-gender-${i}`),
        {
          ...validAssessment,
          gender: invalidGenders[i],
        },
      ));
      console.log(
        `PASS: Reject invalid gender ${i + 1}`,
      );
    }

    // A valid gender does not bypass other security checks.
    await assertFails(setDoc(
      doc(db, 'assessments', 'gender-invalid-rating'),
      {
        ...validAssessment,
        gender: 'Female',
        safety_rating: 6,
      },
    ));
    console.log('PASS: Reject invalid rating with gender');

    await assertFails(setDoc(
      doc(db, 'assessments', 'gender-extra-field'),
      {
        ...validAssessment,
        gender: 'Other',
        unexpected_field: true,
      },
    ));
    console.log('PASS: Reject extra field with gender');

    console.log('ALL FIRESTORE SECURITY TESTS PASSED');
  } finally {
    await env.cleanup();
  }
}

main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
