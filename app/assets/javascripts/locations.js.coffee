# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.library_locations').sortable({connectWith: ".trip_locations"});
  $('.trip_locations').sortable({connectWith: ".library_locations", cancel: ".info"});

