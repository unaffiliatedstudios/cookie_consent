defmodule CookieConsent.PlugSessionMirror do
  @moduledoc """
  A Plug to mirror cookie consent data from cookies into the session.
  This allows server-side components to access user consent preferences.
  """

  import Plug.Conn

  @cookie "cookie_consent_v1"

  def init(opts), do: opts

  def call(conn, _opts) do
    consent =
      with raw when is_binary(raw) <- conn.cookies[@cookie],
           {:ok, map} <- Jason.decode(raw) do
        map
      else
        _ -> nil
      end

    put_session(conn, "cookie_consent_v1", consent)
  end
end
