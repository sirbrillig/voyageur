class Voyageur.Views.LocationsIndex extends Backbone.View

  template: JST['locations/index']

  render: (all_locations) ->
    @$el.html @template({triplocations: @collection, locations: all_locations})
    this

