# Cookie Consent

GDPR/CCPA compliant cookie consent banner for Phoenix LiveView applications.

## Features

- ✅ **GDPR/CCPA Compliant** - Proper opt-in/opt-out flow
- 🎨 **Customizable** - Dark/light themes, configurable per-app
- 📊 **Google Analytics** - Loads GA4 only after consent
- 📱 **Meta Pixel** - Loads Meta Pixel only after consent
- 💾 **Persistent** - Remembers user choice in localStorage
- 🔧 **Flexible** - Configure globally or per-component

## Installation

### 1. Add dependency

For local development (recommended while building):

```elixir
# In your Phoenix app's mix.exs
def deps do
  [
    {:cookie_consent, path: "../cookie_consent"}
  ]
end
```

Or from GitHub (once pushed):

```elixir
def deps do
  [
    {:cookie_consent, github: "yourusername/cookie_consent"}
  ]
end
```

Run `mix deps.get`

### 2. Add the component to your root layout

In `lib/your_app_web/components/layouts/root.html.heex`, add before `</body>`:

```heex
<.live_component 
  module={CookieConsent.Component} 
  id="cookie-consent"
  ga_id="G-XXXXXXXXXX"
  meta_pixel_id="YOUR_PIXEL_ID"
/>
```

### 3. Add the JavaScript hook

In `assets/js/app.js`:

```javascript
// Import the hook (adjust path based on your setup)
import { CookieConsent } from "../../../cookie_consent/priv/static/cookie_consent"

// Add to your Hooks
let Hooks = {}
Hooks.CookieConsent = CookieConsent

// Pass hooks to LiveSocket
let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken},
  hooks: Hooks
})
```

### 4. Run your app

```bash
mix phx.server
```

Visit your site and you should see the cookie consent banner!

## Configuration

### Option 1: Component Attributes (Per-App)

Pass IDs directly to the component:

```heex
<.live_component 
  module={CookieConsent.Component} 
  id="cookie-consent"
  ga_id="G-XXXXXXXXXX"
  meta_pixel_id="YOUR_PIXEL_ID"
  theme="dark"
/>
```

### Option 2: Application Config (Global)

In `config/config.exs`:

```elixir
config :cookie_consent,
  ga_id: "G-XXXXXXXXXX",
  meta_pixel_id: "YOUR_PIXEL_ID",
  theme: "dark"  # or "light"
```

Then use without attributes:

```heex
<.live_component 
  module={CookieConsent.Component} 
  id="cookie-consent"
/>
```

## Adding Cookie Settings Link

Allow users to reopen preferences after initial consent:

```heex
<!-- In your footer or anywhere -->
<button phx-click="show_cookie_settings">
  Cookie Settings
</button>
```

The component listens for this event globally.

## Themes

Two built-in themes:

- `"dark"` - Dark slate background (default)
- `"light"` - White background

Pass via `theme` attribute or config.

## How It Works

1. Banner shows on first visit
2. User chooses: Accept All / Reject All / Customize
3. Choice saved to `localStorage`
4. Scripts load only if consented
5. Banner hidden until user clears localStorage or clicks "Cookie Settings"

## License

MIT

## Credits

Built by [Unaffiliated Studios](https://unaffiliatedstudios.com)