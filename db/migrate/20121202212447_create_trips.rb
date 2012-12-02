class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.timestamps
    end

    create_table :locations_trips, :id => false do |t|
      t.references :location, :trip
    end

    add_index :locations_trips, [:location_id, :trip_id]
  end
end
