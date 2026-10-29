import fs from "node:fs";
import path from "node:path";
import { buildHandTrack, handObservation } from "./pose-track.js";

const inputs = process.argv.slice(2);
if (!inputs.length) {
  console.error("usage: node baseline-report.js pose-front.json pose-side.json");
  process.exit(2);
}

const pct = (value) => `${(value * 100).toFixed(1)}%`;
const rows = [];

for (const input of inputs) {
  const data = JSON.parse(fs.readFileSync(input, "utf8"));
  const observations = data.frames.map((frame) => handObservation(frame));
  const track = buildHandTrack(data.frames);
  const reasons = observations.filter((item) => !item.valid).reduce((all, item) => {
    all[item.reason] = (all[item.reason] || 0) + 1;
    return all;
  }, {});
  const bothWrists = data.frames.filter((frame) => frame.joints.leftWrist && frame.joints.rightWrist);
  const confidences = bothWrists.map((frame) => Math.min(frame.joints.leftWrist.confidence, frame.joints.rightWrist.confidence));
  rows.push({
    file: path.basename(input),
    frames: data.frames.length,
    duration: data.duration,
    sampleFPS: data.sampleFPS,
    minConfidence: confidences.length ? Math.min(...confidences) : 0,
    meanConfidence: confidences.length ? confidences.reduce((a, b) => a + b, 0) / confidences.length : 0,
    accepted: track.accepted,
    acceptedRatio: track.ratio,
    segments: track.segments.length,
    quality: track.quality,
    reasons,
  });
}

console.log("# 손 경로 기준선 리포트\n");
console.log("> 자동 산출된 개발 기준선이며 프로 코치 정답 라벨 검증 전입니다. 손 경로는 클럽헤드 경로가 아닙니다.\n");
console.log("| 파일 | 프레임 | 양손목 신뢰도 평균/최저 | 품질 통과 | 분리 구간 | 등급 |");
console.log("|---|---:|---:|---:|---:|---|");
for (const row of rows) {
  console.log(`| ${row.file} | ${row.frames} | ${pct(row.meanConfidence)} / ${pct(row.minConfidence)} | ${row.accepted}/${row.frames} (${pct(row.acceptedRatio)}) | ${row.segments} | ${row.quality} |`);
}
console.log("\n## 제외 사유\n");
for (const row of rows) {
  const reasons = Object.entries(row.reasons).map(([key, value]) => `${key}=${value}`).join(", ") || "없음";
  console.log(`- ${row.file}: ${reasons}`);
}
console.log("\n## 해석 경계\n");
console.log("- 한쪽 손목만 검출된 프레임을 양손 중심으로 대체하지 않습니다.");
console.log("- 저신뢰·손목 간격 이상·시간 단절 구간은 앞뒤 선을 연결하지 않습니다.");
console.log("- 임계값은 현재 샘플을 위한 개발 가정이며, 프로 코치 라벨 데이터로 확정해야 합니다.");
