const GUIDANCE = Object.freeze({
  WRIST_OCCLUDED: {
    title: "손목이 충분히 보이지 않습니다",
    impact: "자동 손목 중심 경로를 표시하지 않았습니다.",
    action: "카메라를 허리 높이에 고정하고 손과 클럽 전체가 화면 안에 들어오게 다시 촬영하세요.",
  },
  WRIST_TRACK_UNSTABLE: {
    title: "손목 경로가 안정적으로 연결되지 않습니다",
    impact: "위치 도약이 있어 자동 경로를 숨겼습니다.",
    action: "밝은 곳에서 카메라를 고정하고 손과 클럽이 몸에 가려지지 않게 촬영하세요.",
  },
  REQUIRED_JOINT_UNAVAILABLE: {
    title: "필요한 관절을 확인하지 못했습니다",
    impact: "해당 자세 지표를 계산하지 않았습니다.",
    action: "머리부터 발끝까지 화면에 포함하고 몸이 다른 사람이나 물체에 가려지지 않게 촬영하세요.",
  },
  CAMERA_ALIGNMENT_UNCONFIRMED: {
    title: "카메라 정렬을 확인해 주세요",
    impact: "표시 각도는 2D 투영 관측값으로만 제공합니다.",
    action: "정면은 목표선과 직각, 측면은 목표선과 평행하게 카메라를 허리 높이에 놓으세요.",
  },
  VIEW_NOT_SUPPORTED: {
    title: "이 촬영 방향에서는 지원하지 않습니다",
    impact: "해당 자동 지표를 표시하지 않았습니다.",
    action: "다른 촬영 방향의 영상을 추가하거나 코치 직접 분석을 사용하세요.",
  },
  POSE_DATA_UNAVAILABLE: {
    title: "자동 분석 데이터가 없습니다",
    impact: "이 영상에서는 자동 자세선과 지표를 만들 수 없습니다.",
    action: "현재 영상에서도 직선·각도·수동 궤적을 사용한 코치 직접 분석은 가능합니다.",
  },
});

export function mapAnalysisReason(reason, metricId = "") {
  if (["missing_wrist", "low_confidence"].includes(reason)) return "WRIST_OCCLUDED";
  if (["wrist_pair_spread", "time_gap", "position_jump"].includes(reason)) return "WRIST_TRACK_UNSTABLE";
  if (reason === "REQUIRED_JOINT_MISSING") return metricId === "wrist_center_path" ? "WRIST_OCCLUDED" : "REQUIRED_JOINT_UNAVAILABLE";
  if (reason === "CAMERA_ALIGNMENT_UNCONFIRMED") return reason;
  return GUIDANCE[reason] ? reason : "REQUIRED_JOINT_UNAVAILABLE";
}

export function guidanceFor(reason, metricId = "") {
  const code = mapAnalysisReason(reason, metricId);
  return { code, ...GUIDANCE[code], manualAllowed: true };
}
