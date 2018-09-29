# frozen_string_literal: true

require 'rails_helper'

describe Bikeramp::Trips::Create, type: :request do
  let(:endpoint) { '/api/trips' }
  let(:date) { Date.new(2018, 10, 22) }
  let(:attributes) do
    {
      'start_address' => 'Plac Europejski 2, Warszawa, Polska',
      'destination_address' => 'Aleja Jana Pawła II 65, Warszawa, Polska',
      'price' => 50,
      'date' => date
    }
  end

  let(:params) do
    { 'data' => { 'attributes' => attributes } }
  end

  before do
    allow(::TripServices::CreateTrip)
      .to receive(:call).with(params).and_return(:created)
  end

  subject { post endpoint, params: params }

  context 'when trip params are valid' do
    let(:response_body) { 201 }

    it 'responds with 200 and proper body' do
      subject
      expect(response).to have_http_status(:created)
      expect(response.body).to eq(response_body.to_json)
    end

    it 'runs proper service object' do
      expect(::TripServices::CreateTrip)
        .to receive(:call).with(params).and_return(:created).once
      subject
    end
  end

  context 'when trip params are invalid' do
    let(:response_body) { 422 }
    let(:date) { 'invalid value' }
    let(:message) { 'invalid value' }

    it 'responds with 422 and proper body' do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq(message)
    end
  end
end
