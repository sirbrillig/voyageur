class Voyageur.Collections.Triplocations extends Backbone.Collection
  model: Voyageur.Models.Triplocation
  url: '/triplocations'

  comparator: (triplocation) ->
    triplocation.get('position')
