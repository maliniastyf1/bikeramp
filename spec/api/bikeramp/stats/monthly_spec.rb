# frozen_string_literal: true

require 'rails_helper'

describe Bikeramp::Stats::Monthly, type: :request do
  let(:endpoint) { '/api/stats/monthly' }
  let(:success_object) { Dry::Monads::Result::Success.new(monthly_stats) }

  before do
    allow(::StatsServices::PrepareMonthlyStatsReport)
      .to receive(:call).and_return(success_object)
  end

  subject { get endpoint }

  context 'when receives request and service returns proper stats' do
    let(:monthly_stats) do
      [
        {
          'day':            'July, 4th',
          'total_distance': '12km',
          'avg_ride':       '4km',
          'avg_price':      '22.75PLN'
        },
        {
          'day':            'July, 5th',
          'total_distance': '3km',
          'avg_ride':       '3km',
          'avg_price':      '15.5PLN'
        }
      ]
    end

    it 'responds with 200 and proper body' do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(monthly_stats.to_json)
    end

    it 'runs proper service object' do
      expect(::StatsServices::PrepareMonthlyStatsReport)
        .to receive(:call).and_return(success_object).once
      subject
    end
  end

  context 'when receives request and service return empty hash' do
    let(:monthly_stats) { [] }

    it 'responds with 200 and proper body' do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(monthly_stats.to_json)
    end

    it 'runs proper service object' do
      expect(::StatsServices::PrepareMonthlyStatsReport)
        .to receive(:call).and_return(success_object).once
      subject
    end
  end
end
