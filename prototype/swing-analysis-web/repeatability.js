import { frameAtTime, handObservation } from "./pose-track.js";

export const REPEATABILITY_CONFIG = Object.freeze({
  version: 1,
  minSwings: 3,
  supportedDirections: Object.freeze(["FACE_ON", "DOWN_THE_LINE"]),
  supportedClubs: Object.freeze(["7_IRON"]),
  progressSamples: 61,
  phaseProgress: Object.freeze({ address: 0, top: 0.4, impact: 0.7, finish: 1 }),
  // 프로 코치 검증 전 개발용 표시 임계값이다.
  tempoRangeStableMs: 120,
  pathSpreadStableTorso: 0.12,
  angleRangeStableDeg: 5,
});

const EVENT_NAMES = ["address", "top", "impact", "finish"];

const mean = (values) => values.reduce((sum, value) => sum + value, 0) / values.length;
const range = (values) => values.length ? Math.max(...values) - Math.min(...values) : NaN;

export function validateSession(session, config = REPEATABILITY_CONFIG) {
  const errors = [];
  const warnings = [];
  if (!session || !Array.isArray(session.swings)) return { valid: false, errors: ["세션 데이터가 없습니다."], warnings };
  if (!session.direction) errors.push("촬영 방향이 없습니다.");
  if (!session.club) errors.push("클럽 정보가 없습니다.");
  if (session.direction && !config.supportedDirections.includes(session.direction)) errors.push("지원하지 않는 촬영 방향입니다.");
  if (session.club && !config.supportedClubs.includes(session.club)) errors.push("현재 v1은 7번 아이언 세션만 지원합니다.");
  if (session.swings.length < config.minSwings) errors.push(`반복성 분석에는 최소 ${config.minSwings}회가 필요합니다.`);

  for (const [index, swing] of session.swings.entries()) {
    const label = swing.id || `스윙 ${index + 1}`;
    if (swing.direction !== session.direction) errors.push(`${label}: 세션과 촬영 방향이 다릅니다.`);
    if (swing.club !== session.club) errors.push(`${label}: 세션과 클럽이 다릅니다.`);
    if (!Array.isArray(swing.frames) || swing.frames.length < 2) {
      errors.push(`${label}: 자세 프레임이 부족합니다.`);
      continue;
    }
    for (let i = 1; i < swing.frames.length; i++) {
      if (!(swing.frames[i].t > swing.frames[i - 1].t)) {
        errors.push(`${label}: 프레임 시각이 단조 증가하지 않습니다.`);
        break;
      }
    }
    const events = swing.events || {};
    if (EVENT_NAMES.some((name) => !Number.isFinite(events[name]))) {
      errors.push(`${label}: 어드레스·탑·임팩트·피니시 시각이 모두 필요합니다.`);
      continue;
    }
    if (!(events.address < events.top && events.top < events.impact && events.impact < events.finish)) {
      errors.push(`${label}: 이벤트 순서가 올바르지 않습니다.`);
    }
    if (swing.eventSource === "auto" && swing.eventConfidence != null && swing.eventConfidence < 0.7) {
      errors.push(`${label}: 자동 이벤트 신뢰도가 낮아 비교에서 제외됩니다.`);
    }
  }
  if (session.swings.length < 5) warnings.push("소표본 세션이므로 개별값과 관측 범위를 우선 해석하세요.");
  return { valid: errors.length === 0, errors, warnings };
}

export function timeAtProgress(events, progress, config = REPEATABILITY_CONFIG) {
  const phases = [
    ["address", "top"],
    ["top", "impact"],
    ["impact", "finish"],
  ];
  const anchors = config.phaseProgress;
  for (const [from, to] of phases) {
    if (progress <= anchors[to] || to === "finish") {
      const span = anchors[to] - anchors[from];
      const mix = span ? (progress - anchors[from]) / span : 0;
      return events[from] + (events[to] - events[from]) * Math.max(0, Math.min(1, mix));
    }
  }
  return events.finish;
}

function midpoint(a, b) {
  return a && b ? { x: (a.x + b.x) / 2, y: (a.y + b.y) / 2 } : null;
}

export function normalizationForSwing(swing) {
  const frame = frameAtTime(swing.frames, swing.events.address);
  if (!frame) return null;
  const joints = frame.joints;
  const shoulder = midpoint(joints.leftShoulder, joints.rightShoulder);
  const hip = midpoint(joints.leftHip, joints.rightHip);
  if (!shoulder || !hip) return null;
  const torso = Math.hypot(shoulder.x - hip.x, shoulder.y - hip.y);
  if (!(torso > 0)) return null;
  const roll = ((swing.cameraRollDeg || 0) * Math.PI) / 180;
  return { origin: hip, torso, cos: Math.cos(-roll), sin: Math.sin(-roll) };
}

export function normalizePoint(point, normalization, mirrored = false) {
  const dx = (point.x - normalization.origin.x) / normalization.torso;
  const dy = (point.y - normalization.origin.y) / normalization.torso;
  const x = dx * normalization.cos - dy * normalization.sin;
  const y = dx * normalization.sin + dy * normalization.cos;
  return { x: mirrored ? -x : x, y };
}

function normalizedJoint(frame, name, normalization, mirrored) {
  const joint = frame?.joints?.[name];
  return joint ? normalizePoint(joint, normalization, mirrored) : null;
}

function axisAngle(a, b) {
  if (!a || !b) return NaN;
  let angle = Math.atan2(b.y - a.y, b.x - a.x) * 180 / Math.PI;
  while (angle >= 90) angle -= 180;
  while (angle < -90) angle += 180;
  return angle;
}

export function unwrapAxisAngles(values) {
  if (!values.length) return [];
  const reference = values[0];
  return values.map((value) => {
    let result = value;
    while (result - reference > 90) result -= 180;
    while (result - reference < -90) result += 180;
    return result;
  });
}

function sampleSwing(swing, config) {
  const normalization = normalizationForSwing(swing);
  if (!normalization) return { error: "어드레스 몸통 기준을 만들 수 없습니다." };
  const mirrored = Boolean(swing.mirrored) !== (swing.handedness === "LEFT");
  const path = [];
  for (let index = 0; index < config.progressSamples; index++) {
    const progress = index / (config.progressSamples - 1);
    const t = timeAtProgress(swing.events, progress, config);
    const frame = frameAtTime(swing.frames, t);
    const hand = frame ? handObservation(frame) : { valid: false };
    path.push(hand.valid ? normalizePoint(hand, normalization, mirrored) : null);
  }
  const eventFrames = Object.fromEntries(EVENT_NAMES.map((name) => [name, frameAtTime(swing.frames, swing.events[name])]));
  const angleAt = (eventName, a, b) => {
    const frame = eventFrames[eventName];
    return axisAngle(
      normalizedJoint(frame, a, normalization, mirrored),
      normalizedJoint(frame, b, normalization, mirrored),
    );
  };
  return {
    id: swing.id,
    label: swing.label || swing.id,
    path,
    timings: {
      totalMs: (swing.events.finish - swing.events.address) * 1000,
      backswingMs: (swing.events.top - swing.events.address) * 1000,
      downswingMs: (swing.events.impact - swing.events.top) * 1000,
    },
    angles: {
      addressShoulder: angleAt("address", "leftShoulder", "rightShoulder"),
      addressHip: angleAt("address", "leftHip", "rightHip"),
      impactShoulder: angleAt("impact", "leftShoulder", "rightShoulder"),
      impactHip: angleAt("impact", "leftHip", "rightHip"),
    },
  };
}

function statusFor(value, stableLimit) {
  if (!Number.isFinite(value)) return "UNAVAILABLE";
  return value <= stableLimit ? "STABLE" : "CHECK";
}

export function analyzeRepeatability(session, config = REPEATABILITY_CONFIG) {
  const validation = validateSession(session, config);
  if (!validation.valid) return { ok: false, ...validation };

  const swings = session.swings.map((swing) => sampleSwing(swing, config));
  const sampleError = swings.find((swing) => swing.error);
  if (sampleError) return { ok: false, errors: [sampleError.error], warnings: validation.warnings };

  const path = [];
  for (let index = 0; index < config.progressSamples; index++) {
    const points = swings.map((swing) => swing.path[index]).filter(Boolean);
    if (points.length < config.minSwings) {
      path.push(null);
      continue;
    }
    const center = { x: mean(points.map((p) => p.x)), y: mean(points.map((p) => p.y)) };
    const distances = points.map((point) => Math.hypot(point.x - center.x, point.y - center.y));
    path.push({ progress: index / (config.progressSamples - 1), center, radius: Math.max(...distances), count: points.length });
  }
  const pathRadii = path.filter(Boolean).map((point) => point.radius);
  const pathMaxSpread = pathRadii.length ? Math.max(...pathRadii) : NaN;

  const timingMetric = (name) => {
    const values = swings.map((swing) => swing.timings[name]);
    const observedRange = range(values);
    return { values, mean: mean(values), range: observedRange, status: statusFor(observedRange, config.tempoRangeStableMs) };
  };
  const angleMetric = (name) => {
    const values = unwrapAxisAngles(swings.map((swing) => swing.angles[name]).filter(Number.isFinite));
    if (values.length < config.minSwings) return { values, status: "UNAVAILABLE" };
    const observedRange = range(values);
    return { values, mean: mean(values), range: observedRange, status: statusFor(observedRange, config.angleRangeStableDeg) };
  };

  return {
    ok: true,
    warnings: validation.warnings,
    session: { id: session.id, direction: session.direction, club: session.club, swingCount: swings.length },
    swings,
    path,
    metrics: {
      totalTime: timingMetric("totalMs"),
      backswingTime: timingMetric("backswingMs"),
      downswingTime: timingMetric("downswingMs"),
      addressShoulder: angleMetric("addressShoulder"),
      addressHip: angleMetric("addressHip"),
      impactShoulder: angleMetric("impactShoulder"),
      impactHip: angleMetric("impactHip"),
      handPath: {
        maxSpread: pathMaxSpread,
        validSamples: pathRadii.length,
        status: statusFor(pathMaxSpread, config.pathSpreadStableTorso),
      },
    },
  };
}

export function createSyntheticSession(poseData) {
  const variants = [
    { id: "swing-1", label: "스윙 1", time: 1, dx: 0, wristWave: 0 },
    { id: "swing-2", label: "스윙 2", time: 1.025, dx: 0.035, wristWave: 0.008 },
    { id: "swing-3", label: "스윙 3", time: 0.98, dx: -0.025, wristWave: -0.01 },
  ];
  return {
    app: "swingmate-repeatability",
    version: 1,
    id: "synthetic-face-on-demo",
    direction: "FACE_ON",
    club: "7_IRON",
    synthetic: true,
    swings: variants.map((variant, variantIndex) => ({
      id: variant.id,
      label: variant.label,
      direction: "FACE_ON",
      club: "7_IRON",
      handedness: "RIGHT",
      mirrored: false,
      cameraRollDeg: 0,
      eventSource: "manual",
      events: { address: 0.4 * variant.time, top: 3.0 * variant.time, impact: 4.05 * variant.time, finish: 6.1 * variant.time },
      frames: poseData.frames.map((frame, frameIndex) => ({
        t: frame.t * variant.time,
        joints: Object.fromEntries(Object.entries(frame.joints).map(([name, joint]) => {
          const isWrist = name === "leftWrist" || name === "rightWrist";
          const wave = isWrist ? Math.sin(frameIndex / 9 + variantIndex) * variant.wristWave : 0;
          return [name, { ...joint, x: joint.x + variant.dx + wave }];
        })),
      })),
    })),
  };
}
