class Voyageur.Models.Location extends Backbone.Model
  name: 'location'

  defaults:
    address: ''
    title: ''

  create_triplocation: =>
    new Voyageur.Models.Triplocation location_id: @id, trip_id: Voyageur.get_trip_id(), location: @
