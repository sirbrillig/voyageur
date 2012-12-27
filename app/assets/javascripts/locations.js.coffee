# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

from_library = false

addresses_from_trip = () ->
  addrs = []
  for addr in $('.trip_locations p.address')
    addrs.push(addr.textContent)
  addrs

location_id_from_ui = (ui) ->
  matches = ui.item[0].className.match(/location_(\d+)/)
  if matches
    return matches[1]
  return null

index_from_ui = (ui) ->
  ui.item.index() - 1

get_trip_id = () ->
  matches = $('.trip_locations').get(0).className.match(/trip_id_(\d+)/)
  if matches
    return matches[1]
  return null

reload_trip = () ->
  trip_id = get_trip_id()
  $('.trip').load("/trips/#{trip_id}")
  setup_dragging()
  load_map() # FIXME re-write the map

add_to_trip_at_index = (event, ui) -> 
  trip_id = get_trip_id()
  id = location_id_from_ui(ui)
  index = index_from_ui(ui)
  $.ajax
    url: "/trips/#{trip_id}/add/#{id}/at/#{index}"
    type: "GET"
    dataType: "json"
    success: (data) ->
      reload_trip()

move_location = (event, ui) ->
  trip_id = get_trip_id()
  index = index_from_ui(ui)
  start_index = ui.item.start_index
  $.ajax
    url: "/trips/#{trip_id}/move/#{start_index}/to/#{index}"
    type: "GET"
    dataType: "html"
    success: (data) ->
      reload_trip()

save_index = (event, ui) ->
  ui.item.start_index = index_from_ui(ui)

start_drag = (event, ui) ->
  save_index(event, ui)

is_from_trip_list = (event, ui) ->
  if from_library
    return false
  else
    return true

stop_drag = (event, ui) ->
  if is_from_trip_list(event, ui)
    move_location(event, ui)
  else 
    add_to_trip_at_index(event, ui)
  from_library = false

move_from_library = (event, ui) ->
  from_library = true

setup_dragging = () ->
  $('.trip').sortable({items: ".location_block", opacity: 0.5, revert: "invalid", start: start_drag, stop: stop_drag, receive: move_from_library, placeholder: "location-glow"})
  $('.library_locations .location').draggable(helper: "clone", opacity: 0.5, revert: "invalid", connectToSortable: ".trip")

# These are for the map.
directionsDisplay = null
directionsService = null
map = null

start_map = () ->
  directionsDisplay = new google.maps.DirectionsRenderer()
  chicago = new google.maps.LatLng(41.850033, -87.6500523)
  mapOptions =
    zoom: 11,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    center: chicago
  map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions)
  directionsDisplay.setMap(map)

calc_route = () ->
  addrs = addresses_from_trip()
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
  directionsService.route request, (result, status) ->
    directionsDisplay.setDirections result  if status is google.maps.DirectionsStatus.OK

load_map = () ->
  directionsService = new google.maps.DirectionsService()
  start_map()
  calc_route()

$ ->
  setup_dragging()
  canvas = $('#map_canvas')
  if canvas.get(0)
    load_map()
