class Voyageur.Views.Trip extends Backbone.View

  el: '.trip'

  template: JST['trips/show']

  start_index: null

  trip_map: null

  events: ->
#    'click #trip .location a.remove-button': 'remove_location'
    'click a.remove-button': 'remove_location'
#    'click a.clear-trip #trip': 'clear_trip'
    'click a.clear-trip, #trip': 'clear_trip'

  initialize: =>
    @model = new Voyageur.Models.Trip id: Voyageur.get_trip_id()
    @model.on 'sync', @render
    $('.trip').sortable({ items: ".location_block", opacity: 0.5, revert: "invalid", start: @start_drag, stop: @stop_drag })
    @model.fetch()

  start_drag: (event, ui) =>
    @start_index = ui.item.index()

  stop_drag: (event, ui) =>
    trip_id = Voyageur.get_trip_id()
    index = ui.item.index()
    url = "/trips/#{trip_id}/move/#{@start_index}/to/#{index}"
    $.getJSON url + '.json', (data) =>
      @model.fetch success: =>
        @render()

  render: =>
    @$el.html @template( { trip: @model, distance: @meters_to_miles( @model.get( 'distance' ) ) } )
    @render_map()
    this

  render_map: =>
    # FIXME: map doesn't look so good at small width
    @trip_map = new TripMap().setup() # FIXME: why can't this be in the constructor?
    @trip_map.calc_route(@model.get('triplocations').map (loc) -> loc.location.address)

  meters_to_miles: (meters) ->
    miles_per_meter = 0.000621371
    (meters * miles_per_meter).toFixed(1)

  clear_trip: (e) =>
    e.preventDefault()
    url = $(e.target).attr('href')
    url = $(e.target).parent().attr('href') unless url
    unless url
      console.log 'Error: cannot clear trip from blank URL.'
      return
    $.getJSON url + '.json', (data) =>
      @model.fetch success: =>
        @render()

  remove_location: (e) =>
    e.preventDefault()
    url = $(e.target).attr('href')
    url = $(e.target).parent().attr('href') unless url
    unless url
      console.log 'Error: cannot remove location from blank URL.'
      return
    $.getJSON url + '.json', (data) =>
      @model.fetch success: =>
        @render()

  class TripMap
    # Reference:
    # https://developers.google.com/maps/documentation/javascript/reference

    directionsDisplay: null
    directionsService: null
    map_obj: null

    start_map: () =>
      @directionsDisplay = new google.maps.DirectionsRenderer()
      # TODO: when clicking on the map, load a full google maps page.
      mapOptions =
        zoom: 11
        mapTypeId: google.maps.MapTypeId.ROADMAP
        overviewMapControl: false
        scaleControl: false
        streetViewControl: false
        zoomControl: false
        mapTypeControl: false
      elem = $('#map_canvas').get(0)
      @map_obj = new google.maps.Map elem, mapOptions
      @directionsDisplay.setMap(@map_obj)

    calc_route: (addrs) =>
      if addrs.length < 2
        return
      start = addrs.shift()
      end = addrs.pop()
      waypts = []
      for addr in addrs
        waypts.push({location: addr, stopover: true})
      request =
        origin: start
        destination: end
        waypoints: waypts
        travelMode: google.maps.TravelMode.DRIVING
      @directionsService.route request, (result, status) =>
        if status is google.maps.DirectionsStatus.OK
          @directionsDisplay.setDirections result
        else
          console.log 'Error loading map: ', result, status
        # FIXME: display any google errors

    setup: () ->
      canvas = $('#map_canvas')
      return unless canvas.get(0)
      @directionsService = new google.maps.DirectionsService()
      @start_map()
      this

