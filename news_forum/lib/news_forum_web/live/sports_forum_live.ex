defmodule NewsForumWeb.SportsForumLive do
  @moduledoc """
  Page LiveView
  """

  use NewsForumWeb, :live_view

  def mount(_params, _session, socket) do
    # path = Path.join(:code.priv_dir(:app), "Kitten.mp4")

    {:ok,
      socket
      |> assign(title: nil)
      |> assign(date: nil)
      |> assign(error: nil)
      |> assign(body: nil)
      |> assign(ref: nil)
      |> assign(form: nil)
      |> assign(classification: nil)
      |> assign(classification_link: nil)
      |> assign(posts: [])
    }
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex flex-col">
      <div
        class="bg-neutral-50 py-10 px-6 text-center text-neutral-800 dark:bg-neutral-700 dark:text-neutral-200">
        <h1 class="mb-6 text-5xl font-bold">Sports Forum!</h1>
        <h3 class="mb-8 text-3xl font-bold">For the fans.</h3>
      </div>
      <div>
        <img class="max-w-full h-auto rounded-t-md" alt="" src="https://upload.wikimedia.org/wikipedia/commons/0/0c/Sport_balls.svg" />
      </div>

      <div class="flex-1 flex flex-col justify-center mx-auto w-full">
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

        <div class="flex justify-between grid grid-cols-3 gap-6 m-10 mb-10">
          <%= for {post, title, date, label} <- @posts do %>
            <article class="container bg-white shadow-2xl rounded-2xl p-5">
              <h1 class="font-bold text-purple-500">
                <%= title %>
              </h1>
              <p class="font-light text-gray-500 hover:font-bold">
                <%= post %>
              </p>
              <h6 class="text-sm text-gray-300 mb-5">
                <%= date %>
              </h6>
              <a href="#" class="rounded-lg py-2 px-4 text-center text-white bg-yellow-400 hover:bg-yellow-500">User's Page</a>
            </article>
          <% end %>
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
        |> assign(classification: classification.label)
        |> assign(classification_link: link)
        |> assign(error: "This is a Sports forum. Please only write about sports.")
      }
    else
      {:noreply,
        socket
        |> assign(classification: classification.label)
        |> assign(posts: [{socket.assigns.body, socket.assigns.title, socket.assigns.date, classification.label} | socket.assigns.posts])
        |> assign(title: nil)
        |> assign(body: nil)
      }
    end
  end
end