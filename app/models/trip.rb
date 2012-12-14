class Trip < ActiveRecord::Base
  has_many :triplocations, order: :position
  # FIXME: make sure triplocations get deleted when no longer used.
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
      position = position_for_index(index)
#       $stderr.puts "trying to insert at position #{position} (index #{index})"
      self.locations << location
#       $stderr.puts "triplocations = "+self.triplocations.collect { |t| t.inspect }.join(", ")
      tloc = self.triplocations.where(location_id: location.id, trip_id: self.id).last
#       $stderr.puts "tloc = #{tloc.inspect}"
      tloc.insert_at(position)
      save
#       reload
#       $stderr.puts "triplocations = "+self.triplocations.collect { |t| t.inspect }.join(", ")
    else
      self.locations << location
    end
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
  # Find the (1-based) acts_as_list position for a 0-based index value.
  def position_for_index(index)
    to_move = self.triplocations[index]
    return to_move.position if to_move
    return 1 if self.triplocations.empty?
    self.triplocations.last.position + 1
  end
end
