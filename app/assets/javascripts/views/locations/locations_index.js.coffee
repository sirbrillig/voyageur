class Voyageur.Views.LocationsIndex extends Backbone.View
  el: '.library_locations'

  template: JST['locations/index']

  events:
    'click a.add-button': 'add_location_to_trip'

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

  add_location_to_trip: (e) =>
    # FIXME: do this right through JS and update the list in the background
    e.preventDefault()
    url = $(e.target).attr('href')
    url = $(e.target).parent().attr('href') unless url
    unless url
      console.log 'Error: cannot load trip from blank URL.'
      return
    $.getJSON url + '.json', (data) =>
      @trip.fetch()
