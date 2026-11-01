// Screenshot driver for the README images.
// One browser and one page; every shot is taken in sequence by driving the
// real interface (clicks, menus, settings). The clock and time zone are fixed
// so the timestamps in the log are neutral rather than the capture machine's.
// Run: make shots   (or NODE_PATH=<dir containing playwright> node docs/shot.js)
const { chromium } = require('playwright');
const path = require('path');

const APP = 'file://' + path.resolve(__dirname, '..', 'index.html');
const IMG = path.join(__dirname, 'figures', 'fig-replay.png');
const out = name => path.join(__dirname, name);

(async () => {
  const browser = await chromium.launch({ headless: true });
  try {
    const context = await browser.newContext({
      viewport: { width: 1360, height: 820 },
      deviceScaleFactor: 2,
      colorScheme: 'dark',
      locale: 'en-US',
      timezoneId: 'UTC',
    });
    const page = await context.newPage();
    await page.clock.install({ time: new Date('2026-10-31T09:00:00Z') });
    page.on('dialog', d => d.accept());           // "Delete all marks?" confirmations
    await page.goto(APP, { waitUntil: 'domcontentloaded' });
    await page.waitForSelector('#stage');

    const settle = (ms = 1700) => page.waitForTimeout(ms);   // panels animate, toasts fade
    const stageBox = async () => page.locator('#stage').boundingBox();
    const clickAt = async (fx, fy, opts) => {
      const b = await stageBox();
      await page.mouse.click(Math.round(b.x + b.width * fx), Math.round(b.y + b.height * fy), opts);
      await page.waitForTimeout(140);
    };
    const hoverAt = async (fx, fy) => {
      const b = await stageBox();
      await page.mouse.move(Math.round(b.x + b.width * fx), Math.round(b.y + b.height * fy), { steps: 4 });
    };
    const clearMarks = async () => { await page.click('#btn-clear'); await page.waitForTimeout(150); };

    // 1. main view: a handful of marks with index + coordinate labels, live readout
    await page.selectOption('#c-label', 'both');
    await page.check('#c-rainbow');
    for (const [x, y] of [[0.14, 0.22], [0.32, 0.58], [0.5, 0.3], [0.66, 0.7], [0.8, 0.4]]) await clickAt(x, y);
    await hoverAt(0.58, 0.5);
    await settle();
    await page.screenshot({ path: out('screenshot-main.png') });

    // 2. measuring on an image: load a picture, mark its features, open the mark menu
    await clearMarks();
    await page.setInputFiles('#c-img', IMG);
    await page.selectOption('#c-units', 'norm');
    await page.uncheck('#c-showgrid');
    await page.selectOption('#c-style', 'target');
    await page.selectOption('#c-label', 'coords');
    await page.uncheck('#c-rainbow');
    await settle(600);
    // points inside the picture, as fractions of the picture (its own dots and labels)
    const nat = { w: 1449, h: 693 };
    const imgPoint = async (ix, iy) => page.evaluate(([ix, iy, nw, nh]) => {
      const st = document.getElementById('stage');
      const w = st.clientWidth, h = st.clientHeight, s = Math.min(w / nw, h / nh);
      const dw = nw * s, dh = nh * s;
      return [((w - dw) / 2 + ix * dw) / w, ((h - dh) / 2 + iy * dh) / h];
    }, [ix, iy, nat.w, nat.h]);
    for (const [ix, iy] of [[41.28 / 184, 41.55 / 88], [149.2 / 184, 39.81 / 88], [85 / 184, 44.5 / 88]]) {
      const [fx, fy] = await imgPoint(ix, iy);
      await clickAt(fx, fy);
    }
    await settle();
    const [mx, my] = await imgPoint(149.2 / 184, 39.81 / 88);
    const b = await stageBox();
    await page.mouse.click(Math.round(b.x + b.width * mx), Math.round(b.y + b.height * my), { button: 'right' });
    await page.waitForSelector('#ctx:not([hidden])');
    await page.waitForTimeout(200);
    await page.screenshot({ path: out('screenshot-image.png') });
    await page.keyboard.press('Escape');

    // 3. light theme with the JSON export open in the log panel
    await page.click('#btn-theme');
    await page.click('#btn-json');
    await settle(400);
    await page.screenshot({ path: out('screenshot-export-light.png') });
    await page.click('#btn-json');                // close the export panel again
    await page.click('#btn-theme');

    // 4. grid, snapping and a centered origin on a fixed 16:9 stage
    await clearMarks();
    await page.click('#btn-img-clear');
    await page.selectOption('#c-units', 'px');
    await page.check('#c-showgrid');
    await page.selectOption('#c-origin', 'center');
    await page.selectOption('#c-aspect', '1.7778');
    await page.check('#c-snap');
    await page.fill('#c-grid', '40');
    await page.selectOption('#c-style', 'cross');
    await page.selectOption('#c-label', 'both');
    await settle(600);
    for (const [x, y] of [[0.5, 0.5], [0.25, 0.3], [0.75, 0.3], [0.3, 0.75], [0.7, 0.75]]) await clickAt(x, y);
    await hoverAt(0.62, 0.42);
    await settle();
    await page.screenshot({ path: out('screenshot-grid.png') });

    // 5. zen stage: panels gone, the whole page records clicks
    await clearMarks();
    await page.selectOption('#c-origin', 'tl');
    await page.selectOption('#c-aspect', 'free');
    await page.uncheck('#c-snap');
    await page.selectOption('#c-style', 'ring');
    await page.selectOption('#c-label', 'index');
    await page.check('#c-rainbow');
    await page.evaluate(() => document.activeElement && document.activeElement.blur());  // keys are ignored inside form fields
    await page.keyboard.press('4');
    await settle();
    for (const [x, y] of [[0.06, 0.04], [0.5, 0.03], [0.94, 0.06], [0.08, 0.92], [0.5, 0.55], [0.93, 0.94]]) await clickAt(x, y);
    await hoverAt(0.7, 0.3);
    await settle();
    await page.screenshot({ path: out('screenshot-zen.png') });
  } finally {
    await browser.close();
  }
})().catch(e => { console.error(e); process.exit(1); });
