defmodule CookieConsent.ComponentTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest

  alias CookieConsent.Component

  describe "mount/1" do
    test "initializes with default state" do
      {:ok, socket} = Component.mount(%{})

      assert socket.assigns.show_preferences == false
      assert socket.assigns.analytics_enabled == false
      assert socket.assigns.marketing_enabled == false
    end
  end

  describe "update/2" do
    test "sets default theme when not provided" do
      {:ok, socket} = Component.mount(%{})
      {:ok, updated_socket} = Component.update(%{id: "test"}, socket)

      assert updated_socket.assigns.theme == "dark"
    end

    test "uses provided theme" do
      {:ok, socket} = Component.mount(%{})
      {:ok, updated_socket} = Component.update(%{id: "test", theme: "light"}, socket)

      assert updated_socket.assigns.theme == "light"
    end

    test "sets default debug to false" do
      {:ok, socket} = Component.mount(%{})
      {:ok, updated_socket} = Component.update(%{id: "test"}, socket)

      assert updated_socket.assigns.debug == false
    end

    test "uses provided debug flag" do
      {:ok, socket} = Component.mount(%{})
      {:ok, updated_socket} = Component.update(%{id: "test", debug: true}, socket)

      assert updated_socket.assigns.debug == true
    end

    test "creates text map with default strings" do
      {:ok, socket} = Component.mount(%{})
      {:ok, updated_socket} = Component.update(%{id: "test"}, socket)

      assert updated_socket.assigns.text.banner_title == "We Use Cookies"
      assert updated_socket.assigns.text.btn_accept_all == "Accept All"
    end

    test "allows overriding text strings" do
      {:ok, socket} = Component.mount(%{})

      {:ok, updated_socket} =
        Component.update(
          %{id: "test", banner_title: "Cookies!", btn_accept_all: "OK"},
          socket
        )

      assert updated_socket.assigns.text.banner_title == "Cookies!"
      assert updated_socket.assigns.text.btn_accept_all == "OK"
    end
  end

  describe "handle_event/3 - accept_all" do
    test "enables both analytics and marketing" do
      {:ok, socket} = Component.mount(%{})
      {:ok, socket} = Component.update(%{id: "test"}, socket)

      {:noreply, updated_socket} = Component.handle_event("accept_all", %{}, socket)

      assert updated_socket.assigns.analytics_enabled == true
      assert updated_socket.assigns.marketing_enabled == true
    end
  end

  describe "handle_event/3 - reject_all" do
    test "disables both analytics and marketing" do
      {:ok, socket} = Component.mount(%{})
      {:ok, socket} = Component.update(%{id: "test"}, socket)

      {:noreply, updated_socket} = Component.handle_event("reject_all", %{}, socket)

      assert updated_socket.assigns.analytics_enabled == false
      assert updated_socket.assigns.marketing_enabled == false
      assert updated_socket.assigns.show_preferences == false
    end
  end

  describe "handle_event/3 - show_preferences" do
    test "shows preferences modal" do
      {:ok, socket} = Component.mount(%{})
      {:ok, socket} = Component.update(%{id: "test"}, socket)

      {:noreply, updated_socket} = Component.handle_event("show_preferences", %{}, socket)

      assert updated_socket.assigns.show_preferences == true
    end
  end

  describe "handle_event/3 - toggle_preference" do
    test "toggles analytics preference on" do
      {:ok, socket} = Component.mount(%{})
      {:ok, socket} = Component.update(%{id: "test"}, socket)

      params = %{"_target" => ["analytics"], "analytics" => "on"}
      {:noreply, updated_socket} = Component.handle_event("toggle_preference", params, socket)

      assert updated_socket.assigns.analytics_enabled == true
    end

    test "toggles analytics preference off" do
      {:ok, socket} = Component.mount(%{})
      {:ok, socket} = Component.update(%{id: "test"}, socket)
      {:noreply, socket} = Component.handle_event("accept_all", %{}, socket)

      params = %{"_target" => ["analytics"]}
      {:noreply, updated_socket} = Component.handle_event("toggle_preference", params, socket)

      assert updated_socket.assigns.analytics_enabled == false
    end

    test "toggles marketing preference on" do
      {:ok, socket} = Component.mount(%{})
      {:ok, socket} = Component.update(%{id: "test"}, socket)

      params = %{"_target" => ["marketing"], "marketing" => "on"}
      {:noreply, updated_socket} = Component.handle_event("toggle_preference", params, socket)

      assert updated_socket.assigns.marketing_enabled == true
    end
  end

  describe "handle_event/3 - close_preferences" do
    test "closes preferences modal" do
      {:ok, socket} = Component.mount(%{})
      {:ok, socket} = Component.update(%{id: "test"}, socket)
      {:noreply, socket} = Component.handle_event("show_preferences", %{}, socket)

      {:noreply, updated_socket} = Component.handle_event("close_preferences", %{}, socket)

      assert updated_socket.assigns.show_preferences == false
    end
  end
end
