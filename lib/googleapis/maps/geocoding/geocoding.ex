defmodule Googleapis.Maps.Geocoding do
  alias Googleapis.Maps.Geocoding.Client

  @api_key Application.get_env(:city_game_backend, :googleapis)[:api_key]

  def call(address) do
    address
    |> to_query()
    |> add_api_key()
    |> Client.get()
  end

  defp to_query(address), do: %{address: address}
  defp add_api_key(query), do: Map.put(query, :key, @api_key)
end
