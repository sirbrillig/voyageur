window.Voyageur =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

  trip_view: null

  initialize: ->
    @enable_tabs()
    @setup_spinner()
    @trip_view = new Voyageur.Views.Trip
    new Voyageur.Views.LocationsIndex(@trip_view.model) # NOTE: not sure this is the best way to bind the views together

  setup_spinner: () ->
    doc = $(document)
    doc.ajaxStart =>
      $('.trip .summary').html '<br/>'
      $('.trip .summary').spin({lines: 10, radius: 5, length: 5, width: 4})
    doc.ajaxComplete => $('.trip .summary').spin(false)
    doc.ajaxError (event, jqxhr, settings, exception) =>
      error = "A server error occurred trying to access '" + settings.url + "': " + jqxhr.responseText + "; Sorry about that. Maybe try again?"
      console.log error
      alert error
      $('.trip .summary').spin(false)

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
  Voyageur.initialize() if ( $('.trip').length > 0 )
