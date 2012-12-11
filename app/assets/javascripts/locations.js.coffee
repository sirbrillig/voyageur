# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

location_id_from_ui = (ui) ->
  matches = ui.item[0].className.match(/location_(\d+)/)
  if matches
    return matches[1]

add_to_trip = (event, ui) -> 
  trip_id = 1 # FIXME: get the trip id
  id = location_id_from_ui(ui)
  # FIXME: insert at the dropped location
  $.ajax
    url: "/trips/#{trip_id}/add/#{id}"
    type: "GET"
    dataType: "html"
    success: (data) ->
      alert("Location added") # FIXME: update or reload the trip list

$ ->
  $('.trip_locations').sortable({items: ".location", receive: add_to_trip, placeholder: "location-glow"})
  $('.library_locations .location').draggable(helper: "clone", distance: 10, opacity: 0.5, revert: "invalid", connectToSortable: ".trip_locations")
