# frozen_string_literal: true

module StatsServices
  class PrepareWeeklyStatsReport < ApplicationService
    include Dry::Monads::Do.for(:call)
    include ActionView::Helpers::NumberHelper

    def call
      data_range = DateRange.new(start_date, end_date)
      weekly_stats = yield trips_within_range(data_range)
      weekly_total_report(weekly_stats)
    end

    private

    class DateRange < Struct.new(:start_date, :end_date)
    end

    def trips_within_range(date_range)
      Success(
        Trip.select { |trip| trip.date >= date_range.start_date && trip.date <= date_range.end_date },
      )
    end

    def weekly_total_report(weekly_stats)
      Success(
        total_distance: total_distance_from_rides(weekly_stats),
        total_price: total_price_from_rides(weekly_stats),
      )
    end

    def total_distance_from_rides(weekly_stats)
      "#{total_distance(weekly_stats)}km"
    end

    def total_price_from_rides(weekly_stats)
      "#{number_with_precision(total_price(weekly_stats), precision: 2)}PLN"
    end

    def total_distance(weekly_stats)
      weekly_stats.map(&:distance).reduce(0) { |total, distance| total + distance }.to_i
    end

    def total_price(weekly_stats)
      weekly_stats.map(&:price).reduce(0) { |total, ride| total + ride }
    end

    def start_date
      Time.zone.now.beginning_of_week
    end

    def end_date
      Time.zone.now.end_of_week
    end
  end
end
