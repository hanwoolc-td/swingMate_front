import assert from "node:assert/strict";
import { createEditHistory } from "./edit-history.js";

const history = createEditHistory(2);
history.reset({ points: [] });
history.commit({ points: [1] });
history.commit({ points: [1, 2] });
history.commit({ points: [1, 2, 3] });
assert.equal(history.size, 2);
assert.deepEqual(history.undo(), { points: [1, 2] });
assert.deepEqual(history.undo(), { points: [1] });
assert.equal(history.undo(), null);
assert.deepEqual(history.redo(), { points: [1, 2] });
history.commit({ points: [9] });
assert.equal(history.canRedo, false);
assert.equal(history.commit({ points: [9] }), false);

console.log("edit-history.test.js: 전부 통과");
