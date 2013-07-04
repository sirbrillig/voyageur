class Voyageur.Views.LocationsIndex extends Backbone.View
  el: '.library_locations'

  template: JST['locations/index']

  trip: null

  initialize: (trip) =>
    @trip = trip # FIXME: let's get rid of this
    @collection = new Voyageur.Collections.Locations
    @trip_id = Voyageur.get_trip_id()
    @collection.on 'sync', @render
    @collection.fetch()

  render: () =>
    @$el.html @template()
    location_area = $('.locations')
    @collection.each (loc) =>
      location_view = new Voyageur.Views.Location model: loc
      location_area.append location_view.render(@trip_id).el
    this
