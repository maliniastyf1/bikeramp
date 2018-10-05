# frozen_string_literal: true

require 'rails_helper'

describe Bikeramp::Stats::Weekly, type: :request do
  let(:endpoint) { '/api/stats/weekly' }
  let(:date) { Date.new(2018, 10, 22) }
  let(:weekly_stats) do
    {
      'total_distance': '40km',
      'total_price':    '49.75PLN'
    }
  end

  before do
    allow(::StatsServices::PrepareWeeklyStatsReport)
      .to receive(:call).and_return(weekly_stats)
  end

  subject { get endpoint }

  context 'when receives request and service returns proper stats' do
    it 'responds with 200 and proper body' do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(weekly_stats.to_json)
    end

    it 'runs proper service object' do
      expect(::StatsServices::PrepareWeeklyStatsReport)
        .to receive(:call).and_return(weekly_stats.to_json).once
      subject
    end
  end

  context 'when receives request and service return empty hash' do
    let(:weekly_stats) { {} }

    it 'responds with 200 and proper body' do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(weekly_stats.to_json)
    end

    it 'runs proper service object' do
      expect(::StatsServices::PrepareWeeklyStatsReport)
        .to receive(:call).and_return(weekly_stats.to_json).once
      subject
    end
  end
end
