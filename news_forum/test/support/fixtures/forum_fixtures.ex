defmodule NewsForum.Forums.ForumFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NewsForum.Forums.Forum` context.
  """

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{
        attachments: [],
        category: "some category",
        content: "some content",
        date: ~N[2023-03-17 00:54:00],
        desc: "some desc",
        title: "some title"
      })
      |> NewsForum.Forum.create_article()

    article
  end

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        category: "some category",
        content: "some content",
        date: ~N[2023-04-04 18:47:00],
        title: "some title"
      })
      |> NewsForum.Forum.create_post()

    post
  end
end
