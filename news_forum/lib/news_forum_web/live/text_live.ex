defmodule NewsForumWeb.TextLive do
  @moduledoc """
  Page LiveView
  """

  use NewsForumWeb, :live_view

  def mount(_params, _session, socket) do
    # path = Path.join(:code.priv_dir(:app), "Kitten.mp4")

    {:ok,
      socket
      |> assign(text: nil)
      |> assign(error: nil)
      |> assign(reason: nil)
      |> assign(ref: nil)
      |> assign(form: nil)
      |> assign(classification: nil)
      |> assign(posts: [])
    }
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex flex-col">
      <div
        class="bg-neutral-50 py-20 px-6 text-center text-neutral-800 dark:bg-neutral-700 dark:text-neutral-200">
        <h1 class="mb-6 text-5xl font-bold">The No Politics Zone!</h1>
        <h3 class="mb-8 text-3xl font-bold">Feel free to open up about anything that you so please. We just don't allow politics.</h3>
      </div>

      <div class="flex-1 flex flex-col justify-center mx-auto w-full">
          <.form for={@form} phx-submit="classify">
            <.input 
              type="textarea" 
              value={@text} 
              name="reason" 
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
            <p :if={@classification} class="classification_text">
              <%= @classification %>
            </p>
          </div>
          
          <%= for {post, label} <- @posts do %>
            <div class="post">
            <%= label %> || <%= post %>
            </div>
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

  defp classify(serving, text) do
    %{classification: [%{label: label}]} = Nx.Serving.run(serving, text)

    label
  end

  # def handle_info(_msg, socket), do: {:noreply, socket}

  def handle_event("save", %{"reason" => reason}, socket) do
    IO.inspect(reason, label: "Value")
  end

  def handle_event("classify", %{"reason" => reason}, socket) do
    results =
      Task.Supervisor.async_nolink(NewsForum.TaskSupervisor, fn ->
        reason
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
      |> assign(reason: reason)
      |> assign(ref: results.ref)
    }
  end

  def handle_info({ref, result}, socket) do
    # The task succeed so we can cancel the monitoring and discard the DOWN message
    Process.demonitor(socket.assigns.ref, [:flush])
    classification = List.first(result.predictions)

    if classification.label == "politics" do
      {:noreply,
        socket
        |> assign(classification: classification.label)
        |> assign(error: "Sorry Bub. No Politics in Heuh")
      }
    else
      {:noreply,
        socket
        |> assign(classification: classification.label)
        |> assign(posts: [{socket.assigns.reason, classification.label} | socket.assigns.posts])
        |> assign(reason: nil)
      }
    end
  end

  def handle_event("start", _params, socket) do
    send(self(), :run)

    {:noreply, assign(socket, running?: true)}
  end
end