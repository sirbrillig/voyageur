class Location < ActiveRecord::Base
  attr_accessible :address, :title
  has_and_belongs_to_many :trips
end
