class Voyageur.Views.LocationsIndex extends Backbone.View
  el: '.library_locations'

  template: JST['locations/index']

  initialize: (trip) =>
    @collection = new Voyageur.Collections.Locations
    @collection.on 'sync', @render
    @collection.fetch()

  render: () =>
    @$el.html @template()
    location_area = $('.locations')
    @collection.each (loc) =>
      location_view = new Voyageur.Views.Location model: loc
      location_area.append location_view.render().el
    this
