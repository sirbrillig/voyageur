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
    matches = $('.trip_locations').get(0).className.match(/trip_id_(\d+)/)
    if matches
      return matches[1]
    return null

  # Deprecated. Use populate_trip instead.
  reload_trip: () =>
    trip_id = @.get_trip_id()
    $('.trip').load("/trips/#{trip_id}")
    @.setup_dragging()
    @.load_map() # FIXME re-write the map

  add_to_trip_at_index: (event, ui) =>
    trip_id = @.get_trip_id()
    id = @.location_id_from_ui(ui)
    index = @.index_from_ui(ui)
    $.ajax
      url: "/trips/#{trip_id}/add/#{id}/at/#{index}"
      type: "GET"
      dataType: "json"
      success: (data) =>
        @.reload_trip()

  move_location: (event, ui) =>
    trip_id = @.get_trip_id()
    index = @.index_from_ui(ui)
    start_index = ui.item.start_index
    $.ajax
      url: "/trips/#{trip_id}/move/#{start_index}/to/#{index}"
      type: "GET"
      dataType: "html"
      success: (data) =>
        @.reload_trip()

  save_index: (event, ui) =>
    ui.item.start_index = @.trip_index_from_ui(ui)

  start_drag: (event, ui) =>
    @.save_index(event, ui)

  stop_drag: (event, ui) =>
    @.move_location(event, ui)

  setup_dragging: () =>
    $('.trip').sortable({items: ".location_block", opacity: 0.5, revert: "invalid", start: @.start_drag, stop: @.stop_drag })

  populate_trip: (tripdata, locations=[]) =>
    loc_collection = new Voyageur.Collections.Locations
    trip = new Voyageur.Models.Trip triplocations: tripdata.triplocations, id: tripdata.id, user_id: tripdata.user_id, distance: tripdata.distance, all_locations: locations
    trip_view = new Voyageur.Views.Trip el: $('.trip'), model: trip
    trip_view.render()
    this.setup_clear()
    this.setup_removing()
    map = new TripMap
    map.load_map(tripdata.triplocations.map (loc) -> loc.location.address)

  # Set up each Add Location To Trip button with ajax functionality.
  setup_adding: () =>
    self = this # hack to get around losing references in nested call
    $('.location a.add-button', 'ul.library_locations').click (e) ->
        e.preventDefault()
        $.getJSON @ + '.json', (data) ->
          self.populate_trip(data.trip, data.locations)

  # Set up the Remove Location button on each Trip location with ajax
  # functionality.
  setup_removing: () =>
    self = this # hack to get around losing references in nested call
    $('.location a.remove-button', '#trip').click (e) ->
        e.preventDefault()
        $.getJSON @ + '.json', (data) ->
          self.populate_trip(data.trip, data.locations)

  # Set up the Clear Trip button to use ajax.
  setup_clear: () =>
    self = this # hack to get around losing references in nested call
    $('a.clear-trip', '#trip').click (e) ->
        e.preventDefault()
        $.getJSON @ + '.json', (data) ->
          self.populate_trip(data.trip, data.locations)

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

class TripMap
  # Reference:
  # https://developers.google.com/maps/documentation/javascript/reference

  directionsDisplay: null
  directionsService: null
  map: null

  start_map: () =>
    @.directionsDisplay = new google.maps.DirectionsRenderer() unless @.directionsDisplay
    mapOptions =
      zoom: 11,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      overviewMapControl: false,
      scaleControl: false,
      streetViewControl: false,
      zoomControl: false,
      mapTypeControl: false
    @.map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions) unless @.map
    @.directionsDisplay.setMap(@.map)

  calc_route: (addrs) =>
    start = addrs.shift()
    end = addrs.pop()
    waypts = []
    for addr in addrs
      waypts.push({location: addr, stopover: true})
    request =
      origin: start,
      destination: end,
      waypoints: waypts,
      travelMode: google.maps.TravelMode.DRIVING
    @.directionsService.route request, (result, status) =>
      if status is google.maps.DirectionsStatus.OK
        @.directionsDisplay.setDirections result
      # FIXME: display any google errors

  load_map: (addrs) =>
    canvas = $('#map_canvas')
    return unless canvas.get(0)
    @.directionsService = new google.maps.DirectionsService() unless @.directionsService
    @.start_map() unless @.directionsDisplay
    @.calc_route(addrs)


$ ->
  location_list = new LocationList
  layout = new VoyageurLayout
  map = new TripMap
  layout.enable_tabs()
  location_list.setup_dragging()
  location_list.setup_adding()
  location_list.setup_clear()
  location_list.setup_removing()
  map.load_map(location_list.addresses_from_trip())
