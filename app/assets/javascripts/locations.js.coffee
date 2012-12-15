# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

location_id_from_ui = (ui) ->
  matches = ui.item[0].className.match(/location_(\d+)/)
  if matches
    return matches[1]

index_from_ui = (ui) ->
  ui.item.index() - 1

get_trip_id = () ->
  1 # FIXME: get the trip id

reload_trip = () ->
  $('.trip').load("/trips/#{trip_id}")
  setup_dragging()

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
      alert("Location #{start_index} moved to #{index}")

save_index = (event, ui) ->
  ui.item.start_index = index_from_ui(ui)

start_drag = (event, ui) ->
  save_index(event, ui)

from_trip_list = (event, ui) ->
  false # FIXME: make this check for the saved index

stop_drag = (event, ui) ->
  if from_trip_list(event, ui)
    move_location(event, ui)
  else 
    add_to_trip_at_index(event, ui)

setup_dragging = () ->
  $('.trip').sortable({items: ".location", opacity: 0.5, revert: "invalid", start: start_drag, stop: stop_drag, placeholder: "location-glow"})
  $('.library_locations .location').draggable(helper: "clone", opacity: 0.5, revert: "invalid", connectToSortable: ".trip")

$ ->
  setup_dragging()
