const { chromium } = require('playwright');
const path = require('path');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage({
    viewport: { width: 1024, height: 1024 },
    deviceScaleFactor: 2
  });

  const htmlPath = path.resolve(__dirname, 'logo_render.html');
  await page.goto('file://' + htmlPath);

  // Wait for canvas render
  await page.waitForTimeout(500);

  const canvas = await page.$('canvas');
  await canvas.screenshot({
    path: path.resolve(__dirname, 'Assets/logo.png'),
    omitBackground: true
  });

  await browser.close();
  console.log('Logo saved to Assets/logo.png');
})();
