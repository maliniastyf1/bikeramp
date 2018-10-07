# frozen_string_literal: true

module Bikeramp
  module Stats
    class Monthly < Base
      desc 'Get monthly stats'

      namespace :stats do
        namespace :monthly do
          before { @stats = StatsServices::PrepareMonthlyStatsReport.call.value! }

          get do
            @stats
          end
        end
      end
    end
  end
end
