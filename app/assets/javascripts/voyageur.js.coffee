window.Voyageur =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
  get_trip_id: () ->
    trip_locations = $('.trip_locations')
    if trip_locations
      return trip_locations.attr('trip-id')
    else
      console.log 'Error: unable to find .trip_locations class to get trip ID.'
    return null


$(document).ready ->
  Voyageur.initialize()
