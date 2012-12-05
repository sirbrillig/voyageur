class Trip < ActiveRecord::Base
  has_many :triplocations
  has_many :locations, through: :triplocations

  def distance
    total = 0
    self.locations.each_with_index do |loc, index|
      total += loc.distance_to(self.locations[index+1]) unless (index + 1) >= self.locations.size
    end
    total
  end

  def move_location(index, options={})
    raise "A :to option is required." unless options.has_key? :to
    loc = self.locations[index]
    self.remove_location_at(index)
    self.triplocations.create(location_id: loc.id, trip_id: self.id)
  end

  def add_location(location)
    self.locations << location
  end

  def remove_location_at(index)
    self.triplocations.delete(self.triplocations[index])
  end
end
