defmodule CookieConsent do
  @moduledoc """
  GDPR/CCPA compliant cookie consent for Phoenix LiveView applications.

  ## Installation

  Add `cookie_consent` to your list of dependencies in `mix.exs`:

      def deps do
        [
          {:cookie_consent, path: "../cookie_consent"}
          # or from GitHub:
          # {:cookie_consent, github: "yourusername/cookie_consent"}
        ]
      end

  ## Usage

  ### 1. Add the component to your root layout

  In `lib/your_app_web/components/layouts/root.html.heex`:

      <.live_component
        module={CookieConsent.Component}
        id="cookie-consent"
        ga_id="G-XXXXXXXXXX"
        meta_pixel_id="YOUR_PIXEL_ID"
      />

  ### 2. Add the JavaScript hook

  In `assets/js/app.js`:

      import { CookieConsent } from "../../../cookie_consent/priv/static/cookie_consent"
      // Or if published to npm/hex: import { CookieConsent } from "cookie_consent"

      let Hooks = {}
      Hooks.CookieConsent = CookieConsent

      let liveSocket = new LiveSocket("/live", Socket, {
        hooks: Hooks,
        // ... other config
      })

  ### 3. (Optional) Configure defaults

  In `config/config.exs`:

      config :cookie_consent,
        ga_id: "G-XXXXXXXXXX",
        meta_pixel_id: "YOUR_PIXEL_ID",
        theme: "dark"  # or "light"

  ## Customization

  The component accepts the following assigns:

  - `ga_id` - Google Analytics 4 measurement ID (optional if set in config)
  - `meta_pixel_id` - Meta Pixel ID (optional if set in config)
  - `theme` - "dark" or "light" (default: "dark")

  ## Cookie Settings Link

  To allow users to reopen preferences after consent:

      <button phx-click="show_cookie_settings">
        Cookie Settings
      </button>

  The component will listen for this event and reopen the preferences modal.
  """

  @doc """
  Returns the LiveComponent module for rendering.
  """
  def component do
    CookieConsent.Component
  end

  @doc """
  Gets the configured Google Analytics ID.
  """
  def ga_id do
    Application.get_env(:cookie_consent, :ga_id)
  end

  @doc """
  Gets the configured Meta Pixel ID.
  """
  def meta_pixel_id do
    Application.get_env(:cookie_consent, :meta_pixel_id)
  end

  @doc """
  Gets the configured theme (dark or light).
  """
  def theme do
    Application.get_env(:cookie_consent, :theme, "dark")
  end
end
