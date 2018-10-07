# frozen_string_literal: true

module StatsServices
  class PrepareMonthlyStatsReport < ApplicationService
    include Dry::Monads::Do.for(:call)
    include ActionView::Helpers::NumberHelper

    def call
      trips_grouped_by_day = yield whole_month_grouped_by_day
      monthly_report_from_every_day(trips_grouped_by_day)
    end

    private

    def whole_month_grouped_by_day
      Success(Trip.in_range_grouped_by_day(start_date, end_date))
    end

    def monthly_report_from_every_day(trips)
      return Success([]) if trips.blank?

      Success(collection_of_daily_reports(trips))
    end

    def collection_of_daily_reports(trips)
      trips.sort.each_with_object([]) { |day, arr| arr << daily_stats_from_trips(day) }
    end

    def daily_stats_from_trips(day)
      {
        day: formated_date(day.first),
        total_distance: formated_total_distance(day),
        avg_ride: formated_average_ride(day),
        avg_price: formated_average_ride_price(day)
      }
    end

    def formated_date(date)
      date.strftime("%B, #{date.day.to_i.ordinalize}")
    end

    def formated_total_distance(trips)
      "#{daily_total_distance(trips)}km"
    end

    def formated_average_ride(trips)
      "#{daily_average_ride_distance(trips).to_i}km"
    end

    def formated_average_ride_price(trips)
      "#{number_with_precision(daily_average_ride_price(trips), precision: 2)}PLN"
    end

    def daily_total_distance(trips)
      count_total_distance(trips).to_i
    end

    def daily_average_ride_distance(trips)
      count_total_distance(trips) / number_of_trips(trips)
    end

    def daily_average_ride_price(trips)
      trips[1].map(&:price).compact.reduce(0, :+) / number_of_trips(trips)
    end

    def count_total_distance(trips)
      trips[1].map(&:distance).compact.reduce(0, :+)
    end

    def number_of_trips(trips)
      trips[1].size
    end

    def start_date
      Time.zone.now.beginning_of_month
    end

    def end_date
      Time.zone.now.end_of_month
    end
  end
end
