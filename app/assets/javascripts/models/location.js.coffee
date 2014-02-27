class Voyageur.Models.Location extends Backbone.RelationalModel
  name: 'location'

  urlRoot: '/locations'

  defaults:
    address: ''
    title: ''
    position: null

  triplocation_json: =>
    { location_id: @id, trip_id: Voyageur.get_trip_id(), location: @ }
