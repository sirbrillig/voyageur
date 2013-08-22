class Voyageur.Models.Location extends Backbone.Model
  name: 'location'

  defaults:
    address: ''
    title: ''

  triplocation_json: =>
    { location_id: @id, trip_id: Voyageur.get_trip_id(), location: @ }
