defmodule CookieConsent.PlugSessionMirror do
  @moduledoc """
  A Plug to mirror cookie consent data from cookies into the session.
  This allows server-side components to access user consent preferences.
  """

  require Logger
  import Plug.Conn

  @cookie "cookie_consent_v1"

  def init(opts), do: opts

  def call(conn, _opts) do
    consent =
      with raw when is_binary(raw) <- conn.cookies[@cookie],
           {:ok, map} <- Jason.decode(raw) do
        map
      else
        {:error, %Jason.DecodeError{} = error} ->
          Logger.debug(
            "[CookieConsent.PlugSessionMirror] Failed to decode cookie consent data: #{inspect(error)}"
          )

          nil

        _ ->
          nil
      end

    put_session(conn, "cookie_consent_v1", consent)
  end
end
