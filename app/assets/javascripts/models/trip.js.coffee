class Voyageur.Models.Trip extends Backbone.Model
  name: 'trip'

  urlRoot: '/trips'

  defaults:
    triplocations: []
    user_id: null
    distance: 0
    num_avail_locations: 0
