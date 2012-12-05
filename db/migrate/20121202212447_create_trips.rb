class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.timestamps
    end

    create_table :triplocations do |t|
      t.integer :index
      t.references :location, :trip
    end
  end
end
