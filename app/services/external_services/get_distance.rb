# frozen_string_literal: true

require 'net/http'

module ExternalServices
  class GetDistance < ApplicationService
    include Dry::Monads::Do.for(:call)

    GOOGLE_API_URL = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial'
    private_constant :GOOGLE_API_URL

    def call(trip)
      request = yield create_request_url(trip)
      response = yield send_request_to_google(request)
      get_distance_from_response(response)

    end

    private

    def create_request_url(trip)
      Success(get_url(trip))
    end

    def send_request_to_google(request)
      Success(Net::HTTP.get(request))
    end

    def get_distance_from_response(response)
      response = JSON.parse(response)

      Success(get_distance(response))
    end

    def get_distance(response)
      distance_in_km(response).round(2)
    end

    def distance_value(response)
      response['rows'].first['elements'].first['distance']['value']
    end

    def distance_in_km(response)
      BigDecimal(distance_value(response)) / 1000
    end

    def api_key
      "key=#{ENV['GOOGLE_API_KEY']}"
    end

    def get_url(trip)
      URI([GOOGLE_API_URL, mode, origin(trip), destination(trip), api_key].join('&'))
    end

    def origin(trip)
      "origins=#{trip[:start_address]}"
    end

    def destination(trip)
      "destinations=#{trip[:destination_address]}"
    end

    def mode
      'mode=bicycling'
    end
  end
end
