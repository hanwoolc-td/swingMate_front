import assert from "node:assert/strict";
import { buildMetricEvidence, displayValueFor, jointCoverage, metricDefinition, reliabilityForCoverage } from "./metrics.js";

assert.equal(reliabilityForCoverage(.95, { cameraAligned: true }), "HIGH");
assert.equal(reliabilityForCoverage(.95), "MEDIUM");
assert.equal(reliabilityForCoverage(.6), "LOW");
assert.equal(reliabilityForCoverage(.49), "UNAVAILABLE");
assert.equal(displayValueFor(12.4, "HIGH"), 12);
assert.equal(displayValueFor(12.4, "MEDIUM"), 10);
assert.equal(displayValueFor(-2, "LOW"), "- 방향");
assert.equal(displayValueFor(12.4, "UNAVAILABLE"), null);
assert.equal(metricDefinition("club_path").measurable, false);
assert.throws(() => buildMetricEvidence({ id: "x", metricId: "club_path", view: "DOWN_THE_LINE", rawValue: 2, coverage: 1 }), /not measurable/);

const frames = [
  { joints: { neck: { confidence: .9 }, root: { confidence: .9 } } },
  { joints: { neck: { confidence: .2 }, root: { confidence: .9 } } },
];
assert.equal(jointCoverage(frames, ["neck", "root"]), .5);

const unavailable = buildMetricEvidence({
  id: "e2",
  metricId: "spine_tilt_lateral",
  view: "FACE_ON",
  rawValue: 7.2,
  coverage: .4,
});
assert.equal(unavailable.reliability.grade, "UNAVAILABLE");
assert.equal(unavailable.observation.rawValue, 7.2);
assert.equal(unavailable.observation.displayValue, null);

console.log("metrics.test.js: 전부 통과");
