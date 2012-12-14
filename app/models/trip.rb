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
    if index
      # FIXME: not working
      self.triplocations << Triplocation.create!(location_id: location.id, trip_id: self.id, position: position_for_index(index) + 1)
    else
      self.locations << location
    end
    $stderr.puts "triplocations = "+self.triplocations.collect { |t| t.inspect }.join(", ")
  end

  def remove_location_at(index)
    self.triplocations.delete(self.triplocations[index])
  end

  def move_location_up(index)
    self.triplocations[index].move_higher unless index < 1
  end

  def move_location_down(index)
    self.triplocations[index].move_lower if index < self.triplocations.size
  end

  private
  # Find the acts_as_list position for a 0-based index value.
  def position_for_index(index)
    to_move = self.triplocations.last
    self.triplocations.each_with_index { |tloc, tloc_index| to_move = tloc if tloc_index == index; }
    to_move.position
  end
end
