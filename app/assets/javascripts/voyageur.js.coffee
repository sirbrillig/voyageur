window.Voyageur =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

  trip_view: null

  initialize: ->
    @enable_tabs()
    @trip_view = new Voyageur.Views.Trip
    new Voyageur.Views.LocationsIndex(@trip_view.model) # NOTE: not sure this is the best way to bind the views together

  check_connection: (success) ->
    $.ajax(
      url: '/ping'
      success: ->
        if window.Voyageur.offline
          window.Voyageur.offline = false
          window.Voyageur.trip_view.model.save()
          window.Voyageur.trip_view.model.fetch()
        success()
      error: ->
        window.Voyageur.offline = true
        setTimeout( ->
          window.Voyageur.check_connection(success)
        , 5000)
    )

  enable_tabs: ->
    $('#library').removeClass 'active' # allows graceful degrading
    $('#trip_tab').click (e) ->
      e.preventDefault()
      $(this).tab('show')
    $('#library_tab').click (e) ->
      e.preventDefault()
      $(this).tab('show')

  get_trip_id: ->
    trip_locations = $('.trip_locations')
    if trip_locations
      return trip_locations.attr('trip-id')
    else
      console.log 'Error: unable to find .trip_locations class to get trip ID.'
    return null


$(document).ready ->
  Voyageur.initialize() if ( $('.trip').length > 0 )
