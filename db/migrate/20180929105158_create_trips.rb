class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips, id: :uuid do |t|
      t.string    :start_address, null: false
      t.string    :destination_address, null: false
      t.decimal   :price, null: false
      t.decimal   :distance
      t.datetime  :date, null: false
    end
  end
end
