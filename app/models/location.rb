require 'uri'
require 'open-uri'
require 'json'

class Location < ActiveRecord::Base
  attr_reader :query_sent
  attr_accessible :position, :address, :title, :user_id
  has_many :triplocations, order: :position, dependent: :destroy
  has_many :trips, through: :triplocations, order: :position
  belongs_to :user
  acts_as_list scope: :user
  validates :address, presence: true
  validates :title, presence: true
  audited

  def uri_address
    URI.escape(self.address)
  end

  def distance_to(destination)
    if cached = cached_distance_to(destination)
      return cached
    end
    val = query_distance_to(destination)
    cache_distance_to(destination, val)
    return val
  end

  def cached_distance_to(destination)
    cache_timeout_date = Time.now - 2.days
    dist = Distance.where(origin: self.address, destination: destination.address).first
    return nil unless dist
    if dist.created_at < cache_timeout_date
      dist.destroy
      return nil
    end
    @query_sent = false
    return dist.distance
  end

  private
  def cache_distance_to(destination, distance)
    Distance.create(origin: self.address, destination: destination.address, distance: distance)
  end

  def query_distance_to(destination)
    @query_sent = true
    # https://developers.google.com/maps/documentation/distancematrix/
    query = "http://maps.googleapis.com/maps/api/distancematrix/json?origins=#{self.uri_address}&destinations=#{destination.uri_address}&mode=driving&sensor=false&units=imperial"
    json_object = JSON.parse(open(query).read)
    json_object["rows"][0]['elements'][0]['distance']['value'].to_i
  end
end
