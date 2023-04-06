defmodule NewsForumWeb.NewsForumLive do
  @moduledoc """
  Page LiveView
  """

  use NewsForumWeb, :live_view
  alias NewsForum.Forum
  alias NewsForum.Forum.Post
  alias NewsForum.Utils

  def mount(_params, _session, socket) do
    articles = Forum.list_articles_by_cat("news")
    posts = Forum.list_posts_by_cat("news")

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
        <h1 class="mb-6 text-5xl font-bold">News Forum</h1>
        <h3 class="mb-8 text-3xl font-bold">Discuss the latest issues in the news.</h3>
        <img class="inline max-w-xs h-auto rounded-t-md" alt="" src="https://upload.wikimedia.org/wikipedia/commons/f/f1/Noun_Newspaper_154015.svg" />
      </div>

      <div class="flex justify-between grid grid-cols-1 mb-5">
        <h2 class="mt-0 mb-2 text-3xl font-medium text-center leading-tight text-primary">Articles</h2>
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

      <h2 class="mt-0 mb-2 text-3xl font-medium text-center leading-tight text-primary">Here's What Other Users are Saying</h2>
      <div class="flex justify-between grid grid-cols-3 gap-6 m-10 mb-10">
        <%= for post <- @posts do %>
          <article class="container bg-white shadow-2xl rounded-2xl p-5">
            <h1 class="font-bold text-purple-500">
              <%= post.title %> || <%= Utils.display_datetime(post.date) %>
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
        <h2 class="mt-0 mb-2 text-3xl font-medium leading-tight text-center text-primary">Record Your Own Reaction</h2>
          <.form for={@form} phx-submit="classify">
            <div class="flex flex-wrap">
              <.input 
                type="text" 
                value={@title} 
                name="title" 
                field={@form}
                class="peer block min-h-[auto] w-2/3 rounded border-0 bg-transparent py-[0.32rem] px-3 leading-[1.6] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0"
              />
              <.input 
                type="date" 
                value={@date} 
                name="date" 
                field={@form}
                class="peer block min-h-[auto] w-1/3 rounded border-0 bg-transparent py-[0.32rem] px-3 leading-[1.6] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0"
              />
            </div>
            <.input 
              type="textarea" 
              value={@body} 
              name="body" 
              field={@form}
              class="peer block min-h-[auto] w-full rounded border-0 bg-transparent py-[0.32rem] px-3 leading-[1.6] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0"
            />
            <div class="flex flex-col items-center justify-center">
              <button class="inline-block rounded bg-primary px-6 pt-2.5 pb-2 text-xs font-medium uppercase leading-normal text-white shadow-[0_4px_9px_-4px_#3b71ca] transition duration-150 ease-in-out hover:bg-primary-600 hover:shadow-[0_8px_9px_-4px_rgba(59,113,202,0.3),0_4px_18px_0_rgba(59,113,202,0.2)] focus:bg-primary-600 focus:shadow-[0_8px_9px_-4px_rgba(59,113,202,0.3),0_4px_18px_0_rgba(59,113,202,0.2)] focus:outline-none focus:ring-0 active:bg-primary-700 active:shadow-[0_8px_9px_-4px_rgba(59,113,202,0.3),0_4px_18px_0_rgba(59,113,202,0.2)]">Post</button>
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

  defp classify(serving, text) do
    %{classification: [%{label: label}]} = Nx.Serving.run(serving, text)

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

    if classification.label != "news" do
      error_msg = "This is a News forum. Please only write about news and current affairs."
      link = "/" <> classification.label
      {:noreply,
        socket
        |> assign(waiting: false)
        |> assign(classification: classification.label)
        |> assign(classification_link: link)
        |> assign(error: error_msg)
      }
    else
      {:noreply,
        socket
        |> assign(waiting: false)
        |> assign(classification: classification.label)
        |> assign(posts: [{socket.assigns.body, socket.assigns.title, socket.assigns.date, classification.label} | socket.assigns.posts])
        |> assign(title: nil)
        |> assign(body: nil)
      }
    end
  end
end