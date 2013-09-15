window.Voyageur =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

  trip_view: null

  initialize: ->
    @enable_tabs()
    @begin_monitor()
    @setup_spinner()
    @trip_view = new Voyageur.Views.Trip
    new Voyageur.Views.LocationsIndex(@trip_view.model) # NOTE: not sure this is the best way to bind the views together

  begin_monitor: ->
    setTimeout(@monitor_connection, 2000)

  monitor_connection: ->
    console.log 'ping'
    $.ajax(
      url: '/'
      complete: ->
        setTimeout( ->
          window.Voyageur.monitor_connection()
        , 2000)
      success: ->
        console.log 'pong'
      error: ->
        console.log 'ping failed'
    )

  setup_spinner: ->
    doc = $(document)
    $.ajaxSetup timeout: 20000
    doc.ajaxStart =>
      $('.trip .summary').spin({lines: 10, radius: 5, length: 5, width: 4})
    doc.ajaxComplete => $('.trip .summary').spin(false)
    doc.ajaxError (event, jqxhr, settings, exception) =>
      if ( jqxhr.responseText && jqxhr.responseText.length > 0 )
        error = "A server error occurred when I tried to access the URL '" + settings.url + "': " + jqxhr.responseText + "; Sorry about that! Try doing what you just did again or reload the page."
      else
        error = "When I tried to do that last action, I wasn't able to connect to the server. You may want to check your Internet connection and try doing what you just did again."
      console.log error
      alert error

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
