class Trip < ActiveRecord::Base
  attr_accessible :user_id, :triplocations
  has_many :triplocations, order: :position
  has_many :locations, through: :triplocations, order: :position
  belongs_to :user

  def distance
    total = 0
    self.triplocations.each_with_index do |loc, index|
      total += loc.location.distance_to(self.triplocations[index+1].location) unless (index + 1) >= self.triplocations.size
    end
    total
  end

  def num_avail_locations
    self.user.locations.size
  end

  def location_at(index)
    self.locations.find(self.triplocations[index].location_id)
  end

  def move_location(index, options={})
    raise "A :to option is required." unless options.has_key? :to
    triploc = self.triplocations[index]
    raise "Error moving index #{index} to index #{options[:to]}: No Location found at index #{index}" unless triploc
    triploc.insert_at_index(options[:to])
  end

  def add_location(location, index=nil)
    raise "Error adding location '#{location}' to trip: no user is assigned to that location." unless location and location.user
    trip = self
    tloc = Triplocation.create!(location: location, trip: trip)
    if index
      position = position_for_index(index)
      tloc.insert_at(position)
      save # FIXME: necessary?
    end
    tloc
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

  def timestamp
    return Time.now.to_i
  end

  def serializable_hash(options={})
    options = {
      include: :triplocations,
      methods: [ :distance, :num_avail_locations, :timestamp ]
    }.update(options)
    super(options)
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
