class Voyageur.Models.Trip extends Backbone.Model
  urlRoot: '/trips'

  defaults:
    triplocations: []
    user_id: null
    distance: 0
    num_avail_locations: 0
