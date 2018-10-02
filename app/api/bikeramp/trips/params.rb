# frozen_string_literal: true

module Bikeramp
  module Trips
    module Params
      extend Grape::API::Helpers

      params :trip do
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
              type: BigDecimal,
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
    end
  end
end
