# Publishing "Gorillas: Banana Battle" to the App Stores

This game is a **PWA** (Progressive Web App). The easiest way to ship it to both
stores from a **Windows** PC is to host it on the web and wrap it with
**[PWABuilder](https://www.pwabuilder.com)** (free, by Microsoft).

---

## Step 0 — One-time accounts (required, paid)
| Store | Account | Cost |
|-------|---------|------|
| Google Play | [Play Console](https://play.google.com/console) | **$25 once** |
| Apple App Store | [Apple Developer Program](https://developer.apple.com/programs/) | **$99 / year** |

> ⚠️ **iOS reality check:** Apple requires a **Mac with Xcode** to build and
> upload the final iOS app. On Windows you have three options:
> 1. Borrow/rent a Mac (or use a cloud Mac like MacStadium / MacinCloud).
> 2. Use a CI build service (Codemagic, Bitrise, GitHub Actions macOS runners).
> 3. PWABuilder's iOS package still needs a Mac for the final `xcodebuild` +
>    upload step — there is no fully-Windows path to the App Store.
>
> Google Play has **no such restriction** — you can do everything on Windows.

---

## Step 1 — Host the game publicly (needed by PWABuilder)
PWABuilder reads your live URL. Free options:
- **GitHub Pages** (recommended): push the `gorillas/` folder to a repo, enable
  Pages → you get `https://<you>.github.io/gorillas/`.
- **Netlify / Cloudflare Pages / Vercel**: drag-and-drop the folder.

Requirements (already satisfied by this project): served over **HTTPS**, with
`manifest.json`, a registered **service worker** (`sw.js`), and valid icons.

### Generate the icons first
Open **`icons/make-icons.html`** in a browser and click the three download
buttons. Save the PNGs into the `icons/` folder:
- `icon-192.png`, `icon-512.png`, `icon-512-maskable.png`

Then host the folder. Verify the PWA: open the URL in Chrome → DevTools →
**Application → Manifest** should show no errors.

---

## Step 2 — Package with PWABuilder
1. Go to <https://www.pwabuilder.com> and paste your hosted URL.
2. It scores the PWA and shows **Package For Stores**.

### Android (Google Play)
- Click **Android → Generate**. You get a **`.aab`** (App Bundle) + a signing
  key (`signing.keystore`) — **back this key up; you need it for every update.**
- In Play Console: create app → upload the `.aab` → fill the listing (below) →
  set up the **Digital Asset Links** (`assetlinks.json`) that PWABuilder gives
  you, hosted at `https://<yourdomain>/.well-known/assetlinks.json` so the app
  opens without a browser bar (TWA requirement).
- Complete content rating, data-safety form ("No data collected"), and submit.

### iOS (App Store) — needs a Mac
- Click **iOS → Generate** → download the Xcode project.
- On a Mac: open in Xcode, set your Team/Bundle ID, run on a simulator, then
  **Product → Archive → Distribute App** to upload to App Store Connect.
- Fill the listing, attach screenshots, submit for review.

---

## Step 3 — Store listing copy (ready to paste)

**App name:** Gorillas: Banana Battle
**Subtitle / short description (≤ 30 / 80 chars):**
`Throw bananas. Topple gorillas.`

**Full description:**
```
The classic gorilla artillery duel is back! Two gorillas stand atop a
neon city skyline and hurl explosive bananas at each other.

Pick your angle and power — or just drag back like a slingshot — and let
gravity and the wind do the rest. Knock buildings apart, bonk the grinning
sun, and blast your rival off the rooftops.

• Local 2-player on one device
• Single-player vs a computer opponent that learns
• Wind, destructible skyline, screen shake, and that classic banana arc
• Quick rounds — first to 3 wins
• Plays offline, no ads, no tracking

A modern remake of the timeless QBASIC "Gorillas" game.
```

**Keywords (App Store):** `gorilla,banana,artillery,retro,arcade,qbasic,2 player,physics,classic,turn based`

**Category:** Games → Arcade (or Action)
**Content rating:** Everyone / 4+
**Privacy policy URL:** host `PRIVACY.md` (as HTML) and link it.

---

## Step 4 — Required graphic assets
| Asset | Size | Where |
|-------|------|-------|
| App icon | 512×512 PNG | done via `make-icons.html` |
| Feature graphic (Play) | 1024×500 PNG | make a banner |
| Phone screenshots | ≥ 2, e.g. 1080×1920 or 1920×1080 | screenshot the running game |
| iPad/Tablet screenshots (Apple) | per device | screenshot |

Tip: run the game full-screen in Chrome, press **F12 → device toolbar** to set a
phone/landscape size, then use the browser screenshot to capture clean shots.

---

## Fast path summary
1. `make-icons.html` → download 3 PNGs into `icons/`.
2. Push `gorillas/` to GitHub Pages (HTTPS URL).
3. PWABuilder → Android `.aab` → Play Console → submit. ✅ (all on Windows)
4. For iOS: PWABuilder → Xcode project → **build on a Mac** → App Store Connect.
