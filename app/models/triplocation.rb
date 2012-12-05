class Triplocation < ActiveRecord::Base
  attr_accessible :index, :trip_id, :location_id
  belongs_to :trip
  belongs_to :location
end
