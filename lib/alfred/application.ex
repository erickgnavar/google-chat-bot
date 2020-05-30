defmodule Alfred.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Alfred.Repo, []},
      {Oban, oban_config()},
      {Plug.Cowboy,
       scheme: :http,
       plug: AlfredWeb.Router,
       options: [port: String.to_integer(System.get_env("PORT", "4000"))]},
      {Alfred.ChatSender, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Alfred.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp oban_config do
    opts = Application.get_env(:alfred, Oban)

    # Prevent running queues or scheduling jobs from an iex console.
    if Code.ensure_loaded?(IEx) and IEx.started?() do
      opts
      |> Keyword.put(:crontab, false)
      |> Keyword.put(:queues, false)
    else
      opts
    end
  end
end
