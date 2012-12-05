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

  def move_location(id, options={})
    raise "A :to option is required." unless options.has_key? :to
    loc = self.remove_location_at(id)
    self.triplocations.create(location_id: loc.id, trip_id: self.id, index: options[:to]) # FIXME: we need to re-order all the other elements so this is a poor strategy
  end

  def add_location(location)
    self.triplocations.create(location_id: location.id, trip_id: self.id, index: last_index + 1)
  end

  def remove_location_at(index)
    the_one = self.triplocations.select { |tloc| tloc.index == index }
    raise "no Location found at index #{index}" unless the_one
    loc = self.triplocations.delete(the_one)
    return loc.first if loc.respond_to? :first
    loc
  end

  private
  def last_index
    i = 0
    self.triplocations.each { |tloc| i = tloc.index if tloc.index > i }
    i
  end
end
