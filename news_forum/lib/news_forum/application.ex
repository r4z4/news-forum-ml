defmodule NewsForum.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  #  "valhalla/distilbart-mnli-12-3"

  use Application

  @impl true
  def start(_type, _args) do
    {:ok, model} = Bumblebee.load_model({:hf, "facebook/bart-large-mnli"})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "facebook/bart-large-mnli"})

    labels = ["sports", "news", "entertainment", "politics"]

    classification_serving =
      Bumblebee.Text.zero_shot_classification(
        model,
        tokenizer,
        labels,
        defn_options: [compiler: EXLA]
      )

      # Question Answering

    {:ok, roberta} = Bumblebee.load_model({:hf, "deepset/roberta-base-squad2"})
    {:ok, roberta_tokenizer} = Bumblebee.load_tokenizer({:hf, "roberta-base"})

    qa_serving = Bumblebee.Text.question_answering(roberta, roberta_tokenizer)
      
    children = [
      {Nx.Serving, name: ClassificationServing, serving: classification_serving},
      {Nx.Serving, name: QAServing, serving: qa_serving},
      {Task.Supervisor, name: NewsForum.TaskSupervisor},
      # Start the Telemetry supervisor
      NewsForumWeb.Telemetry,
      # Start the Ecto repository
      NewsForum.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: NewsForum.PubSub},
      # Start Finch
      {Finch, name: NewsForum.Finch},
      # Start the Endpoint (http/https)
      NewsForumWeb.Endpoint
      # Start a worker by calling: NewsForum.Worker.start_link(arg)
      # {NewsForum.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NewsForum.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NewsForumWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
