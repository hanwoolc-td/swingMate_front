export const WORKFLOW_STEPS = Object.freeze({ VIDEO: "VIDEO", CAPTURE: "CAPTURE", ANALYZE: "ANALYZE" });
export const CAPTURE_DIRECTIONS = Object.freeze(["FACE_ON", "DOWN_THE_LINE"]);
export const ANALYSIS_MODES = Object.freeze(["MANUAL", "AUTO", "REPEATABILITY"]);

export function createWorkflowState() {
  return { step: WORKFLOW_STEPS.VIDEO, hasVideo: false, direction: null, cameraAligned: false, poseAvailable: false, poseDirection: null, mode: null };
}

export function selectVideo(state, { poseAvailable = false, poseDirection = null } = {}) {
  return { ...createWorkflowState(), hasVideo: true, poseAvailable, poseDirection, step: WORKFLOW_STEPS.CAPTURE };
}

export function confirmCapture(state, { direction, cameraAligned = false }) {
  if (!state.hasVideo) throw new Error("video is required");
  if (!CAPTURE_DIRECTIONS.includes(direction)) throw new Error("capture direction is required");
  return { ...state, direction, cameraAligned: Boolean(cameraAligned) };
}

export function modeAvailability(state, mode) {
  if (!ANALYSIS_MODES.includes(mode)) return { enabled: false, reason: "지원하지 않는 분석 모드" };
  if (!state.hasVideo) return { enabled: false, reason: "영상을 먼저 선택하세요" };
  if (mode === "MANUAL") return { enabled: true, reason: "" };
  if (mode === "REPEATABILITY") return { enabled: true, reason: "동일 방향·클럽 3회 이상 세션이 필요합니다" };
  if (!state.direction) return { enabled: false, reason: "촬영 방향을 확인하세요" };
  if (!state.poseAvailable) return { enabled: false, reason: "자동 분석 데이터 없음" };
  if (state.poseDirection && state.poseDirection !== state.direction) return { enabled: false, reason: "자세 데이터의 촬영 방향과 다릅니다" };
  return { enabled: true, reason: "" };
}

export function startAnalysis(state, mode) {
  const availability = modeAvailability(state, mode);
  if (!availability.enabled) throw new Error(availability.reason);
  return { ...state, step: WORKFLOW_STEPS.ANALYZE, mode };
}
