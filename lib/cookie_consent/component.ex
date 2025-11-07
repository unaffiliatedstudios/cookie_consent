defmodule CookieConsent.Component do
  @moduledoc """
  LiveComponent for cookie consent banner.

  Displays a GDPR/CCPA compliant cookie consent banner with customizable preferences.
  Integrates with Google Analytics and Meta Pixel via the CookieConsent JS hook.

  ## Usage

      <.live_component
        module={CookieConsent.Component}
        id="cookie-consent"
        ga_id="G-XXXXXXXXXX"
        meta_pixel_id="123456789"
        theme="dark"
      />
  """
  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:show_banner, true)
     |> assign(:show_preferences, false)
     |> assign(:analytics_enabled, false)
     |> assign(:marketing_enabled, false)}
  end

  @impl true
  def update(assigns, socket) do
    # Get IDs from assigns or config
    ga_id = assigns[:ga_id] || CookieConsent.ga_id()
    meta_pixel_id = assigns[:meta_pixel_id] || CookieConsent.meta_pixel_id()
    theme = assigns[:theme] || CookieConsent.theme()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:ga_id, ga_id)
     |> assign(:meta_pixel_id, meta_pixel_id)
     |> assign(:theme, theme)
     |> assign_new(:analytics_enabled, fn -> false end)
     |> assign_new(:marketing_enabled, fn -> false end)}
  end

  @impl true
  def handle_event("accept_all", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_banner, false)
     |> assign(:analytics_enabled, true)
     |> assign(:marketing_enabled, true)
     |> push_event("cookie-consent", %{
       analytics: true,
       marketing: true
     })}
  end

  @impl true
  def handle_event("reject_all", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_banner, false)
     |> assign(:show_preferences, false)
     |> assign(:analytics_enabled, false)
     |> assign(:marketing_enabled, false)
     |> push_event("cookie-consent", %{
       analytics: false,
       marketing: false
     })}
  end

  @impl true
  def handle_event("show_preferences", _params, socket) do
    {:noreply, assign(socket, :show_preferences, true)}
  end

  @impl true
  def handle_event("toggle_preference", params, socket) do
    # 1. Determine which toggle was clicked from the "_target" in the params
    # It comes as an array, e.g., ["analytics"] or ["marketing"]
    [type | _rest] = params["_target"]

    # 2. Check the value for that field (Phoenix sends "on" if checked, or omits it if unchecked)
    # The presence of "on" means the checkbox is now checked (enabled).
    is_enabled = Map.get(params, type) == "on"

    # 3. Use the extracted 'type' and 'is_enabled' to update the socket
    new_socket =
      case type do
        "analytics" ->
          assign(socket, :analytics_enabled, is_enabled)

        "marketing" ->
          assign(socket, :marketing_enabled, is_enabled)

        _ ->
          socket
      end

    # The key here is to use the state sent by the checkbox in the form context.
    {:noreply, new_socket}
  end

  @impl true
  def handle_event("save_preferences", _params, socket) do
    analytics = socket.assigns.analytics_enabled
    marketing = socket.assigns.marketing_enabled

    {:noreply,
     socket
     |> assign(:show_banner, false)
     |> assign(:show_preferences, false)
     |> push_event("cookie-consent", %{
       analytics: analytics,
       marketing: marketing
     })}
  end

  @impl true
  def handle_event("close_preferences", _params, socket) do
    {:noreply, assign(socket, :show_preferences, false)}
  end

  @impl true
  def handle_event("noop", _params, socket) do
    # This event is intentional on the modal body to prevent the backdrop's
    # phx-click="close_preferences" from firing when clicking inside the modal.
    # We just need to acknowledge it and do nothing.
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id="cookie-consent-wrapper"
      phx-hook="CookieConsent"
      data-ga-id={@ga_id}
      data-meta-pixel-id={@meta_pixel_id}
      class={"cookie-consent-theme-#{@theme}"}
    >
      <!-- Main Banner -->
      <div
        :if={@show_banner && !@show_preferences}
        class="cookie-consent-banner"
        role="dialog"
        aria-labelledby="cookie-consent-title"
        aria-describedby="cookie-consent-description"
      >
        <div class="cookie-consent-banner-content">
          <div class="cookie-consent-banner-text">
            <h3 id="cookie-consent-title" class="cookie-consent-title">
              We Use Cookies
            </h3>
            <p id="cookie-consent-description" class="cookie-consent-description">
              We use cookies to analyze site traffic and improve your experience.
              You can customize your preferences or accept all cookies.
            </p>
          </div>

          <div class="cookie-consent-banner-actions">
            <button
              type="button"
              phx-click="reject_all"
              phx-target={@myself}
              class="cookie-consent-btn cookie-consent-btn-secondary"
              aria-label="Reject all cookies"
            >
              Reject All
            </button>
            <button
              type="button"
              phx-click="show_preferences"
              phx-target={@myself}
              class="cookie-consent-btn cookie-consent-btn-secondary"
              aria-label="Customize cookie preferences"
            >
              Customize
            </button>
            <button
              type="button"
              phx-click="accept_all"
              phx-target={@myself}
              class="cookie-consent-btn cookie-consent-btn-primary"
              aria-label="Accept all cookies"
            >
              Accept All
            </button>
          </div>
        </div>
      </div>

      <!-- Preferences Modal -->
      <div
        :if={@show_preferences}
        class="cookie-consent-modal-backdrop"
        phx-click="close_preferences"
        phx-target={@myself}
        role="dialog"
        aria-modal="true"
        aria-labelledby="cookie-preferences-title"
      >
        <div
          class="cookie-consent-modal"
          phx-click-away="close_preferences"
          phx-target={@myself}
          phx-click="noop"
        >
          <div class="cookie-consent-modal-header">
            <h2 id="cookie-preferences-title" class="cookie-consent-modal-title">
              Cookie Preferences
            </h2>
            <p class="cookie-consent-modal-subtitle">
              Choose which cookies you want to allow. You can change these settings at any time.
            </p>
          </div>

          <form phx-submit="save_preferences" phx-target={@myself} class="cookie-consent-modal-body">
            <!-- Essential Cookies (Always On) -->
            <div class="cookie-consent-category">
              <div class="cookie-consent-category-content">
                <div class="cookie-consent-category-info">
                  <h3 class="cookie-consent-category-title">Essential Cookies</h3>
                  <p class="cookie-consent-category-description">
                    Required for the website to function properly. These cannot be disabled.
                  </p>
                </div>
                <div class="cookie-consent-category-toggle">
                  <span class="cookie-consent-badge cookie-consent-badge-success">
                    Always On
                  </span>
                </div>
              </div>
            </div>

            <!-- Analytics Cookies -->
            <div class="cookie-consent-category">
              <div class="cookie-consent-category-content">
                <div class="cookie-consent-category-info">
                  <h3 class="cookie-consent-category-title">Analytics Cookies</h3>
                  <p class="cookie-consent-category-description">
                    Help us understand how visitors use our site (Google Analytics).
                  </p>
                  <p class="cookie-consent-category-details">
                    Collects anonymous data about page views, session duration, and user behavior.
                  </p>
                </div>
                <div class="cookie-consent-category-toggle">
                  <label class="cookie-consent-toggle">
                    <input
                      type="checkbox"
                      name="analytics"
                      phx-change="toggle_preference"
                      phx-value-type="analytics"
                      class="cookie-consent-toggle-input"
                      phx-stop="click"
                      checked={@analytics_enabled}
                      phx-value-enabled={to_string(@analytics_enabled)}
                    />
                    <span class="cookie-consent-toggle-slider"></span>
                  </label>
                </div>
              </div>
            </div>

            <!-- Marketing Cookies -->
            <div class="cookie-consent-category">
              <div class="cookie-consent-category-content">
                <div class="cookie-consent-category-info">
                  <h3 class="cookie-consent-category-title">Marketing Cookies</h3>
                  <p class="cookie-consent-category-description">
                    Used to track visitors across websites for advertising purposes (Meta Pixel).
                  </p>
                  <p class="cookie-consent-category-details">
                    Helps us show relevant ads and measure campaign effectiveness.
                  </p>
                </div>
                <div class="cookie-consent-category-toggle">
                  <label class="cookie-consent-toggle">
                    <input
                      type="checkbox"
                      name="marketing"
                      phx-change="toggle_preference"
                      phx-value-type="marketing"
                      class="cookie-consent-toggle-input"
                      phx-stop="click"
                      checked={@marketing_enabled}
                      phx-value-enabled={to_string(@marketing_enabled)}
                    />
                    <span class="cookie-consent-toggle-slider"></span>
                  </label>
                </div>
              </div>
            </div>

            <div class="cookie-consent-modal-footer">
              <button
                type="button"
                phx-click="reject_all"
                phx-target={@myself}
                class="cookie-consent-btn cookie-consent-btn-secondary cookie-consent-btn-flex"
                aria-label="Reject all cookies"
              >
                Reject All
              </button>
              <button
                type="submit"
                class="cookie-consent-btn cookie-consent-btn-primary cookie-consent-btn-flex"
                aria-label="Save cookie preferences"
              >
                Save Preferences
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
    """
  end
end
