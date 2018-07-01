defmodule Googleapis.Maps.Geocoding.Request do
  @api_url "https://maps.googleapis.com/maps/api/geocode/json"

  def get(params) do
    HTTPoison.get(@api_url <> "?" <> URI.encode_query(params))
  end
end
