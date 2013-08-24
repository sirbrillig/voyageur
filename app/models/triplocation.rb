class Triplocation < ActiveRecord::Base
  attr_accessible :position, :trip_id, :location_id, :location, :trip
  belongs_to :trip
  belongs_to :location
  belongs_to :user
  acts_as_list scope: :trip
  before_validation :set_user
  validates :user, :trip, :location, presence: true

  # A front-end to insert_at from acts_as_list in order to compensate for the
  # index starting at 1.
  def insert_at_index(index)
    self.insert_at(index + 1)
  end

  def set_user
    return unless self.user.nil?
    self.user = self.trip.user
  end
end
