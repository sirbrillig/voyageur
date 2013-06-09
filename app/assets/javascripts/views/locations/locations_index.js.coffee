class Voyageur.Views.LocationsIndex extends Backbone.View
  el: '.library_locations'

  template: JST['locations/index']

  render: () ->
    # FIXME: can we have each Location render itself?
    @$el.html @template({locations: @collection, trip_id: @options['trip_id']}) # FIXME: is using options the right way to do this?
    this

