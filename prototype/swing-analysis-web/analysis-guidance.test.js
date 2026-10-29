import assert from "node:assert/strict";
import { guidanceFor, mapAnalysisReason } from "./analysis-guidance.js";

assert.equal(mapAnalysisReason("missing_wrist"), "WRIST_OCCLUDED");
assert.equal(mapAnalysisReason("position_jump"), "WRIST_TRACK_UNSTABLE");
assert.equal(mapAnalysisReason("REQUIRED_JOINT_MISSING", "pelvis_line_tilt"), "REQUIRED_JOINT_UNAVAILABLE");
assert.equal(guidanceFor("POSE_DATA_UNAVAILABLE").manualAllowed, true);
assert.match(guidanceFor("CAMERA_ALIGNMENT_UNCONFIRMED").action, /카메라/);

console.log("analysis-guidance.test.js: 전부 통과");
