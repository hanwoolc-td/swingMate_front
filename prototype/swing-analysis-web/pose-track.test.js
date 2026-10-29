import assert from "node:assert/strict";
import { buildHandTrack, frameAtTime, handObservation, interpolatePose, shouldDisplayHandTrack } from "./pose-track.js";

const wrist = (x, y, confidence = 0.9) => ({ x, y, confidence });
const frame = (t, left, right, extra = {}) => ({
  t,
  joints: { leftWrist: left, rightWrist: right, ...extra },
});

{
  const frames = [frame(0, wrist(.1, .1), wrist(.12, .1)), frame(.08, wrist(.2, .2), wrist(.22, .2))];
  assert.equal(frameAtTime(frames, .07), frames[1], "실제 t 기준으로 가장 가까운 프레임을 선택");
}

{
  const frames = [
    frame(0, wrist(.1, .1), wrist(.12, .1), { neck: wrist(.2, .2) }),
    frame(.1, wrist(.2, .2), wrist(.22, .2)),
  ];
  const pose = interpolatePose(frames, .05);
  assert.equal(pose.neck, undefined, "한쪽 프레임에서 누락된 관절을 가짜 보간하지 않음");
  assert.ok(Math.abs(pose.leftWrist.x - .15) < 1e-9);
}

{
  const oneWrist = frame(0, wrist(.1, .1), undefined);
  assert.equal(handObservation(oneWrist).reason, "missing_wrist", "한 손목을 양손 중심으로 대체하지 않음");
  const low = frame(0, wrist(.1, .1, .2), wrist(.12, .1, .8));
  assert.equal(handObservation(low).reason, "low_confidence");
  const spread = frame(0, wrist(.1, .1), wrist(.4, .1));
  assert.equal(handObservation(spread).reason, "wrist_pair_spread");
}

{
  const frames = [
    frame(0, wrist(.1, .1), wrist(.12, .1)),
    frame(.067, wrist(.11, .1), wrist(.13, .1)),
    frame(.134, wrist(.2, .2, .1), wrist(.22, .2)),
    frame(.201, wrist(.3, .3), wrist(.32, .3)),
    frame(.268, wrist(.31, .3), wrist(.33, .3)),
  ];
  const track = buildHandTrack(frames);
  assert.equal(track.segments.length, 2, "결측 구간을 가로질러 선을 잇지 않음");
  assert.equal(track.rejected[0].reason, "low_confidence");
  assert.equal(track.accepted, 4);
}

assert.equal(shouldDisplayHandTrack({ quality: "GOOD" }), true);
assert.equal(shouldDisplayHandTrack({ quality: "LIMITED" }), false, "LIMITED 경로는 제품 화면에 그리지 않음");
assert.equal(shouldDisplayHandTrack({ quality: "UNAVAILABLE" }), false);

console.log("pose-track.test.js: 전부 통과");
