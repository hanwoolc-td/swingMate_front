import { createEvidenceRecord } from "./evidence.js";

export const METRIC_REGISTRY = Object.freeze({
  spine_tilt_lateral: metric("spine_tilt_lateral", "L2", ["FACE_ON"], ["neck", "root"], ["EV-SR-01"]),
  shoulder_line_tilt: metric("shoulder_line_tilt", "L2", ["FACE_ON"], ["leftShoulder", "rightShoulder"], ["EV-SR-01"]),
  pelvis_line_tilt: metric("pelvis_line_tilt", "L2", ["FACE_ON"], ["leftHip", "rightHip"], ["EV-SR-01"]),
  spine_tilt_forward: metric("spine_tilt_forward", "L2", ["DOWN_THE_LINE"], ["neck", "root"], ["EV-MK-01"]),
  wrist_center_path: metric("wrist_center_path", "L3", ["FACE_ON", "DOWN_THE_LINE"], ["leftWrist", "rightWrist"], ["EV-MK-01"]),
  club_path: metric("club_path", "L4", [], [], ["EV-TM-01"], false),
  face_to_path: metric("face_to_path", "L4", [], [], ["EV-TM-01"], false),
  attack_angle: metric("attack_angle", "L4", [], [], ["EV-TM-01"], false),
  ground_reaction_force: metric("ground_reaction_force", "L2", [], [], ["EV-SR-01"], false),
  lower_back_injury_risk: metric("lower_back_injury_risk", "L2", [], [], ["EV-SR-INJ-01"], false),
});

function metric(id, layer, views, requires, evidenceIds, measurable = true) {
  return Object.freeze({ id, layer, views: Object.freeze(views), requires: Object.freeze(requires), evidenceIds: Object.freeze(evidenceIds), measurable });
}

export function metricDefinition(metricId) {
  const definition = METRIC_REGISTRY[metricId];
  if (!definition) throw new Error(`unknown metric: ${metricId}`);
  return definition;
}

export function reliabilityForCoverage(coverage, { cameraAligned = false } = {}) {
  if (!Number.isFinite(coverage) || coverage < 0 || coverage > 1) throw new Error("invalid coverage");
  if (coverage >= .9 && cameraAligned) return "HIGH";
  if (coverage >= .7) return "MEDIUM";
  if (coverage >= .5) return "LOW";
  return "UNAVAILABLE";
}

export function displayValueFor(rawValue, grade, unit = "deg") {
  if (!Number.isFinite(rawValue) || grade === "UNAVAILABLE") return null;
  if (grade === "LOW") return rawValue === 0 ? "방향 차이 없음" : rawValue > 0 ? "+ 방향" : "- 방향";
  if (unit === "deg") return grade === "HIGH" ? Math.round(rawValue) : Math.round(rawValue / 5) * 5;
  return Math.round(rawValue * 100) / 100;
}

export function buildMetricEvidence({
  id,
  metricId,
  view,
  rawValue,
  coverage,
  unit = "deg",
  window = "CURRENT_FRAME",
  cameraAligned = false,
  inputConditions = {},
}) {
  const definition = metricDefinition(metricId);
  if (!definition.measurable) throw new Error(`${metricId} is not measurable from single-camera body pose`);
  if (!definition.views.includes(view)) throw new Error(`${metricId} is not measurable for ${view}`);
  const grade = reliabilityForCoverage(coverage, { cameraAligned });
  const reasons = [];
  if (coverage < .5) reasons.push("REQUIRED_JOINT_MISSING");
  if (!cameraAligned) reasons.push("CAMERA_ALIGNMENT_UNCONFIRMED");
  const unavailable = grade === "UNAVAILABLE";
  return createEvidenceRecord({
    id,
    metricId,
    layer: definition.layer,
    evidenceIds: definition.evidenceIds,
    inputConditions: { view, ...inputConditions },
    reliability: { grade, coverage, reasons },
    observation: {
      rawValue: Number.isFinite(rawValue) ? rawValue : null,
      displayValue: displayValueFor(rawValue, grade, unit),
      unit,
      window,
      n: Number.isFinite(rawValue) ? 1 : 0,
      noiseFloor: null,
    },
    basis: { kind: "NONE", ref: null },
    verdict: {
      kind: unavailable ? "NOT_EVALUATED" : "OBSERVATION_ONLY",
      text: unavailable
        ? "측정 불가: 입력 품질 부족"
        : "관측값만 제공합니다. 평가 기준은 본인 기준선이 쌓이면 표시됩니다",
    },
    limits: ["2D 투영값", cameraAligned ? "개인 기준선 없음" : "카메라 정렬 미확인"],
  });
}

export function jointCoverage(frames, requires, minimumConfidence = .35) {
  if (!frames.length || !requires.length) return 0;
  const valid = frames.filter((frame) => requires.every((name) => (frame.joints?.[name]?.confidence || 0) >= minimumConfidence));
  return valid.length / frames.length;
}
