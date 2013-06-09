window.Voyageur =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

  initialize: ->
    @enable_tabs()
    @setup_spinner()
    new Voyageur.Views.LocationsIndex
    new Voyageur.Views.Trip

  setup_spinner: () ->
    trip = $('.trip')
    trip.ajaxStart -> trip.spin()
    trip.ajaxComplete -> trip.stop()

  enable_tabs: () ->
    $('#library').removeClass 'active' # allows graceful degrading
    $('#trip_tab').click (e) ->
      e.preventDefault()
      $(this).tab('show')
    $('#library_tab').click (e) ->
      e.preventDefault()
      $(this).tab('show')

  get_trip_id: () ->
    trip_locations = $('.trip_locations')
    if trip_locations
      return trip_locations.attr('trip-id')
    else
      console.log 'Error: unable to find .trip_locations class to get trip ID.'
    return null


$(document).ready ->
  Voyageur.initialize()
