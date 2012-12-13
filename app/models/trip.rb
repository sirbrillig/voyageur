class Trip < ActiveRecord::Base
  has_many :triplocations, order: :position
  has_many :locations, through: :triplocations, order: :position

  def distance
    total = 0
    self.locations.each_with_index do |loc, index|
      total += loc.distance_to(self.locations[index+1]) unless (index + 1) >= self.locations.size
    end
    total
  end

  def location_at(index)
    self.locations.find_by_id(self.triplocations[index].location_id)
  end

  def move_location(index, options={})
    raise "A :to option is required." unless options.has_key? :to
    triploc = self.triplocations[index]
    raise "Error moving index #{index} to index #{options[:to]}: No Location found at index #{index}" unless triploc
    triploc.insert_at_index(options[:to])
  end

  def add_location(location, index=nil)
    self.locations << location
    if index
      # Not a perfect solution in the case of multiple simultaneous additions,
      # but should prevent most problems.
      self.triplocations.where(location_id: location.id).last.insert_at_index(index)
    end
  end

  def remove_location_at(index)
    self.triplocations.delete(self.triplocations[index])
  end

  def move_location_up(index)
    move_location(index, to: index - 1) unless index < 1
  end

  def move_location_down(index)
    move_location(index, to: index + 1) if index < self.triplocations.size
  end
end
