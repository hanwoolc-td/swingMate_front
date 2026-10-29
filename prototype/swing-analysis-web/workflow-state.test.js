import assert from "node:assert/strict";
import { confirmCapture, createWorkflowState, modeAvailability, selectVideo, startAnalysis } from "./workflow-state.js";

let state = createWorkflowState();
assert.equal(state.step, "VIDEO");
state = selectVideo(state, { poseAvailable: true, poseDirection: "FACE_ON" });
assert.equal(state.step, "CAPTURE");
assert.equal(modeAvailability(state, "MANUAL").enabled, true);
assert.equal(modeAvailability(state, "AUTO").enabled, false);
state = confirmCapture(state, { direction: "DOWN_THE_LINE", cameraAligned: true });
assert.match(modeAvailability(state, "AUTO").reason, /다릅니다/);
state = confirmCapture(state, { direction: "FACE_ON", cameraAligned: true });
assert.equal(modeAvailability(state, "AUTO").enabled, true);
state = startAnalysis(state, "AUTO");
assert.equal(state.step, "ANALYZE");
assert.equal(state.mode, "AUTO");
assert.throws(() => confirmCapture(createWorkflowState(), { direction: "FACE_ON" }), /video/);

console.log("workflow-state.test.js: 전부 통과");
