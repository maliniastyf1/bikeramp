# frozen_string_literal: true

module Bikeramp
  module Stats
    class Weekly < Base
      desc 'Get weekly stats'

      namespace :stats do
        namespace :weekly do
          before { @stats = StatsServices::PrepareWeeklyStatsReport.call.value! }

          get do
            @stats
          end
        end
      end
    end
  end
end
