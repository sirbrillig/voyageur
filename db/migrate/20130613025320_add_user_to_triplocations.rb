class AddUserToTriplocations < ActiveRecord::Migration
  def change
    add_column :triplocations, :user_id, :integer

    Triplocation.all.each do |loc|
      next unless loc.trip_id
      loc.user_id = loc.trip.user_id
      loc.save
    end
  end
end
