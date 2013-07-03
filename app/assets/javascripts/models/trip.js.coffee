class Voyageur.Models.Trip extends Backbone.RelationalModel
  name: 'trip'

  urlRoot: '/trips'

  defaults:
    triplocations: []
    user_id: null
    distance: 0
    num_avail_locations: 0

  relations: [
    type: Backbone.HasMany
    key: 'triplocations'
    relatedModel: 'Voyageur.Models.Triplocation'
    collectionType: 'Voyageur.Collections.Triplocations'
    reverseRelation:
      key: 'trip'
  ]
