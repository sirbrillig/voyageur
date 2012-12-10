class CreateDistances < ActiveRecord::Migration
  def change
    create_table :distances do |t|
      t.string :origin
      t.string :destination
      t.integer :distance

      t.timestamps
    end
  end
end
