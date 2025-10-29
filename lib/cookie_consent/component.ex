defmodule CookieConsent.Component do
  @moduledoc """
  LiveComponent for cookie consent banner.
  """
  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:show_banner, true)
     |> assign(:show_preferences, false)}
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
     |> assign(:theme, theme)}
  end

  @impl true
  def handle_event("accept_all", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_banner, false)
     |> push_event("cookie-consent", %{
       analytics: true,
       marketing: true,
       ga_id: socket.assigns.ga_id,
       meta_pixel_id: socket.assigns.meta_pixel_id
     })}
  end

  @impl true
  def handle_event("reject_all", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_banner, false)
     |> push_event("cookie-consent", %{
       analytics: false,
       marketing: false,
       ga_id: socket.assigns.ga_id,
       meta_pixel_id: socket.assigns.meta_pixel_id
     })}
  end

  @impl true
  def handle_event("show_preferences", _params, socket) do
    {:noreply, assign(socket, :show_preferences, true)}
  end

  @impl true
  def handle_event("show_cookie_settings", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_banner, true)
     |> assign(:show_preferences, true)}
  end

  @impl true
  def handle_event("save_preferences", params, socket) do
    analytics = params["analytics"] == "true"
    marketing = params["marketing"] == "true"

    {:noreply,
     socket
     |> assign(:show_banner, false)
     |> assign(:show_preferences, false)
     |> push_event("cookie-consent", %{
       analytics: analytics,
       marketing: marketing,
       ga_id: socket.assigns.ga_id,
       meta_pixel_id: socket.assigns.meta_pixel_id
     })}
  end

  @impl true
  def handle_event("close_banner", _params, socket) do
    {:noreply, assign(socket, :show_banner, false)}
  end

  @impl true
  def render(assigns) do
    # Get theme classes
    {bg_class, border_class, text_class, btn_class} = theme_classes(assigns.theme)

    assigns =
      assigns
      |> assign(:bg_class, bg_class)
      |> assign(:border_class, border_class)
      |> assign(:text_class, text_class)
      |> assign(:btn_class, btn_class)

    ~H"""
    <div id="cookie-consent" phx-hook="CookieConsent" data-ga-id={@ga_id} data-meta-pixel-id={@meta_pixel_id}>
      <!-- Main Banner -->
      <div
        :if={@show_banner && !@show_preferences}
        class={"fixed bottom-0 left-0 right-0 z-50 #{@bg_class} #{@border_class} shadow-2xl animate-slide-up"}
      >
        <div class="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
            <div class="flex-1">
              <h3 class={"text-lg font-bold #{@text_class} mb-2"}>We Use Cookies</h3>
              <p class="text-gray-300 text-sm leading-relaxed">
                We use cookies to analyze site traffic (Google Analytics) and improve your experience.
                You can customize your preferences or accept all cookies.
              </p>
            </div>

            <div class="flex flex-wrap gap-3">
              <button
                phx-click="reject_all"
                phx-target={@myself}
                class="px-4 py-2 text-sm font-semibold text-gray-300 hover:text-white border border-gray-600 hover:border-gray-500 rounded-lg transition-colors"
              >
                Reject All
              </button>
              <button
                phx-click="show_preferences"
                phx-target={@myself}
                class="px-4 py-2 text-sm font-semibold text-gray-300 hover:text-white border border-gray-600 hover:border-gray-500 rounded-lg transition-colors"
              >
                Customize
              </button>
              <button
                phx-click="accept_all"
                phx-target={@myself}
                class={@btn_class}
              >
                Accept All
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Preferences Modal -->
      <div
        :if={@show_preferences}
        class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 animate-fade-in"
      >
        <div class={"#{@bg_class} rounded-xl shadow-2xl max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto"}>
          <div class={"p-6 #{@border_class}"}>
            <h2 class={"text-2xl font-bold #{@text_class}"}>Cookie Preferences</h2>
            <p class="text-gray-400 mt-2">
              Choose which cookies you want to allow. You can change these settings at any time.
            </p>
          </div>

          <form phx-submit="save_preferences" phx-target={@myself} class="p-6 space-y-6">
            <!-- Essential Cookies (Always On) -->
            <div class="bg-slate-700/50 p-4 rounded-lg">
              <div class="flex items-start justify-between">
                <div class="flex-1">
                  <h3 class={"text-lg font-semibold #{@text_class} mb-2"}>Essential Cookies</h3>
                  <p class="text-sm text-gray-300 leading-relaxed">
                    Required for the website to function properly. These cannot be disabled.
                  </p>
                </div>
                <div class="ml-4">
                  <div class="bg-green-600 text-white px-3 py-1 rounded-full text-xs font-semibold">
                    Always On
                  </div>
                </div>
              </div>
            </div>

            <!-- Analytics Cookies -->
            <div class="bg-slate-700/50 p-4 rounded-lg">
              <div class="flex items-start justify-between">
                <div class="flex-1">
                  <h3 class={"text-lg font-semibold #{@text_class} mb-2"}>Analytics Cookies</h3>
                  <p class="text-sm text-gray-300 leading-relaxed mb-2">
                    Help us understand how visitors use our site (Google Analytics).
                  </p>
                  <p class="text-xs text-gray-400">
                    Collects anonymous data about page views, session duration, and user behavior.
                  </p>
                </div>
                <div class="ml-4">
                  <label class="relative inline-flex items-center cursor-pointer">
                    <input type="checkbox" name="analytics" value="true" class="sr-only peer" checked />
                    <div class="w-11 h-6 bg-gray-600 peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-primary-500 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary-600">
                    </div>
                  </label>
                </div>
              </div>
            </div>

            <!-- Marketing Cookies -->
            <div class="bg-slate-700/50 p-4 rounded-lg">
              <div class="flex items-start justify-between">
                <div class="flex-1">
                  <h3 class={"text-lg font-semibold #{@text_class} mb-2"}>Marketing Cookies</h3>
                  <p class="text-sm text-gray-300 leading-relaxed mb-2">
                    Used to track visitors across websites for advertising purposes (Meta Pixel).
                  </p>
                  <p class="text-xs text-gray-400">
                    Helps us show relevant ads and measure campaign effectiveness.
                  </p>
                </div>
                <div class="ml-4">
                  <label class="relative inline-flex items-center cursor-pointer">
                    <input type="checkbox" name="marketing" value="true" class="sr-only peer" checked />
                    <div class="w-11 h-6 bg-gray-600 peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-primary-500 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary-600">
                    </div>
                  </label>
                </div>
              </div>
            </div>

            <div class="flex gap-3 pt-4">
              <button
                type="button"
                phx-click="reject_all"
                phx-target={@myself}
                class="flex-1 px-4 py-3 text-sm font-semibold text-gray-300 hover:text-white border border-gray-600 hover:border-gray-500 rounded-lg transition-colors"
              >
                Reject All
              </button>
              <button
                type="submit"
                class={"flex-1 px-4 py-3 text-sm font-semibold rounded-lg transition-colors #{@btn_class}"}
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

  defp theme_classes("light") do
    {
      "bg-white border-t border-gray-200",
      "border-b border-gray-200",
      "text-gray-900",
      "bg-blue-600 hover:bg-blue-700 text-white"
    }
  end

  defp theme_classes(_dark) do
    {
      "bg-slate-800 border-t border-slate-700",
      "border-b border-slate-700",
      "text-white",
      "bg-primary-600 hover:bg-primary-700 text-white"
    }
  end
end
