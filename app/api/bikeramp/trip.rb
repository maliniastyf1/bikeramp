# frozen_string_literal: true

module Bikeramp
  class Trip < Grape::API
    prefix :api
    content_type :json, 'application/vnd.api+json'
    default_format :json

    add_swagger_documentation \
    mount_path: '/docs',
    add_base_path: true,
    produces: 'application/vnd.api+json',
    array_use_braces: true,
    security_definitions: {
      api_key: { type: 'basic', name: 'Authorization', in: 'header' }
    }

    rescue_from ArgumentError, Grape::Exceptions::ValidationErrors, with: -> { Rack::Response.new('invalid value', 422) }


    desc "Create a trip"
    namespace :trips do
      params do
        requires :data, type: Hash do
          requires :attributes, type: Hash do
            requires(
              :start_address,
              type: String,
              desc: "Start address in format: 'Plac Europejski 2, Warszawa, Polska'",
            )
            requires(
              :destination_address,
              type: String,
              desc: "Destination address in format: 'Plac Europejski 2, Warszawa, Polska'",
            )
            requires(
              :price,
              type: Integer,
              desc: 'Package price in PLN',
              values: ->(v) { v > 0 },
            )
            requires(
              :date,
              type: Date,
              desc: 'Date of delivery e.g. 20-10-2018',
            )
          end
        end
      end

      post do

        ::TripServices::CreateTrip.call(params)

        status :created
      end


    end
  end
end
