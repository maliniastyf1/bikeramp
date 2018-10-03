# frozen_string_literal: true

module TripServices
  class CreateTrip < ApplicationService
    include Dry::Monads::Do.for(:call)
    def call(attributes)
      trip = yield create_trip(attributes)
      distance = yield get_distance(attributes)
      update_trip_with_distance(trip, distance)
    end

    private

    def get_distance(attributes)
      ExternalServices::GetDistance.call(attributes)
    end

    def create_trip(trip)
      trip = Trip.create(trip)
      return Success(trip) if trip.valid?

      Failure(trip.errors.messages)
    end

    def update_trip_with_distance(trip, distance)
      Success(trip.update(distance: distance))
    end
  end
end
