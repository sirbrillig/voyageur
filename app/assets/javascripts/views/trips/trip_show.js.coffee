class Voyageur.Views.Trip extends Backbone.View

  el: '.trip'

  template: JST['trips/show']

  events:
    'click a.clear-trip': 'clear_trip'
    'update-sort': 'update_sort'

  initialize: =>
    @model = new Voyageur.Models.Trip id: Voyageur.get_trip_id()
    @model.on 'sync', @render
    @model.get('triplocations').on 'remove', @render
    $('.trip').sortable
      items: ".location_block"
      opacity: 0.5
      revert: "invalid"
      stop: @stop_drag
    @model.fetch()

  stop_drag: (event, ui) =>
    ui.item.trigger('drop', ui.item.index())

  update_sort: (event, model, position) =>
    model.set('position': position)
    model.save()
    @model.get('triplocations').add(model)
    @model.fetch()

  add_location: (data) =>
    data['position'] = @model.get('triplocations').length
    triploc = @model.get('triplocations').create(data) # FIXME: something is preventing this from triggering the add event sometimes in the specs
    @render()
    @model.fetch()
    triploc

  render: =>
#    console.log "rendering trip: ", @model
    # TODO: don't render if we're clearing.
    @$el.html @template( { trip: @model, distance: @meters_to_miles( @model.get( 'distance' ) ) } )
    triplocation_area = $('.trip_locations')
    return this if triplocation_area.length < 1
    @model.get('triplocations').sort()
    @model.get('triplocations').each (triploc) =>
      triploc_view = new Voyageur.Views.Triplocation model: triploc
      triplocation_area.append triploc_view.render().el
    if @model.get('triplocations').length < 1
      $('.clear-trip').attr('disabled', true)
    else
      $('.clear-trip').attr('disabled', false)
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
    return if @model.get('triplocations').length < 1
    triplocs = @model.get('triplocations').map (triploc) -> triploc
    triplocs.map (triploc) -> triploc.destroy()
    @model.fetch()

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
      # (https://developers.google.com/maps/documentation/javascript/reference#DirectionsStatus)
