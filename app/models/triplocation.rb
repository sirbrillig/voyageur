class Triplocation < ActiveRecord::Base
  attr_accessible :position
  belongs_to :trip
  belongs_to :location
  belongs_to :user
  acts_as_list scope: :trip
  before_create :set_user

  # A front-end to insert_at from acts_as_list in order to compensate for the
  # index starting at 1.
  def insert_at_index(index)
    self.insert_at(index + 1)
  end

  def set_user
    self.user = self.trip.user
  end

  def num_triplocations
    self.trip.locations.size
  end
end
