require 'rails_helper'

RSpec.describe Trip do
  describe 'database column' do
    it { is_expected.to have_db_column(:start_address).of_type(:string) }
    it { is_expected.to have_db_column(:destination_address).of_type(:string) }
    it { is_expected.to have_db_column(:price).of_type(:decimal) }
    it { is_expected.to have_db_column(:distance).of_type(:decimal) }
    it { is_expected.to have_db_column(:date).of_type(:datetime) }
  end
end
