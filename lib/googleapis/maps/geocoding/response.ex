defmodule Googleapis.Maps.Geocoding.Response do
  def new(body) do
    with {:ok, data} <- Poison.decode(body),
         {:ok, results} <- parse(data) do
      {:ok, results}
    end
  end

  defp parse(%{"status" => "OK", "results" => results}), do: {:ok, results}
  defp parse(%{"status" => status}), do: {:error, status}
  defp parse(_), do: {:error, :unknown_response}
end
