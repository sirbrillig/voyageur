class Voyageur.Models.Triplocation extends Backbone.RelationalModel
  name: 'triplocation'

  urlRoot: '/triplocations'

  defaults:
    user_id: null
    trip_id: null
    location_id: null
    position: null

  relations: [
    type: Backbone.HasOne
    key: 'location'
    relatedModel: 'Voyageur.Models.Location'
  ]
