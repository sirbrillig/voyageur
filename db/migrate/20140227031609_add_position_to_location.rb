class AddPositionToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :position, :integer, :default => 0
  end
end
