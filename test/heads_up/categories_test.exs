defmodule HeadsUp.CategoriesTest do
  use HeadsUp.DataCase

  alias HeadsUp.Categories

  describe "categories" do
    alias HeadsUp.Categories.Ctegory

    import HeadsUp.CategoriesFixtures

    @invalid_attrs %{name: nil, slug: nil}

    test "list_categories/0 returns all categories" do
      ctegory = ctegory_fixture()
      assert Categories.list_categories() == [ctegory]
    end

    test "get_ctegory!/1 returns the ctegory with given id" do
      ctegory = ctegory_fixture()
      assert Categories.get_ctegory!(ctegory.id) == ctegory
    end

    test "create_ctegory/1 with valid data creates a ctegory" do
      valid_attrs = %{name: "some name", slug: "some slug"}

      assert {:ok, %Ctegory{} = ctegory} = Categories.create_ctegory(valid_attrs)
      assert ctegory.name == "some name"
      assert ctegory.slug == "some slug"
    end

    test "create_ctegory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Categories.create_ctegory(@invalid_attrs)
    end

    test "update_ctegory/2 with valid data updates the ctegory" do
      ctegory = ctegory_fixture()
      update_attrs = %{name: "some updated name", slug: "some updated slug"}

      assert {:ok, %Ctegory{} = ctegory} = Categories.update_ctegory(ctegory, update_attrs)
      assert ctegory.name == "some updated name"
      assert ctegory.slug == "some updated slug"
    end

    test "update_ctegory/2 with invalid data returns error changeset" do
      ctegory = ctegory_fixture()
      assert {:error, %Ecto.Changeset{}} = Categories.update_ctegory(ctegory, @invalid_attrs)
      assert ctegory == Categories.get_ctegory!(ctegory.id)
    end

    test "delete_ctegory/1 deletes the ctegory" do
      ctegory = ctegory_fixture()
      assert {:ok, %Ctegory{}} = Categories.delete_ctegory(ctegory)
      assert_raise Ecto.NoResultsError, fn -> Categories.get_ctegory!(ctegory.id) end
    end

    test "change_ctegory/1 returns a ctegory changeset" do
      ctegory = ctegory_fixture()
      assert %Ecto.Changeset{} = Categories.change_ctegory(ctegory)
    end
  end
end
