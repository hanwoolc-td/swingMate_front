// 영상 content 영역 <-> 정규화 좌표 변환.
// DOM/React Native 의존성 0 — 나중에 RN 앱으로 이 파일 그대로 복사해서 씁니다.

/**
 * object-fit:contain / contentFit="contain" 과 동일한 사각형을 계산한다.
 * 레터박스(위아래 여백) / 필러박스(좌우 여백)를 제외한 실제 영상 픽셀 영역.
 */
export function contentRect(videoW, videoH, boxW, boxH) {
  if (!videoW || !videoH || !boxW || !boxH) return { x: 0, y: 0, w: 0, h: 0 };
  const scale = Math.min(boxW / videoW, boxH / videoH);
  const w = videoW * scale;
  const h = videoH * scale;
  return { x: (boxW - w) / 2, y: (boxH - h) / 2, w, h };
}

/** 화면 px -> 0~1 (영상 좌상단 0,0 / 우하단 1,1) */
export function toNorm(px, py, r) {
  return { x: (px - r.x) / r.w, y: (py - r.y) / r.h };
}

/** 0~1 -> 화면 px */
export function toPx(nx, ny, r) {
  return { x: r.x + nx * r.w, y: r.y + ny * r.h };
}

export const clamp01 = (v) => (v < 0 ? 0 : v > 1 ? 1 : v);

/** 점 p 에서 선분 ab 까지의 거리. 터치 히트 판정용. */
export function distToSeg(p, a, b) {
  const dx = b.x - a.x;
  const dy = b.y - a.y;
  const len2 = dx * dx + dy * dy;
  let t = len2 ? ((p.x - a.x) * dx + (p.y - a.y) * dy) / len2 : 0;
  t = t < 0 ? 0 : t > 1 ? 1 : t;
  return Math.hypot(p.x - (a.x + t * dx), p.y - (a.y + t * dy));
}
