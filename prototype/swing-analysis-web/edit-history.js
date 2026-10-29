function clone(value) {
  return JSON.parse(JSON.stringify(value));
}

function same(a, b) {
  return JSON.stringify(a) === JSON.stringify(b);
}

export function createEditHistory(limit = 100) {
  if (!Number.isInteger(limit) || limit < 1) throw new Error("history limit must be positive");
  let past = [], future = [], present = null;
  return {
    reset(value) { past = []; future = []; present = clone(value); return clone(present); },
    commit(value) {
      const next = clone(value);
      if (present == null) { present = next; return false; }
      if (same(present, next)) return false;
      past.push(present);
      if (past.length > limit) past.shift();
      present = next;
      future = [];
      return true;
    },
    undo() {
      if (!past.length) return null;
      future.push(present);
      present = past.pop();
      return clone(present);
    },
    redo() {
      if (!future.length) return null;
      past.push(present);
      present = future.pop();
      return clone(present);
    },
    get canUndo() { return past.length > 0; },
    get canRedo() { return future.length > 0; },
    get size() { return past.length; },
  };
}
