defmodule Googleapis.Maps.Geocoding.RequestMock do
  def ok(_params) do
    {:ok,
     %HTTPoison.Response{
       body: """
         {
           "results": [
             {
               "address_components": [
                 {
                   "long_name": "1",
                   "short_name": "1",
                   "types": [
                     "street_number"
                   ]
                 },
                 {
                   "long_name": "Poznańska",
                   "short_name": "Poznańska",
                   "types": [
                     "route"
                   ]
                 },
                 {
                   "long_name": "Jeżyce",
                   "short_name": "Jeżyce",
                   "types": [
                     "political",
                     "sublocality",
                     "sublocality_level_1"
                   ]
                 },
                 {
                   "long_name": "Poznań",
                   "short_name": "Poznań",
                   "types": [
                     "locality",
                     "political"
                   ]
                 },
                 {
                   "long_name": "Poznań",
                   "short_name": "Poznań",
                   "types": [
                     "administrative_area_level_2",
                     "political"
                   ]
                 },
                 {
                   "long_name": "wielkopolskie",
                   "short_name": "wielkopolskie",
                   "types": [
                     "administrative_area_level_1",
                     "political"
                   ]
                 },
                 {
                   "long_name": "Poland",
                   "short_name": "PL",
                   "types": [
                     "country",
                     "political"
                   ]
                 },
                 {
                   "long_name": "60-101",
                   "short_name": "60-101",
                   "types": [
                     "postal_code"
                   ]
                 }
               ],
               "formatted_address": "Poznańska 1, 60-101 Poznań, Poland",
               "geometry": {
                 "location": {
                   "lat": 52.413108,
                   "lng": 16.9040789
                 },
                 "location_type": "ROOFTOP",
                 "viewport": {
                   "northeast": {
                     "lat": 52.4144569802915,
                     "lng": 16.9054278802915
                   },
                   "southwest": {
                     "lat": 52.41175901970851,
                     "lng": 16.9027299197085
                   }
                 }
               },
               "place_id": "ChIJ52-FB7ZEBEcR3K843wkUlzc",
               "types": [
                 "street_address"
               ]
             }
           ],
           "status": "OK"
         }
       """,
       headers: [],
       status_code: 200
     }}
  end

  def api_error(_params) do
    {:ok,
     %HTTPoison.Response{
       body: """
         {
           "error_message": "This API project is not authorized to use this API.",
           "results": [],
           "status": "REQUEST_DENIED"
         }
       """,
       headers: [],
       status_code: 200
     }}
  end
end
