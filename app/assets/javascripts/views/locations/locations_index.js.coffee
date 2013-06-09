class Voyageur.Views.LocationsIndex extends Backbone.View
  el: '.library_locations'

  template: JST['locations/index']

  events:
    'click a.add-button': 'add_location_to_trip'

  initialize: =>
    locations = new Voyageur.Collections.Locations
    locations.fetch success: =>
      @collection = locations
      @trip_id = Voyageur.get_trip_id()
      @render()

  render: () ->
    # FIXME: can we have each Location render itself?
    @$el.html @template({locations: @collection, trip_id: @trip_id})
    this

  add_location_to_trip: (e) =>
    e.preventDefault()
    url = $(e.target).attr('href')
    url = $(e.target).parent().attr('href') unless url
    unless url
      console.log 'Error: cannot load trip from blank URL.'
      return
    $.getJSON url + '.json', (data) =>
      new Voyageur.Views.Trip
