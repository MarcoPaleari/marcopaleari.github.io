(function (global) {
  function textCompare(left, right) {
    return String(left || '').localeCompare(String(right || ''), 'it', { sensitivity: 'base' });
  }

  function compareNullable(left, right, direction, fallback) {
    const leftMissing = left === undefined || left === null || left === '';
    const rightMissing = right === undefined || right === null || right === '';
    if (leftMissing || rightMissing) {
      if (leftMissing && rightMissing) return fallback;
      return leftMissing ? 1 : -1;
    }
    return direction * (left < right ? -1 : left > right ? 1 : fallback);
  }

  function sortSongs(songs, order) {
    const direction = order.endsWith('-asc') ? 1 : -1;
    const field = order.replace(/-(asc|desc)$/, '');

    return songs
      .map((song, index) => ({ song, index }))
      .sort((left, right) => {
        const fallback = textCompare(left.song.title, right.song.title) || left.index - right.index;
        if (field === 'title') return direction * textCompare(left.song.title, right.song.title) || left.index - right.index;
        if (field === 'year') {
          const leftYear = Number(left.song.year);
          const rightYear = Number(right.song.year);
          return compareNullable(
            Number.isFinite(leftYear) && leftYear > 0 ? leftYear : null,
            Number.isFinite(rightYear) && rightYear > 0 ? rightYear : null,
            direction,
            fallback,
          );
        }
        return compareNullable(left.song.date, right.song.date, direction, fallback);
      })
      .map(entry => entry.song);
  }

  global.sortSongs = sortSongs;
  if (typeof module !== 'undefined') module.exports = { sortSongs };
})(typeof window !== 'undefined' ? window : globalThis);
