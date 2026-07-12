defmodule HeadsUp.CategoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HeadsUp.Categories` context.
  """

  @doc """
  Generate a unique ctegory name.
  """
  def unique_ctegory_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique ctegory slug.
  """
  def unique_ctegory_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a ctegory.
  """
  def ctegory_fixture(attrs \\ %{}) do
    {:ok, ctegory} =
      attrs
      |> Enum.into(%{
        name: unique_ctegory_name(),
        slug: unique_ctegory_slug()
      })
      |> HeadsUp.Categories.create_ctegory()

    ctegory
  end
end
