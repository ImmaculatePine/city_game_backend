defmodule Googleapis.Maps.Geocoding.ClientTest do
  use CityGameBackend.DataCase
  import Mock

  alias Googleapis.Maps.Geocoding.{Client, Request, RequestMock}

  @params %{address: "Poznanska 1, Poznan"}

  test "should return parsed response body" do
    with_mock Request, get: &RequestMock.ok/1 do
      assert {:ok, response} = Client.get(@params)

      assert [
               %{
                 "geometry" => %{
                   "location" => %{
                     "lat" => 52.413108,
                     "lng" => 16.9040789
                   }
                 }
               }
             ] = response
    end
  end

  test "should return error status on API error" do
    with_mock Request, get: &RequestMock.api_error/1 do
      assert {:error, "REQUEST_DENIED"} = Client.get(@params)
    end
  end
end
