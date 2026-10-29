export function createViewport() {
  return { zoom: 1, panX: 0, panY: 0 };
}

export function clampZoom(value) {
  return Math.max(1, Math.min(4, Number(value) || 1));
}

export function zoomViewport(view, nextZoom, anchor, stageSize) {
  const zoom = clampZoom(nextZoom);
  const center = { x: stageSize.w / 2, y: stageSize.h / 2 };
  const base = screenToCanvas(anchor, view, stageSize);
  return {
    zoom,
    panX: anchor.x - center.x - (base.x - center.x) * zoom,
    panY: anchor.y - center.y - (base.y - center.y) * zoom,
  };
}

export function panViewport(view, dx, dy) {
  if (view.zoom === 1) return createViewport();
  return { ...view, panX: view.panX + dx, panY: view.panY + dy };
}

export function screenToCanvas(point, view, stageSize) {
  const center = { x: stageSize.w / 2, y: stageSize.h / 2 };
  return {
    x: (point.x - center.x - view.panX) / view.zoom + center.x,
    y: (point.y - center.y - view.panY) / view.zoom + center.y,
  };
}

export function canvasTransform(view) {
  return `translate(${view.panX}px, ${view.panY}px) scale(${view.zoom})`;
}
