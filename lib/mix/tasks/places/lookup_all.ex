defmodule Mix.Tasks.Places.LookupAll do
  use Mix.Task

  alias CityGameBackend.Places
  alias CityGameBackend.Maps.Lookup

  @shortdoc "Adds geolocation to all existing places"
  def run(_) do
    Mix.Task.run("app.start")

    Places.list_places()
    |> Enum.each(&Lookup.lookup(&1))
  end
end
