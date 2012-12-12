class Triplocation < ActiveRecord::Base
  attr_accessible :position, :trip_id, :location_id
  belongs_to :trip
  belongs_to :location
  acts_as_list scope: :trip

  # A front-end to insert_at from acts_as_list in order to compensate for the
  # index starting at 1.
  def insert_at_index(index)
    self.insert_at(index + 1)
  end
end
