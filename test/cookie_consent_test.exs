defmodule CookieConsentTest do
  use ExUnit.Case
  doctest CookieConsent

  describe "component/0" do
    test "returns the CookieConsent.Component module" do
      assert CookieConsent.component() == CookieConsent.Component
    end
  end

  describe "configuration getters" do
    test "ga_id/0 retrieves Google Analytics ID from config" do
      # Returns nil if not configured, which is valid
      result = CookieConsent.ga_id()
      assert is_nil(result) or is_binary(result)
    end

    test "meta_pixel_id/0 retrieves Meta Pixel ID from config" do
      # Returns nil if not configured, which is valid
      result = CookieConsent.meta_pixel_id()
      assert is_nil(result) or is_binary(result)
    end

    test "theme/0 returns dark theme by default" do
      # Should return "dark" as default
      assert CookieConsent.theme() == "dark"
    end
  end
end
