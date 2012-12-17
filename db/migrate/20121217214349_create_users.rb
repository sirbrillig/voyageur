class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest

      t.timestamps
      add_column :locations, :user_id, :integer
      add_column :trips, :user_id, :integer
    end
  end
end
