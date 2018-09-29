# frozen_string_literal: true

module TripServices
  class CreateTrip < ApplicationService
    def call(attributes)
      Trip.new(attributes)
    end
  end
end
