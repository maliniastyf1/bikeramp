# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatsServices::PrepareMonthlyStatsReport do
  let(:date) { Date.new(2018, 10, 3) }
  let(:date_2) { Date.new(2018, 10, 5) }
  let(:date_3) { Date.new(2018, 10, 6) }

  let!(:trip_1) do
    create(
      :trip,
      date: date,
    )
  end
  let!(:trip_2) do
    create(
      :trip,
      date: date,
    )
  end
  let!(:trip_3) do
    create(
      :trip,
      date: date_2,
    )
  end
  let!(:trip_4) do
    create(
      :trip,
      date: date_3,
    )
  end

  before do
    Timecop.freeze(Time.zone.local(2018, 10, 6))
  end

  after do
    Timecop.return
  end

  subject { described_class.call }

  context 'when searches and prepares monthly stats' do
    it 'returns success object' do
      expect(subject.success?).to eq(true)
    end

    it 'returns array of reports for all days' do
      expect(subject.success.size).to eq(3)
    end

    it 'returns daily stats hash' do
      expect(subject.success.first[:day]).to eq('October, 3rd')
      expect(subject.success.first[:total_distance]).to eq('40km')
      expect(subject.success.first[:avg_ride]).to eq('20km')
      expect(subject.success.first[:avg_price]).to eq('50.00PLN')
    end
  end

  context '#daily_stats_from_trips' do
    let(:grouped_trips) { [date, [trip_1, trip_2]] }
    let(:stats_keys) { %i(day total_distance avg_ride avg_price) }

    subject { described_class.new.send(:daily_stats_from_trips, grouped_trips) }

    context 'when method receives trips grouped_by day' do
      it 'returns hash with daily report attributes' do
        expect(subject.keys).to eq(stats_keys)
      end

      it 'returns daily stats hash with formated statistics' do
        expect(subject[:day]).to eq('October, 3rd')
        expect(subject[:total_distance]).to eq('40km')
        expect(subject[:avg_ride]).to eq('20km')
        expect(subject[:avg_price]).to eq('50.00PLN')
      end
    end
  end
end
