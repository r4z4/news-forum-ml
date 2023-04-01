defmodule NewsForum.Forums.ForumsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NewsForum.Forums.Forums` context.
  """

  @doc """
  Generate a forum.
  """
  def forum_fixture(attrs \\ %{}) do
    {:ok, forum} =
      attrs
      |> Enum.into(%{
        articles: [],
        category: "some category",
        desc: "some desc",
        members: [],
        title: "some title"
      })
      |> NewsForum.Forums.Forums.create_forum()

    forum
  end
end
