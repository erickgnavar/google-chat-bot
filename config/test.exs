import Config

config :logger, level: :warn

config :alfred, Oban,
  crontab: false,
  queues: false

config :alfred, Alfred.Repo,
  username: "postgres",
  password: "postgres",
  database: "alfred_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
