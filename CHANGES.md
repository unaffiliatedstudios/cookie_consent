# Cookie Consent Component

A clean, accessible, and easily customizable cookie consent component for Phoenix LiveView applications. Features GDPR/CCPA compliance with Google Analytics and Meta Pixel integration.

## 🎯 Features

- ✅ **Granular consent options** - Users can choose Analytics and Marketing cookies separately
- ✅ **Proper default state** - Cookies are OFF by default (GDPR compliant)
- ✅ **Clean CSS architecture** - Uses CSS custom properties for easy theming
- ✅ **Framework agnostic styling** - No Tailwind dependency, works with any app
- ✅ **Accessible** - Proper ARIA labels and keyboard navigation
- ✅ **Responsive** - Mobile-friendly design
- ✅ **LocalStorage persistence** - Remembers user preferences
- ✅ **Script loading** - Conditionally loads Google Analytics and Meta Pixel

## 📦 Installation

### 1. Add the files to your project

```
lib/
  your_app_web/
    components/
      cookie_consent/
        component.ex          # LiveView component
assets/
  js/
    hooks/
      cookie_consent.js       # Phoenix Hook
  css/
    cookie_consent.css        # Styles
```

### 2. Import the JavaScript hook

In your `assets/js/app.js`:

```javascript
import { CookieConsent } from "./hooks/cookie_consent.js";

let Hooks = {};
Hooks.CookieConsent = CookieConsent;

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});
```

### 3. Import the CSS

In your `assets/css/app.css`:

```css
@import "./cookie_consent.css";
```

Or link it directly in your `root.html.heex`:

```html
<link phx-track-static rel="stylesheet" href={~p"/assets/cookie_consent.css"} />
```

### 4. Configure tracking IDs

Create a configuration module (optional, you can also pass IDs directly):

```elixir
# lib/your_app/cookie_consent.ex
defmodule YourApp.CookieConsent do
  def ga_id, do: Application.get_env(:your_app, :google_analytics_id)
  def meta_pixel_id, do: Application.get_env(:your_app, :meta_pixel_id)
  def theme, do: "dark" # or "light"
end
```

In your `config/config.exs`:

```elixir
config :your_app,
  google_analytics_id: "G-XXXXXXXXXX",
  meta_pixel_id: "123456789"
```

### 5. Add the component to your layout

In your `root.html.heex` or main layout:

```heex
<.live_component
  module={CookieConsent.Component}
  id="cookie-consent"
  ga_id="G-XXXXXXXXXX"
  meta_pixel_id="123456789"
  theme="dark"
/>
```

## 🎨 Customization

### Theme Selection

The component comes with two built-in themes:

```heex
<!-- Dark theme (default) -->
<.live_component module={CookieConsent.Component} id="cookie-consent" theme="dark" />

<!-- Light theme -->
<.live_component module={CookieConsent.Component} id="cookie-consent" theme="light" />
```

### Custom Styling with CSS Variables

Override CSS variables in your app's stylesheet to match your brand:

```css
/* Example: Custom brand colors */
:root {
  --cookie-btn-primary-bg: #ff6b6b;
  --cookie-btn-primary-bg-hover: #ff5252;
  --cookie-border-radius-md: 1rem;
  --cookie-spacing-lg: 2rem;
}

/* Or target specific theme */
.cookie-consent-theme-dark {
  --cookie-bg-banner: #000000;
  --cookie-text-primary: #00ff00;
}
```

### Available CSS Variables

**Colors:**
- `--cookie-bg-banner` - Banner background
- `--cookie-bg-modal` - Modal background
- `--cookie-text-primary` - Main text color
- `--cookie-text-secondary` - Secondary text color
- `--cookie-btn-primary-bg` - Primary button background
- `--cookie-btn-primary-bg-hover` - Primary button hover
- And many more...

**Spacing:**
- `--cookie-spacing-xs` through `--cookie-spacing-xl`

**Border Radius:**
- `--cookie-border-radius-sm` through `--cookie-border-radius-lg`

**Typography:**
- `--cookie-font-size-xs` through `--cookie-font-size-xl`
- `--cookie-font-weight-normal`, `semibold`, `bold`

See `cookie_consent.css` for the complete list.

### Complete Custom Theme Example

```css
/* Your app's custom theme */
.cookie-consent-theme-dark {
  /* Brand colors */
  --cookie-bg-banner: #1a1a2e;
  --cookie-bg-modal: #16213e;
  --cookie-bg-category: rgba(14, 30, 51, 0.5);
  
  --cookie-text-primary: #eaeaea;
  --cookie-text-secondary: #b8b8b8;
  
  --cookie-btn-primary-bg: #e94560;
  --cookie-btn-primary-bg-hover: #d63651;
  
  /* Spacing */
  --cookie-spacing-lg: 2rem;
  
  /* Border radius */
  --cookie-border-radius-md: 0.75rem;
  
  /* Typography */
  --cookie-font-size-base: 1.125rem;
}
```

## 🔧 Advanced Usage

### Checking Consent Programmatically

From JavaScript:

```javascript
const consent = window.getCookieConsent();
if (consent?.analytics) {
  // User accepted analytics
}
```

From Elixir (client-side check required):

```javascript
// In your app.js
window.addEventListener("phx:page-loading-stop", () => {
  const consent = window.getCookieConsent();
  if (consent) {
    // Push event to LiveView if needed
    window.liveSocket.execJS(
      document.body,
      `[[\"push\",{\"event\":\"consent_checked\",\"value\":${JSON.stringify(consent)}}]]`
    );
  }
});
```

### Triggering Settings Modal Programmatically

```javascript
// Dispatch a click event to reopen settings
document.dispatchEvent(new CustomEvent("show_cookie_settings"));
```

Or add a button in your app:

```heex
<button phx-click="show_cookie_settings" phx-target={@myself}>
  Cookie Settings
</button>
```

### Custom Tracking Beyond GA/Meta

Modify `CookieConsent.js` to add your own tracking:

```javascript
loadScripts(consent) {
  if (consent.analytics && !window.GA_LOADED && this.gaId) {
    this.loadGoogleAnalytics();
  }

  if (consent.marketing && !window.META_LOADED && this.metaPixelId) {
    this.loadMetaPixel();
  }

  // Add your custom tracking
  if (consent.analytics && !window.CUSTOM_ANALYTICS_LOADED) {
    this.loadCustomAnalytics();
  }
},

loadCustomAnalytics() {
  // Your custom tracking code
  console.log("Loading custom analytics");
  window.CUSTOM_ANALYTICS_LOADED = true;
}
```

## 🔍 How It Works

1. **On Mount**: JS hook checks `localStorage` for existing consent
2. **No Consent**: Banner appears at bottom of screen
3. **User Chooses**: 
   - "Accept All" → Both cookies enabled
   - "Reject All" → Both cookies disabled
   - "Customize" → Modal opens with individual toggles
4. **Save**: Preference saved to `localStorage` and scripts loaded
5. **Next Visit**: No banner shown, scripts load automatically based on saved preference

## 🐛 Troubleshooting

### Banner not appearing?

Check browser console for:
```
[CookieConsent] Mounted
[CookieConsent] No consent found, banner will be visible
```

Make sure `phx-hook="CookieConsent"` is on the wrapper div.

### Scripts not loading?

Check that:
1. `data-ga-id` and `data-meta-pixel-id` attributes are set
2. Console shows: `[CookieConsent] Google Analytics loaded`
3. LocalStorage has `cookie_consent` key with proper JSON

### Styling conflicts?

The CSS uses BEM-style class names prefixed with `cookie-consent-` to avoid conflicts. If you still have issues, increase specificity:

```css
#cookie-consent-wrapper .cookie-consent-banner {
  /* Your overrides */
}
```

## 📝 License

This component is provided as-is for use in your Phoenix applications.

## 🤝 Contributing

Suggestions and improvements welcome! Key areas:
- Additional tracking service integrations
- More built-in themes
- Internationalization support
- Testing examples

---

**Note**: This component stores preferences in `localStorage`, which is browser-specific. Users clearing browser data will see the banner again. For cross-device persistence, you'd need to store preferences server-side with user accounts.