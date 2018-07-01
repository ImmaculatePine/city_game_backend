defmodule Googleapis.Maps.GeocodingTest do
  use CityGameBackend.DataCase
  import Mock

  alias Googleapis.Maps.Geocoding
  alias Googleapis.Maps.Geocoding.{Request, RequestMock}

  @address "Poznanska 1, Poznan"

  test "should make a request for an address lookup and return API response" do
    with_mock Request, get: &RequestMock.ok/1 do
      assert {:ok, [%{}]} = Geocoding.call(@address)

      assert called(
               Request.get(%{
                 address: @address,
                 key: nil
               })
             )
    end
  end
end
