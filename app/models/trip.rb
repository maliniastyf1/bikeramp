# frozen_string_literal: true

class Trip < ApplicationRecord
  validates :start_address, presence: true
  validates :destination_address, presence: true
  validates :price, presence: true
  validates :date, presence: true

  scope :in_range_grouped_by_day, ->(start_date, end_date) { where('date >= ? AND date <= ?', start_date, end_date).group_by(&:date) }
end
