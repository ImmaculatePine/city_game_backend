defmodule Googleapis.Maps.Geocoding.Client do
  alias Googleapis.Maps.Geocoding.{Request, Response}

  def get(params) do
    case Request.get(params) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}}
      when status_code >= 200 and status_code < 300 ->
        Response.new(body)

      {:ok, %HTTPoison.Response{body: reason}} ->
        {:error, reason}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      _ ->
        :error
    end
  end
end
