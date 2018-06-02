# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :city_game_backend,
  ecto_repos: [CityGameBackend.Repo]

# Configures the endpoint
config :city_game_backend, CityGameBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KZLLQJyhTMulALE3aUOmX5VkrF4XfSd2iLUzXogk1Psru1FHkps2q4JFAEkwsNqX",
  render_errors: [view: CityGameBackendWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: CityGameBackend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
