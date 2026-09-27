// Web end-to-end test for Phase 1 (see test/e2e/README.md).
//
// Drives a release web build (built with USE_FIREBASE_EMULATORS=true) against
// the Firebase emulators: deep link while signed out, email-link sign-in (link
// read from the Auth emulator), profile setup, search, book page, shelves,
// change edition, manual add with a cover photo, the rendering spike's export
// buttons, sign out; then checks the documents in Firestore.
// Open Library / Google Books answers are fixtures so runs are deterministic.
import { chromium } from 'playwright';
import { readFileSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

const appUrl = process.env.APP_URL ?? 'http://localhost:3000';
const project = 'demo-shelfie';
const authEmulator = 'http://127.0.0.1:9099';
const firestoreEmulator = 'http://127.0.0.1:8080';

const shots = process.env.SHOTS;
const email = `reader${Date.now()}@test.dev`;
const username = `reader${String(Date.now()).slice(-6)}`;
let step = 0;
const log = (m) => console.log(`[${++step}] ${m}`);

const olSearch = {
  docs: [
    { key: '/works/OL66554W', title: 'Pride and Prejudice', author_name: ['Jane Austen'],
      first_publish_year: 1813, number_of_pages_median: 432 },
    { key: '/works/OL66562W', title: 'Emma', author_name: ['Jane Austen'], first_publish_year: 1815 },
  ],
};
const olEditions = {
  entries: [
    { isbn_13: ['9780141439518'], number_of_pages: 480, publishers: ['Penguin Classics'],
      publish_date: '2003', physical_format: 'Paperback', works: [{ key: '/works/OL66554W' }] },
  ],
};

const browser = await chromium.launch(
  process.env.CHROMIUM_PATH ? { executablePath: process.env.CHROMIUM_PATH } : {},
);
const page = await browser.newPage({ viewport: { width: 420, height: 860 } });
const errors = [];
page.on('pageerror', (e) => errors.push(`pageerror: ${e.message}`));
page.on('console', (m) => { if (m.type() === 'error') errors.push(`console: ${m.text()}`); });

await page.route('https://openlibrary.org/**', (route) => {
  const url = new URL(route.request().url());
  const body = url.pathname.endsWith('/editions.json') ? olEditions : olSearch;
  route.fulfill({ status: 200, contentType: 'application/json',
    headers: { 'access-control-allow-origin': '*' }, body: JSON.stringify(body) });
});
await page.route('https://www.googleapis.com/**', (route) =>
  route.fulfill({ status: 200, contentType: 'application/json',
    headers: { 'access-control-allow-origin': '*' }, body: '{"totalItems":0}' }));
await page.route('https://covers.openlibrary.org/**', (route) => route.abort());
// Optional: serve the Firebase JS SDK (which Flutter web loads from gstatic)
// from a local `firebase` npm package, for machines without internet.
if (process.env.FIREBASE_JS_DIR) {
  await page.route('https://www.gstatic.com/firebasejs/**', (route) => {
    const file = new URL(route.request().url()).pathname.split('/').pop();
    route.fulfill({ status: 200, contentType: 'application/javascript',
      body: readFileSync(join(process.env.FIREBASE_JS_DIR, file)) });
  });
}
async function shot(name) { if (shots) await page.screenshot({ path: `${shots}/${name}.png` }); }
const byText = (t) => page.getByText(t, { exact: false }).filter({ visible: true }).first();
async function tap(role, name) {
  const el = page.getByRole(role, { name, exact: typeof name === 'string' }).filter({ visible: true }).first();
  await el.waitFor({ timeout: 15000 });
  await el.click();
}
async function fill(label, value) {
  const el = page.getByRole('textbox', { name: label, exact: true }).filter({ visible: true }).first();
  await el.waitFor({ timeout: 15000 });
  // Type real keystrokes (setting the DOM value can bypass Flutter's text
  // engine). Right after a screen opens, Flutter web may still be attaching
  // its editing element and drop early keys, so check and retry.
  for (let attempt = 1; ; attempt++) {
    await el.click({ timeout: 5000 }).catch(() => {});
    await page.waitForTimeout(200);
    await page.keyboard.press('ControlOrMeta+A');
    await page.keyboard.press('Backspace');
    await page.keyboard.type(value, { delay: 10 });
    await page.waitForTimeout(200);
    if ((await el.inputValue().catch(() => '')) === value) return;
    if (attempt === 5) throw new Error(`could not type into "${label}"`);
  }
}

try {
  // Start from empty emulators so catalogue contents are predictable.
  await fetch(`${firestoreEmulator}/emulator/v1/projects/${project}/databases/(default)/documents`, { method: 'DELETE' });
  await fetch(`${authEmulator}/emulator/v1/projects/${project}/accounts`, { method: 'DELETE' });
  await page.goto(`${appUrl}/library`);
  // Turn on Flutter's semantics tree so elements are addressable.
  await page.locator('flt-semantics-placeholder').waitFor({ state: 'attached', timeout: 30000 });
  await page.evaluate(() => document.querySelector('flt-semantics-placeholder').click());
  await byText('Continue with Google').waitFor({ timeout: 30000 });
  log(`deep link /library redirected to ${new URL(page.url()).pathname}${new URL(page.url()).search}`);
  await shot('01-sign-in');

  await fill('Email', email);
  await tap('button', 'Email me a sign-in link');
  await byText('We sent a sign-in link').waitFor({ timeout: 15000 });
  log('email link sent');

  // The Auth emulator exposes the sign-in link it "sent".
  const codes = await (await fetch(`${authEmulator}/emulator/v1/projects/${project}/oobCodes`)).json();
  const code = codes.oobCodes.filter((c) => c.email === email && c.requestType === 'EMAIL_SIGNIN').pop();
  const link = new URL(code.oobLink);
  const landing = new URL(link.searchParams.get('continueUrl'));
  for (const key of ['apiKey', 'oobCode', 'mode', 'lang']) {
    if (link.searchParams.get(key)) landing.searchParams.set(key, link.searchParams.get(key));
  }
  log(`opening the email link (${landing.pathname}?mode=${landing.searchParams.get('mode')})`);
  await page.goto(landing.toString());
  await page.locator('flt-semantics-placeholder').waitFor({ state: 'attached', timeout: 30000 });
  await page.evaluate(() => document.querySelector('flt-semantics-placeholder').click());

  await byText('Create your profile').waitFor({ timeout: 15000 });
  log('signed in -> profile setup');
  await fill('Username', username);
  await page.getByRole('img', { name: 'Username available' }).waitFor({ timeout: 10000 }).catch(() => {});
  await page.waitForTimeout(500);
  await fill('Display name', 'Test Reader');
  await shot('02-profile');
  await tap('button', 'Continue');

  await page.waitForURL((u) => u.pathname !== '/onboarding/profile', { timeout: 15000 });
  log(`profile created -> ${new URL(page.url()).pathname}`);
  await tap('tab', 'Library');
  await page.getByRole('tab', { name: 'Want to read (0)' }).waitFor({ timeout: 15000 });
  await page.getByRole('button', { name: 'Find a book' }).filter({ visible: true }).first().waitFor({ timeout: 15000 });
  log('empty library with shelf counts');
  await shot('03-library-empty');

  await tap('tab', 'Search');
  await fill('Title, author or ISBN', 'pride');
  await page.getByRole('button', { name: /Pride and Prejudice/ }).first().waitFor({ timeout: 15000 });
  log('search results shown');
  await shot('04-search');
  await tap('button', /Pride and Prejudice/);

  await page.getByRole('checkbox', { name: 'Currently reading' }).filter({ visible: true }).first().waitFor({ timeout: 15000 });
  log(`book page opened: ${new URL(page.url()).pathname}`);
  await shot('05-book');
  await tap('checkbox', 'Currently reading');
  await page.getByRole('button', { name: 'Remove from library' }).first().waitFor({ timeout: 15000 });
  log('added to Currently reading');

  await tap('button', 'Change edition');
  await tap('button', /Penguin Classics/);
  await page.getByRole('button', { name: 'Penguin Classics' }).first().waitFor({ state: 'detached', timeout: 15000 }).catch(() => {});
  await page.waitForTimeout(1500);
  log('picked the Penguin edition');
  await shot('07-book-shelved');

  await tap('checkbox', 'Read');
  await page.getByRole('button', { name: 'Save' }).first().waitFor({ timeout: 15000 });
  log('moved to Read; rating + one-line take visible');
  await shot('07b-read');

  await page.goBack();
  await tap('tab', 'Library');
  await page.getByRole('tab', { name: 'Read (1)' }).waitFor({ timeout: 15000 });
  log('library shows Read (1)');
  await tap('tab', 'Read (1)');
  await shot('08-library');

  await tap('tab', 'Search');
  await tap('button', 'Clear');
  await tap('button', 'Add a book manually');
  await fill('Title', 'My Zine');
  await fill('Author', 'Me');
  await fill('Number of pages', '40');
  const cover = join(tmpdir(), 'e2e-cover.png');
  writeFileSync(cover, Buffer.from(
    'iVBORw0KGgoAAAANSUhEUgAAAAIAAAADCAIAAAA2iEnWAAAAFklEQVR4nGP8z8DAwMDAxMDAwMDAAAAhCgMBnL8rNAAAAABJRU5ErkJggg==', 'base64'));
  const chooser = page.waitForEvent('filechooser', { timeout: 15000 });
  await tap('button', /Add a cover photo/);
  await (await chooser).setFiles(cover);
  await page.getByRole('button', { name: /Change cover photo/ }).waitFor({ timeout: 15000 });
  log('cover photo picked');
  await tap('button', 'Save');
  await page.getByRole('checkbox', { name: 'Want to read' }).filter({ visible: true }).first().waitFor({ timeout: 15000 });
  log('manual add opened its book page');
  await tap('checkbox', 'Want to read');
  await page.getByRole('button', { name: 'Remove from library' }).first().waitFor({ timeout: 15000 });
  log('manual book shelved');

  await page.goBack();
  await tap('tab', 'You');
  await page.getByRole('button', { name: 'Settings' }).waitFor({ timeout: 15000 });
  log('You tab open');
  await shot('09-you');
  await tap('button', 'Settings');

  // Phase 0 rendering spike: these buttons didn't work on web before.
  await tap('button', 'Rendering spike');
  await tap('button', 'Render session_minimal (story)');
  await page.getByRole('button', { name: 'Download', exact: true }).waitFor({ timeout: 30000 });
  await shot('10-spike-story');
  let download = page.waitForEvent('download', { timeout: 15000 });
  await tap('button', 'Download');
  const story = await download;
  const storyPath = `${shots ?? '/tmp'}/story.png`;
  await story.saveAs(storyPath);
  const png = readFileSync(storyPath);
  log(`spike story downloaded: ${png.readUInt32BE(16)}x${png.readUInt32BE(20)} PNG`);
  await tap('button', 'Render 3-slide carousel');
  await page.waitForTimeout(500);
  await page.getByRole('button', { name: 'Download', exact: true }).waitFor({ timeout: 30000 });
  const downloads = [];
  page.on('download', (d) => downloads.push(d));
  await tap('button', 'Download');
  await page.waitForTimeout(3000);
  log(`spike carousel downloaded ${downloads.length} PNGs`);
  await shot('11-spike-carousel');
  await tap('button', 'Share…');
  await page.waitForTimeout(1500);
  log('Share… button handled (Web Share API or download fallback)');
  await page.goBack();

  await tap('button', 'Sign out');
  await page.getByRole('button', { name: 'Continue with Google' }).waitFor({ timeout: 15000 });
  log('signed out -> sign-in screen');

  // Check what landed in Firestore (owner token bypasses rules).
  const owner = { headers: { Authorization: 'Bearer owner' } };
  const docs = async (collection) =>
    ((await (await fetch(`${firestoreEmulator}/v1/projects/${project}/databases/(default)/documents/${collection}?pageSize=300`, owner)).json()).documents ?? []);
  const field = (d, k) => {
    const v = d.fields[k];
    if (v === undefined || 'nullValue' in v) return null;
    return v.stringValue ?? v.integerValue ?? v.timestampValue;
  };
  const profile = (await docs('profiles')).find((d) => field(d, 'username') === username);
  const uid = profile.name.split('/').pop();
  const works = Object.fromEntries((await docs('works')).map((d) => [d.name.split('/').pop(), d]));
  const editions = Object.fromEntries((await docs('editions')).map((d) => [d.name.split('/').pop(), d]));
  const mine = (await docs('userBooks')).filter((d) => field(d, 'userId') === uid);
  const rows = mine.map((d) => {
    const edition = editions[field(d, 'editionId')];
    return {
      title: field(works[field(d, 'workId')], 'title'),
      shelf: field(d, 'shelf'),
      isbn13: edition ? field(edition, 'isbn13') : null,
      started: field(d, 'startedAt') !== null,
      finished: field(d, 'finishedAt') !== null,
      cover: edition && field(edition, 'coverUrl') ? 'uploaded' : '-',
    };
  }).sort((a, b) => a.title.localeCompare(b.title));
  console.table(rows);
  const usernameDoc = (await docs('usernames')).find((d) => d.name.endsWith(`/${username}`));
  if (!usernameDoc || field(usernameDoc, 'uid') !== uid) throw new Error('username not claimed');
  const [zine, pride] = rows;
  if (rows.length !== 2 || pride.shelf !== 'read' || pride.isbn13 !== '9780141439518' || !pride.started || !pride.finished
      || zine.shelf !== 'want_to_read' || zine.started || zine.finished || zine.cover !== 'uploaded') {
    throw new Error('unexpected Firestore state');
  }
  console.log('E2E PASS');
} catch (e) {
  await shot('zz-failure');
  console.log('E2E FAIL:', e.message.split('\n')[0]);
  process.exitCode = 1;
} finally {
  if (errors.length) console.log('Browser errors:\n  ' + errors.slice(0, 10).join('\n  '));
  await browser.close();
}
