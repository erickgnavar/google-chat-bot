import Config

config :alfred,
  ecto_repos: [Alfred.Repo]

config :alfred, Oban,
  repo: Alfred.Repo,
  queues: [default: 10, events: 50, media: 20]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
