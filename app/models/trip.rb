class Trip < ActiveRecord::Base
  attr_accessible :user_id
  has_many :triplocations, order: :position
  has_many :locations, through: :triplocations, order: :position
  belongs_to :user

  def distance
    total = 0
    self.locations.each_with_index do |loc, index|
      total += loc.distance_to(self.locations[index+1]) unless (index + 1) >= self.locations.size
    end
    total
  end

  def num_avail_locations
    self.user.locations.size
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
      self.locations << location
      tloc = self.triplocations.where(location_id: location.id, trip_id: self.id).last
      tloc.insert_at(position)
      save
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

  def as_json(options={})
    # FIXME: it would be nice if we could move half of this to
    # Triplocation#as_json, but that doesn't work for some reason.
    super( include: { :triplocations => { include: :location } }, methods: [ :distance, :num_avail_locations ] )
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
