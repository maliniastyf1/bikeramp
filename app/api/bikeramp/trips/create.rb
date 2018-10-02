# frozen_string_literal: true

module Bikeramp
  module Trips
    class Create < Base
      desc 'Create a trip'
      helpers Params

      namespace :trips do
        params { use :trip }

        post do
          ::TripServices::CreateTrip.call(attributes(params))

          status :created
        end
      end
      rescue_from ArgumentError, Grape::Exceptions::ValidationErrors, with: -> { Rack::Response.new('invalid value', 422) }
    end
  end
end
