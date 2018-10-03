# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripServices::CreateTrip do
  let(:date) { Date.new(2018, 10, 3) }
  let(:attributes) do
    {
      start_address: 'Plac Europejski 2, Warszawa, Polska',
      destination_address: 'Sokratesa 13, Warszawa, Polska',
      price: 50.0,
      date: date

    }
  end
  let(:distance) { Dry::Monads::Result::Success.new(BigDecimal('9.22')) }

  before do
    allow(ExternalServices::GetDistance)
      .to receive(:call).with(attributes).and_return(distance)
  end

  subject { described_class.call(attributes) }

  context 'when service receives valid trip attributes' do
    context 'and google api returns distance' do
      it 'creates trip with distance' do
        expect(subject.success?).to eq(true)
      end

      it 'creates trip with distance' do
        expect(subject.success).to eq(true)
      end
    end

    context 'and google api returns error' do
      let(:result) { Net::HTTPServerError.new(nil, 500, nil) }
      let(:failure_object) { Dry::Monads::Result::Failure.new(result) }

      before do
        allow(ExternalServices::GetDistance)
          .to receive(:call).with(attributes).and_return(failure_object)
      end

      it 'creates trip without distance' do
        expect(subject.failure?).to eq(true)
      end

      it 'creates trip without distance' do
        expect(subject.failure).to eq(result)
      end
    end
  end
end
