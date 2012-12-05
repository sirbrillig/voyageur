require 'uri'
require 'open-uri'
require 'json'

class Location < ActiveRecord::Base
  attr_accessible :address, :title
  has_many :triplocations, order: :position
  has_many :trips, through: :triplocations

  def uri_address
    URI.escape(self.address)
  end

  def distance_to(destination)
    # FIXME: add caching.
    # https://developers.google.com/maps/documentation/distancematrix/
    query = "http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{self.uri_address}&destinations=#{destination.uri_address}&mode=driving&sensor=false&units=imperial"
    json_object = JSON.parse(open(query).read)
    json_object["rows"][0]['elements'][0]['distance']['value'].to_i
  end
end
