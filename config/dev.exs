import Config

config :logger, :console, format: "[$level] $message\n"

config :alfred, Alfred.Repo,
  url: System.get_env("DATABASE_URL"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :goth,
  json: System.get_env("GCP_CREDENTIALS") |> Base.decode64!()
