# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalServices::GetDistance do
  let(:date) { Date.new(2018, 10, 3) }
  let(:trip) do
    {
      start_address: 'Plac Europejski 2, Warszawa, Polska',
      destination_address: 'Sokratesa 13, Warszawa, Polska',
      price: 50.0,
      date: date

    }
  end

  let(:distance) { BigDecimal('9.22') }

  subject { described_class.call(trip) }

  context 'when proper attributes are present' do
    it 'gets distance from goole api' do
       VCR.use_cassette('google/request') do
         expect(subject.success?).to eq(true)
         expect(subject.success).to eq(distance)
       end
    end
  end

  context '#create_request_url' do
    let(:request) do
      'https://maps.googleapis.com/maps/api/distancematrix/'\
      'json?units=imperial&mode=bicycling&origins=Plac%20'\
      'Europejski%202,%20Warszawa,%20Polska&destinations='\
      'Sokratesa%2013,%20Warszawa,%20Polska&'
    end
    let(:api_key) { "key=#{ENV['GOOGLE_API_KEY']}" }
    let(:uri) { URI([request, api_key].join('')) }

    subject { described_class.new }

    it 'expect to be success' do
      expect(subject.send(:create_request_url, trip).success?). to eq(true)
    end

    it 'returns proper request' do
      expect(subject.send(:create_request_url, trip).success). to eq(uri)
    end
  end

  context '#get_distance_from_response' do
    let(:response) do
      {
        'destination_addresses': ['Sokratesa 13, 00-001 Warszawa, Poland'],
        'origin_addresses': ['plac Europejski 2, 00-844 Warszawa, Poland'],
        'rows':
        [{
          'elements':
           [{
             'distance': { 'text': '5.7 mi', 'value': 9215 },
             'duration': { 'text': '33 mins', 'value': 1990 },
             'status': 'OK'
           }]
        }],
        'status': 'OK'
      }
    end

    subject { described_class.new }

    it 'returns success' do
      expect(subject.send(:get_distance_from_response, response.to_json).success?).to eq(true)
    end
    it 'returns distance' do
      expect(subject.send(:get_distance_from_response, response.to_json).success).to eq(distance)
    end
  end
end
