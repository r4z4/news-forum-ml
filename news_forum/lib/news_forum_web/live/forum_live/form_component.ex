defmodule NewsForumWeb.ForumLive.FormComponent do
  use NewsForumWeb, :live_component

  alias NewsForum.Forums

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage forum records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="forum-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:category]} type="text" label="Category" />
        <.input field={@form[:desc]} type="text" label="Desc" />
        <.input
          field={@form[:members]}
          type="select"
          multiple
          label="Members"
          options={[]}
        />
        <.input
          field={@form[:articles]}
          type="select"
          multiple
          label="Articles"
          options={[]}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Forum</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{forum: forum} = assigns, socket) do
    changeset = Forums.change_forum(forum)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"forum" => forum_params}, socket) do
    changeset =
      socket.assigns.forum
      |> Forums.change_forum(forum_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"forum" => forum_params}, socket) do
    save_forum(socket, socket.assigns.action, forum_params)
  end

  defp save_forum(socket, :edit, forum_params) do
    case Forums.update_forum(socket.assigns.forum, forum_params) do
      {:ok, forum} ->
        notify_parent({:saved, forum})

        {:noreply,
         socket
         |> put_flash(:info, "Forum updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_forum(socket, :new, forum_params) do
    case Forums.create_forum(forum_params) do
      {:ok, forum} ->
        notify_parent({:saved, forum})

        {:noreply,
         socket
         |> put_flash(:info, "Forum created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
