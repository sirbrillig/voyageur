window.Voyageur =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

  trip_view: null

  initialize: ->
    @enable_tabs()
    @begin_monitor()
    @trip_view = new Voyageur.Views.Trip
    new Voyageur.Views.LocationsIndex(@trip_view.model) # NOTE: not sure this is the best way to bind the views together

  begin_monitor: ->
    # Make sure there's a timeout for poor connections.
    $.ajaxSetup(timeout: 30000)
    setTimeout(@monitor_connection, 5000)

  monitor_connection: ->
    $.ajax(
      url: '/ping'
      complete: ->
        setTimeout( ->
          window.Voyageur.monitor_connection()
        , 5000)
      success: ->
        if window.Voyageur.offline
          window.Voyageur.offline = false
          window.Voyageur.trip_view.model.save()
          window.Voyageur.trip_view.model.fetch()
      error: ->
        window.Voyageur.offline = true
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
