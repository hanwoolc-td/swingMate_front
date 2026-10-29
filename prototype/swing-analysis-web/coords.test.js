import assert from "node:assert/strict";
import { contentRect, toNorm, toPx, distToSeg } from "./coords.js";

const near = (a, b, msg) => assert.ok(Math.abs(a - b) < 1e-9, `${msg}: ${a} vs ${b}`);

// 1. 필러박스: 세로 영상(1080x1920)을 가로 박스(800x400)에 -> 좌우 여백
{
  const r = contentRect(1080, 1920, 800, 400);
  near(r.h, 400, "높이가 박스에 꽉 참");
  near(r.w, 225, "폭 = 400 * 1080/1920");
  near(r.x, 287.5, "좌우 여백 균등");
  near(r.y, 0, "위아래 여백 없음");
}

// 2. 레터박스: 가로 영상(1920x1080)을 세로 박스(400x800)에 -> 위아래 여백
{
  const r = contentRect(1920, 1080, 400, 800);
  near(r.w, 400, "폭이 박스에 꽉 참");
  near(r.h, 225, "높이 = 400 * 1080/1920");
  near(r.y, 287.5, "위아래 여백 균등");
}

// 3. 왕복 일치: px -> norm -> px 하면 원래 좌표로 돌아온다 (이게 깨지면 그림이 밀린다)
{
  const r = contentRect(1080, 1920, 800, 400);
  for (const p of [{ x: 300, y: 10 }, { x: 512.5, y: 400 }, { x: 287.5, y: 0 }]) {
    const n = toNorm(p.x, p.y, r);
    const back = toPx(n.x, n.y, r);
    near(back.x, p.x, "왕복 x");
    near(back.y, p.y, "왕복 y");
  }
}

// 4. 화면 크기/방향이 바뀌어도 정규화 좌표는 영상의 같은 지점을 가리킨다
{
  const portrait = contentRect(1920, 1080, 400, 800);   // 세로 화면
  const landscape = contentRect(1920, 1080, 800, 400);  // 가로로 회전
  const n = { x: 0.25, y: 0.75 };
  const a = toPx(n.x, n.y, portrait);
  const b = toPx(n.x, n.y, landscape);
  // 두 화면의 px 좌표는 다르지만, 각자의 content 영역 안에서의 비율은 같아야 한다
  near((a.x - portrait.x) / portrait.w, (b.x - landscape.x) / landscape.w, "회전 후 x 비율 유지");
  near((a.y - portrait.y) / portrait.h, (b.y - landscape.y) / landscape.h, "회전 후 y 비율 유지");
  assert.ok(a.x !== b.x, "화면이 달라졌으므로 px 값 자체는 달라야 함");
}

// 5. 영상 메타데이터가 아직 없을 때 0으로 나누지 않는다
{
  const r = contentRect(0, 0, 800, 400);
  assert.deepEqual(r, { x: 0, y: 0, w: 0, h: 0 }, "메타데이터 없으면 빈 사각형");
}

// 6. 히트 판정: 선분에서 멀고 가까움
{
  const a = { x: 0, y: 0 }, b = { x: 100, y: 0 };
  near(distToSeg({ x: 50, y: 5 }, a, b), 5, "선분 중간 위 5px");
  near(distToSeg({ x: -10, y: 0 }, a, b), 10, "선분 밖은 끝점까지 거리");
  near(distToSeg({ x: 50, y: 0 }, { x: 7, y: 7 }, { x: 7, y: 7 }), Math.hypot(43, 7), "길이 0인 선분도 안 터짐");
}

console.log("coords.test.js: 전부 통과");
