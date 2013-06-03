class Voyageur.Views.Trip extends Backbone.View

  template: JST['trips/show']

  events: ->
#    'click #trip .location a.remove-button': 'remove_location'
    'click a.remove-button': 'remove_location'
#    'click a.clear-trip #trip': 'clear_trip'
    'click a.clear-trip, #trip': 'clear_trip'

  render: =>
    @$el.html @template( { trip: @model, distance: @meters_to_miles( @model.get( 'distance' ) ) } )
    @render_map()
    this

  render_map: =>
    map = new TripMap
    map.load_map(@model.get('triplocations').map (loc) -> loc.location.address)

  meters_to_miles: (meters) ->
    miles_per_meter = 0.000621371
    (meters * miles_per_meter).toFixed(1)

  clear_trip: (e) =>
    e.preventDefault()
    $.getJSON e.target.href + '.json', (data) =>
      @model.fetch success: =>
        @render()

  remove_location: (e) =>
    e.preventDefault()
    $.getJSON e.target.href + '.json', (data) =>
      @model.fetch success: =>
        @render()

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

