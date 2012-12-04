class Trip < ActiveRecord::Base
  has_and_belongs_to_many :locations

  def distance
    total = 0
    self.locations.each_with_index do |loc, index|
      total += loc.distance_to(self.locations[index+1]) unless (index + 1) >= self.locations.size
    end
    total
  end

  def move_location(id, options={})
    raise "A :to option is required." unless options.has_key? :to
    loc = self.locations.delete_at(id)
    self.locations.insert(options[:to], loc)
  end

  def remove_location_at(index)
    loc = self.locations.delete_at(index)
  end
end
