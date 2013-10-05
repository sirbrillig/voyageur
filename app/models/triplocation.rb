class Triplocation < ActiveRecord::Base
  attr_accessible :position, :trip_id, :location_id, :location, :trip
  belongs_to :trip
  belongs_to :location
  belongs_to :user
  acts_as_list scope: :trip
  before_validation :set_user
  validates :user_id, :trip_id, :location_id, presence: true

  # A front-end to insert_at from acts_as_list in order to compensate for the
  # index starting at 1.
  def insert_at_index(index)
    self.insert_at(index + 1)
  end

  def set_user
    return unless self.user.nil?
    raise "Trip must be set" if self.trip.nil?
    self.user = self.trip.user
  end

  def distance
    self.trip.distance
  end

  def serializable_hash(options={})
    options = { include: :location, methods: [ :distance ] }.update(options)
    super(options)
  end
end
