# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class LocationList
  addresses_from_trip: () ->
    addrs = []
    for addr in $('.trip_locations p.address')
      addrs.push(addr.textContent)
    addrs

  location_id_from_ui: (ui) ->
    matches = ui.item[0].className.match(/location_(\d+)/)
    if matches
      return matches[1]
    return null

  trip_index_from_ui: (ui) ->
    matches = ui.item[0].className.match(/trip_location_(\d+)/)
    if matches
      return matches[1]
    return null

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
    $.getJSON url + '.json', (data) =>
      @populate_trip(data.id)

  populate_trip: (trip_id) =>
    unless trip_id
      console.log 'Error populating trip: no trip ID found.'
      return
    trip = new Voyageur.Models.Trip id: trip_id
    trip.fetch success: (trip) =>
      new Voyageur.Views.Trip el: $('.trip'), model: trip # FIXME: why can't we put the el selector in the View?

  # Set up each Add Location To Trip button with ajax functionality.
  setup_adding: () =>
    self = this # hack to get around losing references in nested call
    $('.location a.add-button', 'ul.library_locations').click (e) ->
        e.preventDefault()
        self.load_trip_from @

class VoyageurLayout
  enable_tabs: () ->
    $('#library').removeClass('active') # allows graceful degrading
    $('#trip_tab').click(
     (e) ->
       e.preventDefault()
       $(this).tab('show')
    )
    $('#library_tab').click(
     (e) ->
       e.preventDefault()
       $(this).tab('show')
    )

$ ->
  location_list = new LocationList
  layout = new VoyageurLayout
  layout.enable_tabs()
  location_list.setup_dragging()
  location_list.setup_adding()
  location_list.populate_trip(location_list.get_trip_id())
