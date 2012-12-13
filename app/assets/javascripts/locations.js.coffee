# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

location_id_from_ui = (ui) ->
  matches = ui.item[0].className.match(/location_(\d+)/)
  if matches
    return matches[1]

index_from_ui = (ui) ->
  ui.item.index() - 1

add_to_trip_at_index = (event, ui) -> 
  trip_id = 1 # FIXME: get the trip id
  id = location_id_from_ui(ui)
  index = index_from_ui(ui)
  $.ajax
    url: "/trips/#{trip_id}/add/#{id}/at/#{index}"
    type: "GET"
    dataType: "json"
    success: (data) ->
      #alert("Location #{id} added at #{index}") # FIXME: update or reload the trip list
      $('.trip').load("/trips/#{trip_id}") # FIXME: this breaks further sorting

add_to_trip = (event, ui) -> 
  trip_id = 1 # FIXME: get the trip id
  id = location_id_from_ui(ui)
  $.ajax
    url: "/trips/#{trip_id}/add/#{id}"
    type: "GET"
    dataType: "html"
    success: (data) ->
      alert("Location #{id} added") # FIXME: update or reload the trip list

move_location = (event, ui) ->
  trip_id = 1 # FIXME: get the trip id
  index = index_from_ui(ui)
  start_index = ui.item.start_index
  $.ajax
    url: "/trips/#{trip_id}/move/#{start_index}/to/#{index}"
    type: "GET"
    dataType: "html"
    success: (data) ->
      alert("Location #{start_index} moved to #{index}") # FIXME: update or reload the trip list

save_index = (event, ui) ->
  ui.item.start_index = index_from_ui(ui)

show_distances = (event, ui) -> 
  $('.trip_locations .distance').show()

hide_distances = (event, ui) -> 
  $('.trip_locations .distance').hide()

start_reorder_drag = (event, ui) ->
  hide_distances(event, ui)
  # FIXME: there's something weird about the indexes that get returned
  save_index(event, ui)

start_add_drag = (event, ui) ->
  hide_distances(event, ui)

finish_add_drag = (event, ui) ->
  show_distances(event, ui)

finish_reorder_drag = (event, ui) ->
  show_distances(event, ui)
  move_location(event, ui)

$ ->
  # This is for adding
  $('.trip_locations').sortable({items: ".location", opacity: 0.5, revert: "invalid", stop: add_to_trip_at_index, placeholder: "location-glow"})
  # FIXME: the below does not work at all
  # This is for reordering
  #$('.trip_locations').sortable({items: ".location", opacity: 0.5, revert: "invalid", start: start_reorder_drag, stop: finish_reorder_drag, placeholder: "location-glow"})
  $('.library_locations .location').draggable(helper: "clone", opacity: 0.5, revert: "invalid", start: start_add_drag, stop: finish_add_drag, connectToSortable: ".trip_locations")
