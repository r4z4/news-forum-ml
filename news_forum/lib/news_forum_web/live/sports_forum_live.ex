defmodule NewsForumWeb.SportsForumLive do
  @moduledoc """
  Page LiveView
  """

  use NewsForumWeb, :live_view
  alias NewsForum.Forum
  alias NewsForum.Forum.Post
  alias NewsForum.Utils

  def mount(_params, _session, socket) do
    # path = Path.join(:code.priv_dir(:app), "Kitten.mp4")
    articles = Forum.list_articles_by_cat("sports")
    posts = Forum.list_posts_by_cat("sports")

    {:ok,
      socket
      |> assign(title: nil)
      |> assign(date: nil)
      |> assign(error: nil)
      |> assign(body: nil)
      |> assign(ref: nil)
      |> assign(form: nil)
      |> assign(articles: articles)
      |> assign(classification: nil)
      |> assign(classification_link: nil)
      |> assign(posts: posts)
      |> assign(waiting: false)
    }
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex flex-col">
      <div
        class="bg-neutral-50 py-10 px-6 text-center text-neutral-800 dark:bg-neutral-700 dark:text-neutral-200">
        <h1 class="mb-6 text-5xl font-bold">Sports Forum!</h1>
        <h3 class="mb-8 text-3xl font-bold">For the fans.</h3>
        <img class="inline max-w-xs max-h-28 rounded-t-md" alt="" src="https://upload.wikimedia.org/wikipedia/commons/4/46/Volleyball_%28transparent%29.svg" />
      </div>

      <div class="flex justify-between grid grid-cols-1 mb-5">
        <h2 class="mt-0 mb-2 text-3xl text-center overline font-medium leading-tight text-primary">Articles</h2>
        <%= for article <- @articles do %>
          <article class="container bg-white overflow-clip max-h-28 shadow-2xl rounded-2xl p-5">
            <h1 class="font-bold text-purple-500">
              <%= article.title %> || <%= Utils.display_datetime(article.date) %>
            </h1>
            <p class="font-light text-gray-500">
              <%= article.content %>
            </p>
          </article>
        <% end %>
      </div>

      <h2 class="mt-0 mb-2 text-3xl overline text-center font-medium leading-tight text-primary">Here's What Other Users are Saying</h2>
      <div class="flex justify-between grid grid-cols-3 gap-6 m-10 mb-10">
        <%= for post <- @posts do %>
          <article class="container bg-white shadow-2xl rounded-2xl p-5">
            <h1 class="font-bold text-purple-500">
              <%= post.title %> <span class="text-black"> || <%= Utils.display_datetime(post.date) %> </span>
            </h1>
            <p class="font-light text-gray-500">
              <%= post.content %>
            </p>
          </article>
        <% end %>
      </div>

      <div class="flex-1 flex flex-col justify-center mx-auto w-full">
        <div :if={@waiting} class="mt-4 justify-center">
            <img src="https://upload.wikimedia.org/wikipedia/commons/8/85/Throbber_allbackgrounds_circledots_32.gif" alt="" />
        </div>
      </div>

      <div class="flex-1 flex flex-col justify-center mx-auto w-full">
        <h2 class="mt-0 mb-2 text-3xl overline text-center font-medium leading-tight text-primary">Record Your Own Reaction</h2>
          <.form for={@form} phx-submit="classify">
            <.input 
              type="text" 
              value={@title} 
              name="title" 
              field={@form}
              class="peer block min-h-[auto] w-full rounded border-0 bg-transparent py-[0.32rem] px-3 leading-[1.6] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0"
            />
            <.input 
              type="date" 
              value={@date} 
              name="date" 
              field={@form}
              class="peer block min-h-[auto] w-full rounded border-0 bg-transparent py-[0.32rem] px-3 leading-[1.6] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0"
            />
            <.input 
              type="textarea" 
              value={@body} 
              name="body" 
              field={@form}
              class="peer block min-h-[auto] w-full rounded border-0 bg-transparent py-[0.32rem] px-3 leading-[1.6] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0"
            />
            <div class="flex flex-col items-center justify-center">
              <button class="inline-block rounded bg-primary px-6 pt-2.5 pb-2 text-xs font-medium uppercase leading-normal text-white">Post</button>
            </div>
          </.form>

        <div class="flex flex-col gap-4">
          <div class="flex flex-col justify-center mx-auto">
            <p :if={@error} class="error_text">
              <%= @error %>
            </p>
            <p :if={@classification_link}>
              Seems you may want to visit: <a class="classification_text" href={@classification_link}><%= String.capitalize(@classification) %></a>
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

#   defp serving do
#     {:ok, bertweet} = Bumblebee.load_model({:hf, "finiteautomata/bertweet-base-sentiment-analysis"})
#     {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "vinai/bertweet-base"})

#     Bumblebee.Text.text_classification(bertweet, tokenizer)
#   end

  defp classify(serving, body) do
    %{classification: [%{label: label}]} = Nx.Serving.run(serving, body)

    label
  end

  # def handle_info(_msg, socket), do: {:noreply, socket}

  def handle_event("save", %{"body" => body}, socket) do
    IO.inspect(body, label: "Value")
  end

  def handle_event("classify", %{"body" => body, "title" => title, "date" => date}, socket) do
    results =
      Task.Supervisor.async_nolink(NewsForum.TaskSupervisor, fn ->
        body
        |> then(&Nx.Serving.batched_run(ClassificationServing, &1))
      end,
      max_concurrency: 4,
      timeout: :infinity
      )

    # classification = List.first(results.predictions)
    # classification.score will be %
    {:noreply, 
      socket
      |> assign(classification: nil)
      |> assign(error: nil)
      |> assign(body: body)
      |> assign(date: date)
      |> assign(title: title)
      |> assign(ref: results.ref)
      |> assign(waiting: true)
    }
  end

  def handle_info({ref, result}, socket) do
    # The task succeed so we can cancel the monitoring and discard the DOWN message
    Process.demonitor(socket.assigns.ref, [:flush])
    classification = List.first(result.predictions)

    if classification.label != "sports" do
      link = "/" <> classification.label
      {:noreply,
        socket
        |> assign(waiting: false)
        |> assign(classification: classification.label)
        |> assign(classification_link: link)
        |> assign(error: "This is a Sports forum. Please only write about sports.")
      }
    else
      # Function just takes params as a map, not a %Post struct
      case %{content: socket.assigns.body, title: socket.assigns.title, category: "sports", author: "a9f44567-e031-44f1-aae6-972d7aabbb45", date: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()} |> Forum.create_post() do
      {:ok, post} -> 
        {:noreply,
          socket
          |> assign(waiting: false)
          |> assign(classification: classification.label)
          |> assign(posts: [post | socket.assigns.posts])
          |> assign(title: nil)
          |> assign(body: nil)
        }
      {:error, _} -> 
        raise "Database Error Trying to Create Post"
      end
    end
  end
end