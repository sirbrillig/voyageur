class Triplocation < ActiveRecord::Base
  attr_accessible :position, :trip_id, :location_id
  belongs_to :trip
  belongs_to :location
  acts_as_list scope: :trip
end
