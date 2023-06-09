defmodule NewsForum.ForumTest do
  use NewsForum.DataCase

  alias NewsForum.Forum

  describe "articles" do
    alias NewsForum.Forum.Article

    import NewsForum.ForumFixtures

    @invalid_attrs %{attachments: nil, category: nil, content: nil, date: nil, desc: nil, title: nil}

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      assert Forum.list_articles() == [article]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert Forum.get_article!(article.id) == article
    end

    test "create_article/1 with valid data creates a article" do
      valid_attrs = %{attachments: [], category: "some category", content: "some content", date: ~N[2023-03-17 00:54:00], desc: "some desc", title: "some title"}

      assert {:ok, %Article{} = article} = Forum.create_article(valid_attrs)
      assert article.attachments == []
      assert article.category == "some category"
      assert article.content == "some content"
      assert article.date == ~N[2023-03-17 00:54:00]
      assert article.desc == "some desc"
      assert article.title == "some title"
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()
      update_attrs = %{attachments: [], category: "some updated category", content: "some updated content", date: ~N[2023-03-18 00:54:00], desc: "some updated desc", title: "some updated title"}

      assert {:ok, %Article{} = article} = Forum.update_article(article, update_attrs)
      assert article.attachments == []
      assert article.category == "some updated category"
      assert article.content == "some updated content"
      assert article.date == ~N[2023-03-18 00:54:00]
      assert article.desc == "some updated desc"
      assert article.title == "some updated title"
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_article(article, @invalid_attrs)
      assert article == Forum.get_article!(article.id)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = Forum.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = Forum.change_article(article)
    end
  end

  describe "posts" do
    alias NewsForum.Forum.Post

    import NewsForum.ForumFixtures

    @invalid_attrs %{category: nil, content: nil, date: nil, title: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Forum.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Forum.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{category: "some category", content: "some content", date: ~N[2023-04-04 18:47:00], title: "some title"}

      assert {:ok, %Post{} = post} = Forum.create_post(valid_attrs)
      assert post.category == "some category"
      assert post.content == "some content"
      assert post.date == ~N[2023-04-04 18:47:00]
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{category: "some updated category", content: "some updated content", date: ~N[2023-04-05 18:47:00], title: "some updated title"}

      assert {:ok, %Post{} = post} = Forum.update_post(post, update_attrs)
      assert post.category == "some updated category"
      assert post.content == "some updated content"
      assert post.date == ~N[2023-04-05 18:47:00]
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_post(post, @invalid_attrs)
      assert post == Forum.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Forum.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Forum.change_post(post)
    end
  end
end
