import assert from "node:assert/strict";
import { createEvidenceRecord, validateEvidenceRecord } from "./evidence.js";

const base = {
  id: "e1",
  metricId: "spine_tilt_lateral",
  layer: "L2",
  evidenceIds: ["EV-SR-01"],
  inputConditions: { view: "FACE_ON" },
  reliability: { grade: "MEDIUM", coverage: .8, reasons: [] },
  observation: { rawValue: 7.2, displayValue: 5, unit: "deg", window: "address", n: 1 },
  basis: { kind: "NONE", ref: null },
  verdict: { kind: "OBSERVATION_ONLY", text: "관측값" },
  limits: ["2D 투영값"],
  coachReview: { status: "NONE", editedValue: null, by: null, at: null },
};

assert.equal(createEvidenceRecord(base).observation.displayValue, 5);
assert.throws(() => validateEvidenceRecord({ ...base, evidenceIds: [] }), /evidenceIds/);
assert.throws(() => validateEvidenceRecord({ ...base, verdict: { kind: "WITHIN_OWN_RANGE" } }), /comparison basis/);
assert.throws(() => validateEvidenceRecord({
  ...base,
  reliability: { grade: "UNAVAILABLE", coverage: .4, reasons: ["LOW"] },
}), /displayValue/);
assert.doesNotThrow(() => validateEvidenceRecord({
  ...base,
  reliability: { grade: "UNAVAILABLE", coverage: .4, reasons: ["LOW"] },
  observation: { ...base.observation, rawValue: 7.2, displayValue: null },
  verdict: { kind: "NOT_EVALUATED", text: "측정 불가" },
}));

console.log("evidence.test.js: 전부 통과");
