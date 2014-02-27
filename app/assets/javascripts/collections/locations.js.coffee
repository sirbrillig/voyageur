class Voyageur.Collections.Locations extends Backbone.Collection
  model: Voyageur.Models.Location
  url: '/locations'

  comparator: (location) ->
    location.get('position')
