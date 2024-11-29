# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :harvest,
  ecto_repos: [Harvest.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :harvest, HarvestWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: HarvestWeb.ErrorHTML, json: HarvestWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Harvest.PubSub,
  live_view: [signing_salt: "NSCKLy/j"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :harvest, Harvest.Mailer, adapter: Swoosh.Adapters.Local

# API endpoint for miners
config :harvest,
  miners_api_url: "http://localhost:9000/miners?subnet=10.60.10.0%2F24"

# Finch pool configuration
config :harvest, Harvest.Finch,
  pools: %{
    default: [
      conn_opts: [
        transport: :http1,
        retry: true,
        max_connections: 10
      ]
    ]
  }

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  harvest: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  harvest: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
