const DEFAULTS = {
  minWristConfidence: 0.35,
  maxPairDistanceTorso: 0.8,
  maxPairDistanceFallback: 0.12,
  maxTimeGap: 0.11,
  maxJump: 0.14,
};

export function frameAtTime(frames, time) {
  if (!frames.length) return null;
  if (time <= frames[0].t) return frames[0];
  if (time >= frames[frames.length - 1].t) return frames[frames.length - 1];

  let low = 0;
  let high = frames.length - 1;
  while (low + 1 < high) {
    const middle = Math.floor((low + high) / 2);
    if (frames[middle].t <= time) low = middle;
    else high = middle;
  }
  return Math.abs(frames[low].t - time) <= Math.abs(frames[high].t - time)
    ? frames[low]
    : frames[high];
}

export function interpolatePose(frames, time) {
  if (!frames.length) return null;
  if (time <= frames[0].t) return frames[0].joints;
  if (time >= frames[frames.length - 1].t) return frames[frames.length - 1].joints;

  let low = 0;
  let high = frames.length - 1;
  while (low + 1 < high) {
    const middle = Math.floor((low + high) / 2);
    if (frames[middle].t <= time) low = middle;
    else high = middle;
  }

  const before = frames[low];
  const after = frames[high];
  const duration = after.t - before.t;
  if (duration <= 0) return before.joints;
  const mix = (time - before.t) / duration;
  const result = {};

  // 한쪽 프레임에서 누락된 관절을 다른 프레임 값으로 채우지 않는다.
  // 그 방식은 검출되지 않은 위치를 검출된 것처럼 보이게 만든다.
  for (const name of Object.keys(before.joints)) {
    const a = before.joints[name];
    const b = after.joints[name];
    if (!b) continue;
    result[name] = {
      x: a.x + (b.x - a.x) * mix,
      y: a.y + (b.y - a.y) * mix,
      confidence: Math.min(a.confidence, b.confidence),
    };
  }
  return result;
}

export function handObservation(frame, options = {}) {
  const config = { ...DEFAULTS, ...options };
  const left = frame.joints.leftWrist;
  const right = frame.joints.rightWrist;
  if (!left || !right) return { valid: false, reason: "missing_wrist", t: frame.t };
  const confidence = Math.min(left.confidence, right.confidence);
  if (confidence < config.minWristConfidence) {
    return { valid: false, reason: "low_confidence", confidence, t: frame.t };
  }
  const pairDistance = Math.hypot(left.x - right.x, left.y - right.y);
  const { leftShoulder, rightShoulder, leftHip, rightHip } = frame.joints;
  const hasTorso = leftShoulder && rightShoulder && leftHip && rightHip;
  const torsoLength = hasTorso
    ? Math.hypot(
        (leftShoulder.x + rightShoulder.x - leftHip.x - rightHip.x) / 2,
        (leftShoulder.y + rightShoulder.y - leftHip.y - rightHip.y) / 2,
      )
    : null;
  const pairDistanceTorso = torsoLength > 0 ? pairDistance / torsoLength : null;
  const pairTooWide = pairDistanceTorso == null
    ? pairDistance > config.maxPairDistanceFallback
    : pairDistanceTorso > config.maxPairDistanceTorso;
  if (pairTooWide) {
    return { valid: false, reason: "wrist_pair_spread", confidence, pairDistance, pairDistanceTorso, t: frame.t };
  }
  return {
    valid: true,
    t: frame.t,
    x: (left.x + right.x) / 2,
    y: (left.y + right.y) / 2,
    confidence,
    pairDistance,
    pairDistanceTorso,
  };
}

function smoothSegment(points) {
  return points.map((point, index) => {
    const from = Math.max(0, index - 1);
    const to = Math.min(points.length - 1, index + 1);
    const window = points.slice(from, to + 1);
    const weight = window.reduce((sum, item) => sum + item.confidence, 0);
    return {
      ...point,
      x: window.reduce((sum, item) => sum + item.x * item.confidence, 0) / weight,
      y: window.reduce((sum, item) => sum + item.y * item.confidence, 0) / weight,
    };
  });
}

export function buildHandTrack(frames, until = Infinity, options = {}) {
  const config = { ...DEFAULTS, ...options };
  const segments = [];
  const rejected = [];
  let total = 0;
  let current = [];

  const closeSegment = () => {
    if (current.length >= 2) segments.push(smoothSegment(current));
    current = [];
  };

  for (const frame of frames) {
    if (frame.t > until) break;
    total += 1;
    const point = handObservation(frame, config);
    if (!point.valid) {
      rejected.push(point);
      closeSegment();
      continue;
    }
    const previous = current[current.length - 1];
    if (previous) {
      const timeGap = point.t - previous.t;
      const jump = Math.hypot(point.x - previous.x, point.y - previous.y);
      if (timeGap > config.maxTimeGap || jump > config.maxJump) {
        rejected.push({ valid: false, reason: timeGap > config.maxTimeGap ? "time_gap" : "position_jump", t: point.t, jump, timeGap });
        closeSegment();
      }
    }
    current.push(point);
  }
  closeSegment();

  const accepted = segments.reduce((sum, segment) => sum + segment.length, 0);
  const ratio = total ? accepted / total : 0;
  const quality = ratio >= 0.8 ? "GOOD" : ratio >= 0.6 ? "LIMITED" : "UNAVAILABLE";
  return { segments, rejected, accepted, considered: total, ratio, quality };
}

// 제품 표시 게이트. LIMITED는 개발 진단에는 유용하지만 선수/코치 화면에
// 연속 경로로 그리면 누락 구간을 실제 스윙 변화처럼 오해할 수 있다.
export function shouldDisplayHandTrack(track) {
  return track?.quality === "GOOD";
}

export const HAND_TRACK_DEFAULTS = Object.freeze({ ...DEFAULTS });
