defmodule NewsForumWeb.ArticleLive.Show do
  use NewsForumWeb, :live_view

  alias NewsForum.Forum

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
      socket
      |> assign(form: nil)
      |> assign(error: nil)
      |> assign(question: nil)
      |> assign(answer: nil)
      |> assign(waiting: nil)
      |> assign(ref: nil)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:article, Forum.get_article!(id))}
  end

  def handle_event("ask", %{"question" => question}, socket) do
    input = %{question: question, context: socket.assigns.article.content}
    results =
      Task.Supervisor.async_nolink(NewsForum.TaskSupervisor, fn ->
        input
        |> then(&Nx.Serving.batched_run(QAServing, &1))
      end,
      max_concurrency: 4,
      timeout: :infinity
      )

    # classification = List.first(results.predictions)
    # classification.score will be %
    {:noreply, 
      socket
      |> assign(answer: nil)
      |> assign(error: nil)
      |> assign(ref: results.ref)
      |> assign(waiting: true)
    }
  end

  def handle_info({ref, result}, socket) do
    # The task succeed so we can cancel the monitoring and discard the DOWN message
    Process.demonitor(socket.assigns.ref, [:flush])
    answer = List.first(result.results)
    
    # if answer.score > 0.5 do
    if !answer.text do
      {:noreply,
        socket
        |> assign(waiting: false)
        |> assign(answer: nil)
        |> assign(error: "This is a Sports forum. Please only write about sports.")
      }
    else
      # Function just takes params as a map, not a %Post struct
      {:noreply,
        socket
        |> assign(waiting: false)
        |> assign(answer: answer.text )
      }
    end
  end

  defp page_title(:show), do: "Show Article"
  defp page_title(:edit), do: "Edit Article"
end
