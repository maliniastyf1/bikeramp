# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatsServices::PrepareWeeklyStatsReport do
  let(:date) { Date.new(2018, 10, 3) }
  let(:date_2) { Date.new(2018, 10, 5) }
  let(:date_out_of_range) { Date.new(2018, 9, 25) }

  let!(:trip_1) do
    create(
      :trip,
      destination_address: 'Sokratesa 13, Warszawa, Polska',
      date: date,
    )
  end
  let!(:trip_2) do
    create(
      :trip,
      destination_address: 'Sokratesa 13, Warszawa, Polska',
      date: date,
    )
  end
  let!(:trip_3) do
    create(
      :trip,
      destination_address: 'Sokratesa 13, Warszawa, Polska',
      date: date_2,
    )
  end
  let!(:trip_4) do
    create(
      :trip,
      destination_address: 'Sokratesa 13, Warszawa, Polska',
      date: date_out_of_range,
    )
  end

  before do
    Timecop.freeze(Time.zone.local(2018, 10, 6))
  end

  after do
    Timecop.return
  end

  subject { described_class.call }

  context 'when trips are in week range' do
    it 'return success object' do
      expect(subject.success?).to eq(true)
    end

    it 'return weekly stats' do
      expect(subject.success[:total_distance]).to eq('60km')
      expect(subject.success[:total_price]).to eq('150.00PLN')
    end
  end

  context 'when trips are out of week range' do
    let(:date) { Date.new(2018, 9, 3) }
    let(:date_2) { Date.new(2018, 9, 5) }

    it 'return success object' do
      expect(subject.success?).to eq(true)
    end

    it 'return weekly stats' do
      expect(subject.success[:total_distance]).to eq('0km')
      expect(subject.success[:total_price]).to eq('0.00PLN')
    end
  end

  context '#total_distance' do
    let(:weekly_trips) { [trip_1, trip_2] }

    subject { described_class.new.send(:total_distance, weekly_trips) }

    shared_examples 'sum of distance' do
      it 'returns sum of distance' do
        expect(subject).to eq(distance)
      end
    end

    context 'when trips have distance' do
      let(:distance) { 40 }

      include_examples 'sum of distance'
    end

    context 'when one trip do not have distance' do
      let(:trip_without_distance) { create(:trip, distance: nil, date: date_2) }
      let(:weekly_trips) { [trip_1, trip_without_distance] }
      let(:distance) { 20 }

      include_examples 'sum of distance'
    end
  end
end
