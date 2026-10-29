import assert from "node:assert/strict";
import { createViewport, panViewport, screenToCanvas, zoomViewport } from "./viewport-transform.js";

const stage = { w: 720, h: 600 };
let view = createViewport();
view = zoomViewport(view, 4, { x: 200, y: 300 }, stage);
assert.equal(view.zoom, 4);
const base = screenToCanvas({ x: 200, y: 300 }, view, stage);
assert.ok(Math.abs(base.x - 200) < 1e-9);
assert.ok(Math.abs(base.y - 300) < 1e-9);
view = panViewport(view, 30, -20);
const shifted = screenToCanvas({ x: 230, y: 280 }, view, stage);
assert.ok(Math.abs(shifted.x - 200) < 1e-9);
assert.ok(Math.abs(shifted.y - 300) < 1e-9);
assert.equal(zoomViewport(view, 99, { x: 0, y: 0 }, stage).zoom, 4);

console.log("viewport-transform.test.js: 전부 통과");
