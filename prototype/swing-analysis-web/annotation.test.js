import assert from "node:assert/strict";
import { threePointAngle, validateTraceTarget } from "./annotation.js";

assert.equal(Math.round(threePointAngle([
  { x: .1, y: .5 }, { x: .5, y: .5 }, { x: .5, y: .2 },
], { w: 1080, h: 1920 })), 90);
assert.ok(Number.isNaN(threePointAngle([{ x: 0, y: 0 }], { w: 1080, h: 1920 })));
assert.ok(Number.isNaN(threePointAngle([
  { x: .5, y: .5 }, { x: .5, y: .5 }, { x: .7, y: .7 },
], { w: 1080, h: 1920 })));
assert.equal(validateTraceTarget("CLUBHEAD"), "CLUBHEAD");
assert.throws(() => validateTraceTarget(""), /required/);
assert.throws(() => validateTraceTarget("WRIST_GUESSED"), /required/);

console.log("annotation.test.js: 전부 통과");
