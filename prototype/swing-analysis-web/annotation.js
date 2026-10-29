export const TRACE_TARGETS = Object.freeze(["HAND", "CLUBHEAD", "SHAFT_TIP", "OTHER"]);

export function validateTraceTarget(target) {
  if (!TRACE_TARGETS.includes(target)) throw new Error("manual trace target is required");
  return target;
}

export function threePointAngle(points, videoSize) {
  if (!Array.isArray(points) || points.length !== 3) return NaN;
  if (!Number.isFinite(videoSize?.w) || !Number.isFinite(videoSize?.h) || videoSize.w <= 0 || videoSize.h <= 0) return NaN;
  const [a, vertex, c] = points.map((point) => ({ x: point.x * videoSize.w, y: point.y * videoSize.h }));
  const first = { x: a.x - vertex.x, y: a.y - vertex.y };
  const second = { x: c.x - vertex.x, y: c.y - vertex.y };
  const denominator = Math.hypot(first.x, first.y) * Math.hypot(second.x, second.y);
  if (!denominator) return NaN;
  const cosine = Math.max(-1, Math.min(1, (first.x * second.x + first.y * second.y) / denominator));
  return Math.acos(cosine) * 180 / Math.PI;
}
