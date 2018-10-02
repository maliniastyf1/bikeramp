# frozen_string_literal: true

FactoryBot.define do
  factory :trip do
    start_address { 'Plac Europejski 2, Warszawa, Polska' }
    destination_address { 'Sokratesa 9, Warszawa, Polska' }
    price { 50.0 }
    distance { 20.0 }
    date { Date.new(2018, 10, 3) }
  end
end
