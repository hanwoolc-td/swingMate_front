const GRADES = new Set(["HIGH", "MEDIUM", "LOW", "UNAVAILABLE"]);
const BASIS = new Set(["PERSONAL_BASELINE", "COACH_LABEL_MODEL", "NONE"]);
const VERDICTS = new Set([
  "OBSERVATION_ONLY",
  "WITHIN_OWN_RANGE",
  "DEVIATES_FROM_OWN_BASELINE",
  "NOT_EVALUATED",
]);

function required(value, name) {
  if (value == null || value === "") throw new Error(`EvidenceRecord.${name} is required`);
}

export function validateEvidenceRecord(record) {
  required(record?.id, "id");
  required(record?.metricId, "metricId");
  required(record?.layer, "layer");
  if (!Array.isArray(record.evidenceIds) || record.evidenceIds.length === 0) {
    throw new Error("automatic evidence requires evidenceIds");
  }
  required(record.inputConditions, "inputConditions");
  if (!GRADES.has(record.reliability?.grade)) throw new Error("invalid reliability grade");
  if (!Number.isFinite(record.reliability.coverage) || record.reliability.coverage < 0 || record.reliability.coverage > 1) {
    throw new Error("coverage must be between 0 and 1");
  }
  if (!Array.isArray(record.reliability.reasons)) throw new Error("reliability reasons are required");
  required(record.observation, "observation");
  if (!BASIS.has(record.basis?.kind)) throw new Error("invalid basis kind");
  if (!VERDICTS.has(record.verdict?.kind)) throw new Error("invalid verdict kind");
  if (record.verdict.kind !== "OBSERVATION_ONLY" &&
      record.verdict.kind !== "NOT_EVALUATED" &&
      record.basis.kind === "NONE") {
    throw new Error("evaluative verdict requires a comparison basis");
  }
  if (record.reliability.grade === "UNAVAILABLE" && record.observation.displayValue != null) {
    throw new Error("UNAVAILABLE evidence cannot expose displayValue");
  }
  if (record.reliability.grade === "LOW" && typeof record.observation.displayValue === "number") {
    throw new Error("LOW evidence cannot expose a numeric displayValue");
  }
  if (!Array.isArray(record.limits)) throw new Error("limits are required");
  required(record.coachReview, "coachReview");
  return record;
}

export function createEvidenceRecord(input) {
  return validateEvidenceRecord({
    id: input.id,
    metricId: input.metricId,
    layer: input.layer,
    evidenceIds: [...input.evidenceIds],
    inputConditions: { ...input.inputConditions },
    reliability: {
      grade: input.reliability.grade,
      coverage: input.reliability.coverage,
      reasons: [...(input.reliability.reasons || [])],
    },
    observation: {
      rawValue: input.observation.rawValue ?? null,
      displayValue: input.observation.displayValue ?? null,
      unit: input.observation.unit,
      window: input.observation.window,
      n: input.observation.n ?? 0,
      noiseFloor: input.observation.noiseFloor ?? null,
    },
    basis: { kind: input.basis?.kind || "NONE", ref: input.basis?.ref || null },
    verdict: {
      kind: input.verdict?.kind || "OBSERVATION_ONLY",
      text: input.verdict?.text || "관측값만 제공합니다. 평가 기준은 본인 기준선이 쌓이면 표시됩니다",
    },
    limits: [...(input.limits || [])],
    coachReview: {
      status: input.coachReview?.status || "NONE",
      editedValue: input.coachReview?.editedValue ?? null,
      by: input.coachReview?.by || null,
      at: input.coachReview?.at || null,
    },
  });
}

export function reliabilityLabel(grade) {
  return {
    HIGH: "높음",
    MEDIUM: "보통",
    LOW: "낮음",
    UNAVAILABLE: "측정 불가",
  }[grade] || "측정 불가";
}
