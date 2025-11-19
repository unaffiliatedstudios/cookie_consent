defmodule CookieConsent.RouterIntegration do
  @moduledoc """
  A module to integrate CookieConsent with Phoenix Router pipelines.
  """
  defmacro __using__(:browser) do
    quote do
      plug(:fetch_cookies)
      plug(CookieConsent.PlugSessionMirror)
    end
  end
end
