const test = require('node:test');
const assert = require('node:assert/strict');

const { sortSongs } = require('../sort-songs.js');

const songs = [
  { title: 'Zeta', year: 1990, date: '2026-01-03' },
  { title: 'Alfa', year: 1975, date: '2026-04-20' },
  { title: 'Futura', year: 2005, date: '2026-11-02' },
  { title: 'Azzurro', year: null },
  { title: 'Senza data', year: 1985 },
];

test('puts past releases before upcoming ones when sorting by newest publication', () => {
  assert.deepEqual(
    sortSongs(songs, 'publication-desc', '2026-10-27').map(song => song.title),
    ['Alfa', 'Zeta', 'Futura', 'Azzurro', 'Senza data'],
  );
});

test('sorts titles from Z to A when requested', () => {
  assert.deepEqual(
    sortSongs(songs, 'title-desc').map(song => song.title),
    ['Zeta', 'Senza data', 'Futura', 'Azzurro', 'Alfa'],
  );
});

test('sorts years from oldest to newest when requested', () => {
  assert.deepEqual(
    sortSongs(songs, 'year-asc').map(song => song.title),
    ['Alfa', 'Senza data', 'Zeta', 'Futura', 'Azzurro'],
  );
});
