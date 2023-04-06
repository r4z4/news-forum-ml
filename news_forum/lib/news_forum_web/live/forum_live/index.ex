defmodule NewsForumWeb.ForumLive.Index do
  use NewsForumWeb, :live_view

  alias NewsForum.Forums
  alias NewsForum.Forums.Forum

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :forums, Forums.list_forums())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Forum")
    |> assign(:forum, Forums.get_forum!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Forum")
    |> assign(:forum, %Forum{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Forums")
    |> assign(:forum, nil)
  end

  @impl true
  def handle_info({NewsForumWeb.ForumLive.FormComponent, {:saved, forum}}, socket) do
    {:noreply, stream_insert(socket, :forums, forum)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    forum = Forums.get_forum!(id)
    {:ok, _} = Forums.delete_forum(forum)

    {:noreply, stream_delete(socket, :forums, forum)}
  end
end
