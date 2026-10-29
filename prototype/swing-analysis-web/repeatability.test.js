import assert from "node:assert/strict";
import { analyzeRepeatability, normalizePoint, timeAtProgress, unwrapAxisAngles, validateSession } from "./repeatability.js";

const joint = (x, y, confidence = .95) => ({ x, y, confidence });
const makeSwing = (id, { dx = 0, scale = 1, time = 1, pathOffset = 0, direction = "FACE_ON", club = "7_IRON" } = {}) => {
  const transform = (x, y) => ({ x: .5 + dx + (x - .5) * scale, y: .55 + (y - .55) * scale });
  const frames = [];
  for (let index = 0; index <= 40; index++) {
    const t = index * .05 * time;
    const hand = transform(.5 + .08 * Math.sin(index / 8) + pathOffset, .48 + .05 * Math.cos(index / 8));
    const leftShoulder = transform(.45, .35), rightShoulder = transform(.55, .35);
    const leftHip = transform(.46, .55), rightHip = transform(.54, .55);
    frames.push({ t, joints: {
      leftShoulder: joint(leftShoulder.x, leftShoulder.y), rightShoulder: joint(rightShoulder.x, rightShoulder.y),
      leftHip: joint(leftHip.x, leftHip.y), rightHip: joint(rightHip.x, rightHip.y),
      leftWrist: joint(hand.x - .01 * scale, hand.y), rightWrist: joint(hand.x + .01 * scale, hand.y),
    }});
  }
  return {
    id, direction, club, handedness: "RIGHT", mirrored: false,
    events: { address: .1 * time, top: .8 * time, impact: 1.2 * time, finish: 1.9 * time },
    frames,
  };
};

const session = (swings) => ({ id: "test", direction: "FACE_ON", club: "7_IRON", swings });

{
  const events = { address: 0, top: 1, impact: 1.5, finish: 2.5 };
  assert.equal(timeAtProgress(events, .4), 1);
  assert.equal(timeAtProgress(events, .7), 1.5);
  assert.equal(timeAtProgress(events, 1), 2.5);
}

{
  const normalized = normalizePoint({ x: 12, y: 24 }, { origin: { x: 10, y: 20 }, torso: 2, cos: 1, sin: 0 });
  assert.deepEqual(normalized, { x: 1, y: 2 });
}

{
  assert.deepEqual(unwrapAxisAngles([89, -89]), [89, 91], "180도 축 경계에서 최소각 차 사용");
}

{
  const result = analyzeRepeatability(session([
    makeSwing("a"), makeSwing("b", { dx: .2, scale: 1.1, time: 1.02 }), makeSwing("c", { dx: -.1, scale: .9, time: .98 }),
  ]));
  assert.equal(result.ok, true);
  assert.equal(result.metrics.handPath.status, "STABLE", "평행이동과 크기 차이를 정규화");
  assert.ok(result.metrics.totalTime.range > 0);
}

{
  const tooFew = analyzeRepeatability(session([makeSwing("a"), makeSwing("b")]));
  assert.equal(tooFew.ok, false);
  assert.match(tooFew.errors[0], /최소 3회/);
}

{
  const mismatch = validateSession(session([makeSwing("a"), makeSwing("b"), makeSwing("c", { direction: "DOWN_THE_LINE" })]));
  assert.equal(mismatch.valid, false);
  assert.ok(mismatch.errors.some((error) => error.includes("촬영 방향")));
}

{
  const unsupported = validateSession({ ...session([makeSwing("a"), makeSwing("b"), makeSwing("c")]), club: "DRIVER" });
  assert.ok(unsupported.errors.some((error) => error.includes("7번 아이언")));
}

{
  const bad = makeSwing("bad");
  bad.frames[3].t = bad.frames[2].t;
  const invalidPts = validateSession(session([makeSwing("a"), makeSwing("b"), bad]));
  assert.ok(invalidPts.errors.some((error) => error.includes("단조 증가")));
}

console.log("repeatability.test.js: 전부 통과");
