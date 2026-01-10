# Cookie Consent Component

A clean, accessible, and easily customizable cookie consent component for Phoenix LiveView applications. Features GDPR/CCPA compliance with Google Analytics and Meta Pixel integration.

## 🎯 Features

- ✅ **Granular consent options** - Users can choose Analytics and Marketing cookies separately
- ✅ **Proper default state** - Cookies are OFF by default (GDPR compliant)
- ✅ **Clean CSS architecture** - Uses CSS custom properties for easy theming
- ✅ **Framework agnostic styling** - No Tailwind dependency, works with any app
- ✅ **Accessible** - Proper ARIA labels and keyboard navigation
- ✅ **Responsive** - Mobile-friendly design
- ✅ **localStorage persistence** - Remembers user preferences across sessions
- ✅ **Script loading** - Conditionally loads Google Analytics and Meta Pixel
- ✅ **CSP nonce support** - Compatible with strict Content Security Policies
- ✅ **i18n ready** - All text strings can be customized/translated
- ✅ **Debug mode** - Optional console logging for development

## 📦 Installation

Add `cookie_consent` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cookie_consent, "~> 1.0"}
  ]
end
```

Then run:

```bash
mix deps.get
```

### 1. Import the JavaScript hook

In your `assets/js/app.js`:

```javascript
import { CookieConsent } from "../../deps/cookie_consent/assets/js/CookieConsent.js";

let Hooks = {};
Hooks.CookieConsent = CookieConsent;

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});
```

### 2. Import the CSS

In your `assets/css/app.css`:

```css
@import "../../deps/cookie_consent/assets/css/cookie_consent.css";
```

### 3. Configure tracking IDs

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

### 4. Add the component to your layout

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

**Note**: Both `ga_id` and `meta_pixel_id` are optional. The component works without them if you're not using these tracking services.

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

### Text Customization & Internationalization

All text strings can be customized or translated by passing them as assigns:

```heex
<.live_component
  module={CookieConsent.Component}
  id="cookie-consent"
  banner_title="Utilizamos Cookies"
  banner_description="Usamos cookies para analizar el tráfico del sitio..."
  btn_accept_all="Aceptar Todo"
  btn_reject_all="Rechazar Todo"
  btn_customize="Personalizar"
  btn_save="Guardar Preferencias"
  modal_title="Preferencias de Cookies"
  modal_subtitle="Elija qué cookies desea permitir..."
  essential_title="Cookies Esenciales"
  essential_description="Necesarias para que el sitio funcione..."
  analytics_title="Cookies de Análisis"
  analytics_description="Ayúdanos a entender cómo usan los visitantes nuestro sitio..."
  analytics_details="Recopila datos anónimos sobre vistas de página..."
  marketing_title="Cookies de Marketing"
  marketing_description="Utilizadas para rastrear visitantes..."
  marketing_details="Nos ayuda a mostrar anuncios relevantes..."
  always_on="Siempre Activo"
/>
```

**Available text overrides:**
- `banner_title` - Main banner heading
- `banner_description` - Banner explanation text
- `btn_accept_all` - "Accept All" button
- `btn_reject_all` - "Reject All" button
- `btn_customize` - "Customize" button
- `btn_save` - "Save Preferences" button
- `modal_title` - Preferences modal title
- `modal_subtitle` - Preferences modal description
- `essential_title` / `essential_description` - Essential cookies section
- `analytics_title` / `analytics_description` / `analytics_details` - Analytics section
- `marketing_title` / `marketing_description` / `marketing_details` - Marketing section
- `always_on` - Badge text for required cookies

### Content Security Policy (CSP) Support

If your application uses a strict Content Security Policy, you can pass a nonce for dynamically loaded scripts:

```heex
<.live_component
  module={CookieConsent.Component}
  id="cookie-consent"
  csp_nonce={@conn.assigns[:csp_nonce]}
  ga_id="G-XXXXXXXXXX"
/>
```

The nonce will be applied to Google Analytics and Meta Pixel scripts loaded after user consent.

**Setting up CSP nonce in Phoenix:**

```elixir
# In your router or endpoint
plug :put_secure_browser_headers, %{
  "content-security-policy" => "script-src 'self' 'nonce-#{conn.assigns[:csp_nonce]}'"
}

# Generate nonce per request
defp assign_csp_nonce(conn, _opts) do
  assign(conn, :csp_nonce, Base.encode64(:crypto.strong_rand_bytes(16)))
end
```

### Debug Mode

Enable debug logging during development to troubleshoot issues:

```heex
<.live_component
  module={CookieConsent.Component}
  id="cookie-consent"
  debug={true}
/>
```

When enabled, the component logs:
- Consent data read/write operations
- Script loading success/failure
- Error details for localStorage issues

**Production**: Keep `debug={false}` (default) to avoid console noise.

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

**Storage**: Consent preferences persist across browser sessions using `localStorage`. Users will only see the banner once per browser/device until they clear their browser data.

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
2. Enable debug mode: `debug={true}` to see console logs
3. localStorage has `cookie_consent` key with proper JSON
4. If using CSP, ensure nonce is properly configured

### Styling conflicts?

The CSS uses BEM-style class names prefixed with `cookie-consent-` to avoid conflicts. If you still have issues, increase specificity:

```css
#cookie-consent-wrapper .cookie-consent-banner {
  /* Your overrides */
}
```

### Phoenix LiveView Progress Bar Overlap

The library includes a CSS fix for Phoenix LiveView's topbar progress indicator to prevent z-index conflicts:

```css
/* Automatically included in cookie_consent.css */
canvas[style*="z-index: 100001"] {
  z-index: 9998 !important;
}
```

This ensures the cookie banner (z-index: 9999) appears above the progress bar. If you experience z-index conflicts with other elements, you can override:

```css
:root {
  --cookie-banner-z-index: 9999; /* Adjust as needed */
}
```

## 🔄 Upgrading

### From v1.0.0-1.0.2 to v1.0.3+

**Breaking Changes**: None - v1.0.3 is fully backward compatible.

**New Features Added:**
1. **localStorage instead of sessionStorage** - Consent now persists across browser sessions
   - Old data in sessionStorage will be ignored, users will see banner once more
   - No action needed - transition is automatic

2. **CSP nonce support** - Add optional `csp_nonce` parameter if using strict CSP
   ```heex
   <.live_component ... csp_nonce={@conn.assigns[:csp_nonce]} />
   ```

3. **i18n text overrides** - All text is now customizable
   ```heex
   <.live_component ... banner_title="Your Text" />
   ```

4. **Debug mode** - Enable logging during development
   ```heex
   <.live_component ... debug={true} />
   ```

5. **Improved error handling** - Better localStorage failure handling and logging

**Recommended Updates:**
- Consider enabling CSP nonce if you use Content Security Policy
- Translate text strings if serving non-English users
- Enable debug mode in development environment

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

Copyright (c) 2025 Unaffiliated Studios

## 🤝 Contributing

Suggestions and improvements welcome! Key areas:
- Additional tracking service integrations (Matomo, Plausible, etc.)
- More built-in themes
- Additional language translations
- Testing examples
- Documentation improvements

---

**Note**: This component stores preferences in `localStorage`, which is browser/device-specific. Users clearing browser data will see the banner again. For cross-device persistence, you could extend the library to sync preferences with a user account on the server.