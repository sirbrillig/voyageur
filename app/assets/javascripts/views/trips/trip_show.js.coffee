class Voyageur.Views.Trip extends Backbone.View

  el: '.trip'

  template: JST['trips/show']

  start_index: null

  events:
    'click a.clear-trip': 'clear_trip'

  initialize: =>
    @model = new Voyageur.Models.Trip id: Voyageur.get_trip_id()
    @model.on 'sync', @render
    @model.get('triplocations').on 'add', @render
    @model.get('triplocations').on 'remove', @render
    $('.trip').sortable({ items: ".location_block", opacity: 0.5, revert: "invalid", start: @start_drag, stop: @stop_drag })
    @model.fetch()

  start_drag: (event, ui) =>
    @start_index = ui.item.index()

  stop_drag: (event, ui) =>
    # FIXME: write specs for this
    trip_id = Voyageur.get_trip_id()
    index = ui.item.index()
    moved_loc = @model.get('triplocations').models[@start_index]
    @model.get('triplocations').remove(moved_loc)
    moved_loc.set({'position': index})
    @model.get('triplocations').add(moved_loc, at: index)
    @model.get('triplocations').at(index).save()

  add_location: (data) =>
#    console.log "adding location: ", JSON.stringify(data)
    data['position'] = @model.get('triplocations').length + 1
    triploc = @model.get('triplocations').create(data) # FIXME: something is preventing this from triggering the add event sometimes
    @model.fetch() # This is to get an ID for the new triplocation and populate the distance
    triploc

  render: =>
#    console.log "rendering trip: ", @model
    @$el.html @template( { trip: @model, distance: @meters_to_miles( @model.get( 'distance' ) ) } )
    triplocation_area = $('.trip_locations')
    return this if triplocation_area.length < 1
    @model.get('triplocations').each (triploc) =>
      triploc_view = new Voyageur.Views.Triplocation model: triploc
      triplocation_area.append triploc_view.render().el
    @render_map()
    this

  render_map: =>
    # FIXME: map doesn't look so good at small width
    @setup_map()
    @calc_route(@model.get('triplocations').map (triploc) -> triploc.get('location').get('address'))

  meters_to_miles: (meters) ->
    miles_per_meter = 0.000621371
    (meters * miles_per_meter).toFixed(1)

  clear_trip: (e) =>
    e.preventDefault() if e
    while @model.get('triplocations').length > 0
      @model.get('triplocations').remove(@model.get('triplocations').at(0))

  # Google Maps Reference: https://developers.google.com/maps/documentation/javascript/reference
  directionsDisplay: null
  directionsService: null
  map_obj: null

  setup_map: () =>
    @directionsService = new google.maps.DirectionsService() unless @directionsService
    @directionsDisplay = new google.maps.DirectionsRenderer() unless @directionsDisplay
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
    return unless elem
    @map_obj = new google.maps.Map elem, mapOptions
    @directionsDisplay.setMap(@map_obj)

  calc_route: (addrs) =>
    return if addrs.length < 2
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
