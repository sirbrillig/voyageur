# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class LocationList
  trip_index_from_ui: (ui) ->
    return $(ui.item).attr('trip-index')

  index_from_ui: (ui) ->
    ui.item.index()

  get_trip_id: () ->
    trip_locations = $('.trip_locations')
    if trip_locations
      return trip_locations.attr('trip-id')
    else
      console.log 'Error: unable to find .trip_locations class to get trip ID.'
    return null

  move_location: (event, ui) =>
    trip_id = @.get_trip_id()
    index = @.index_from_ui(ui)
    start_index = ui.item.start_index
    @load_trip_from "/trips/#{trip_id}/move/#{start_index}/to/#{index}"

  save_index: (event, ui) =>
    ui.item.start_index = @.trip_index_from_ui(ui)

  start_drag: (event, ui) =>
    @.save_index(event, ui)

  stop_drag: (event, ui) =>
    @.move_location(event, ui)

  setup_dragging: () =>
    $('.trip').sortable({items: ".location_block", opacity: 0.5, revert: "invalid", start: @.start_drag, stop: @.stop_drag })

  load_trip_from: (url) =>
    unless url
      console.log 'Error: cannot load trip from blank URL.'
      return
    $.getJSON url + '.json', (data) =>
      new Voyageur.Views.Trip

  setup_spinner: () ->
    trip = $('.trip')
    trip.ajaxStart -> trip.spin()
    trip.ajaxComplete -> trip.stop()

class VoyageurLayout
  enable_tabs: () ->
    $('#library').removeClass 'active' # allows graceful degrading
    $('#trip_tab').click (e) ->
      e.preventDefault()
      $(this).tab('show')
    $('#library_tab').click (e) ->
      e.preventDefault()
      $(this).tab('show')

$ ->
  location_list = new LocationList
  layout = new VoyageurLayout
  layout.enable_tabs()
  new Voyageur.Views.LocationsIndex
  location_list.setup_spinner()
  new Voyageur.Views.Trip
  location_list.setup_dragging()
