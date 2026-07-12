defmodule HeadsUpWeb.CtegoryLiveTest do
  use HeadsUpWeb.ConnCase

  import Phoenix.LiveViewTest
  import HeadsUp.CategoriesFixtures

  @create_attrs %{name: "some name", slug: "some slug"}
  @update_attrs %{name: "some updated name", slug: "some updated slug"}
  @invalid_attrs %{name: nil, slug: nil}
  defp create_ctegory(_) do
    ctegory = ctegory_fixture()

    %{ctegory: ctegory}
  end

  describe "Index" do
    setup [:create_ctegory]

    test "lists all categories", %{conn: conn, ctegory: ctegory} do
      {:ok, _index_live, html} = live(conn, ~p"/categories")

      assert html =~ "Listing Categories"
      assert html =~ ctegory.name
    end

    test "saves new ctegory", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/categories")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Ctegory")
               |> render_click()
               |> follow_redirect(conn, ~p"/categories/new")

      assert render(form_live) =~ "New Ctegory"

      assert form_live
             |> form("#ctegory-form", ctegory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#ctegory-form", ctegory: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/categories")

      html = render(index_live)
      assert html =~ "Ctegory created successfully"
      assert html =~ "some name"
    end

    test "updates ctegory in listing", %{conn: conn, ctegory: ctegory} do
      {:ok, index_live, _html} = live(conn, ~p"/categories")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#categories-#{ctegory.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/categories/#{ctegory}/edit")

      assert render(form_live) =~ "Edit Ctegory"

      assert form_live
             |> form("#ctegory-form", ctegory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#ctegory-form", ctegory: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/categories")

      html = render(index_live)
      assert html =~ "Ctegory updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes ctegory in listing", %{conn: conn, ctegory: ctegory} do
      {:ok, index_live, _html} = live(conn, ~p"/categories")

      assert index_live |> element("#categories-#{ctegory.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#categories-#{ctegory.id}")
    end
  end

  describe "Show" do
    setup [:create_ctegory]

    test "displays ctegory", %{conn: conn, ctegory: ctegory} do
      {:ok, _show_live, html} = live(conn, ~p"/categories/#{ctegory}")

      assert html =~ "Show Ctegory"
      assert html =~ ctegory.name
    end

    test "updates ctegory and returns to show", %{conn: conn, ctegory: ctegory} do
      {:ok, show_live, _html} = live(conn, ~p"/categories/#{ctegory}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/categories/#{ctegory}/edit?return_to=show")

      assert render(form_live) =~ "Edit Ctegory"

      assert form_live
             |> form("#ctegory-form", ctegory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#ctegory-form", ctegory: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/categories/#{ctegory}")

      html = render(show_live)
      assert html =~ "Ctegory updated successfully"
      assert html =~ "some updated name"
    end
  end
end
