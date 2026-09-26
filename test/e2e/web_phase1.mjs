// Web end-to-end test for Phase 1 (see test/e2e/README.md).
//
// Drives a release web build against a local Supabase stack: deep link while
// signed out, magic-link sign-in (code read from Mailpit), profile setup,
// search, book page, shelves, change edition, manual add, the rendering
// spike's export buttons, sign out; then checks the rows in Postgres.
// Open Library / Google Books answers are fixtures so runs are deterministic.
import { chromium } from 'playwright';
import { execSync } from 'node:child_process';
import { readFileSync } from 'node:fs';

const appUrl = process.env.APP_URL ?? 'http://localhost:3000';
// Optional: where upsert_book really runs, if not behind the local gateway
// (e.g. `deno run ... index.ts` on :8000 when the Docker edge runtime can't
// reach npm).
const functionsProxy = process.env.FUNCTIONS_PROXY;

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
if (functionsProxy) await page.route('http://127.0.0.1:54321/functions/v1/upsert_book', async (route) => {
  const req = route.request();
  if (req.method() === 'OPTIONS') return route.fulfill({ status: 200,
    headers: { 'access-control-allow-origin': '*', 'access-control-allow-headers': '*' } });
  const res = await fetch(functionsProxy, { method: 'POST',
    headers: { authorization: req.headers()['authorization'], 'content-type': 'application/json' },
    body: req.postData() });
  route.fulfill({ status: res.status, contentType: 'application/json',
    headers: { 'access-control-allow-origin': '*' }, body: await res.text() });
});

async function shot(name) { if (shots) await page.screenshot({ path: `${shots}/${name}.png` }); }
const byText = (t) => page.getByText(t, { exact: false }).filter({ visible: true }).first();
async function tap(role, name) {
  const el = page.getByRole(role, { name, exact: typeof name === 'string' }).filter({ visible: true }).first();
  await el.waitFor({ timeout: 15000 });
  await el.click();
}
async function fill(label, value) {
  const el = page.getByRole('textbox', { name: label }).filter({ visible: true }).first();
  await el.waitFor({ timeout: 15000 });
  await el.click();
  await el.fill(value);
}

try {
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
  log('magic link sent');

  const msgs = await (await fetch(`http://127.0.0.1:54324/api/v1/search?query=to:${encodeURIComponent(email)}`)).json();
  const msg = await (await fetch(`http://127.0.0.1:54324/api/v1/message/${msgs.messages[0].ID}`)).json();
  const code = msg.Text.match(/\b(\d{6})\b/)[1];
  log(`got code ${code} from the email`);
  await fill('Code from the email', code);
  await tap('button', 'Sign in with code');

  await byText('Create your profile').waitFor({ timeout: 15000 });
  log('signed in -> profile setup');
  await fill('Username', username);
  await byText('Username available').waitFor({ timeout: 10000 }).catch(() => {});
  await fill('Display name', 'Test Reader');
  await shot('02-profile');
  await tap('button', 'Continue');

  await page.waitForURL((u) => u.pathname === '/library', { timeout: 15000 });
  log(`profile created -> returned to ${new URL(page.url()).pathname}`);
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

  const sql = `select w.title, ub.shelf, e.isbn13, ub.started_at is not null as started, ub.finished_at is not null as finished from user_books ub join profiles p on p.id = ub.user_id join works w on w.id = ub.work_id left join editions e on e.id = ub.edition_id where p.username = '${username}' order by w.title`;
  console.log(execSync(`docker exec supabase_db_shelfie psql -U postgres -c "${sql}"`).toString());
  console.log('E2E PASS');
} catch (e) {
  await shot('zz-failure');
  console.log('E2E FAIL:', e.message.split('\n')[0]);
  process.exitCode = 1;
} finally {
  if (errors.length) console.log('Browser errors:\n  ' + errors.slice(0, 10).join('\n  '));
  await browser.close();
}
