class Voyageur.Views.Trip extends Backbone.View

  el: '.trip'

  template: JST['trips/show']

  events:
    'click a.clear-trip': 'clear_trip'
    'update-sort': 'update_sort'
    'update-distance': 'update_distance'

  initialize: =>
    @model = new Voyageur.Models.Trip id: Voyageur.get_trip_id()
    @model.on 'sync', @render
    @model.get('triplocations').on 'remove', @loading_distance
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
    # TODO: we should update the map here
    @map_distance = false

  update_distance: (event, distance) =>
    @model.set('distance', distance)
    @double_check_distance()

  loading_distance: () =>
    @render()
    $('#trip-distance').find('.distance').html( 'loading' )

  add_location: (data) =>
    data['position'] = @model.get('triplocations').length
    triploc = @model.get('triplocations').create(data)
    @loading_distance()
    triploc

  render: =>
    #console.log "rendering trip: ", @model
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

  # Google Maps Reference: https://developers.google.com/maps/documentation/javascript/reference
  directionsDisplay: null
  directionsService: null
  map_obj: null

  setup_map: () =>
    @directionsService = new google.maps.DirectionsService() unless @directionsService
    @directionsDisplay = new google.maps.DirectionsRenderer() unless @directionsDisplay
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

  # When clicking on the map, load a full google maps page.
  link_map: (addrs) =>
    mapUrl = 'https://www.google.com/maps/dir/' + addrs.reduce ( (previous, addr) -> previous + encodeURIComponent(addr) + '/' ), ''
    google.maps.event.addListener @map_obj, 'click', () =>
      if window.location.search.match(/debugMode=true/)
        console.log 'routing to map', mapUrl
      else
        window.location = mapUrl

  calc_distance_from_route: ( route ) ->
    distance = 0
    try
      distance = route.legs.reduce ( (previous, leg) -> previous + leg.distance.value ), 0
    catch err
      console.log 'Error calculating distance: ' + err.message
    if window.location.search.match(/debugMode=true/)
      console.log 'distance from route is', distance, @meters_to_miles( distance ), 'miles'
    return distance

  calc_route: (addrs) =>
    return if addrs.length < 2
    @link_map(addrs)
    start = addrs.shift()
    end = addrs.pop()
    waypts = []
    for addr in addrs
      waypts.push({location: addr, stopover: true})
    if waypts.length > 8
      console.log 'Warning: too many waypoints, map will not be accurate.'
    request =
      origin: start
      destination: end
      waypoints: waypts
      travelMode: google.maps.TravelMode.DRIVING
    @directionsService.route request, (result, status) =>
      if status is google.maps.DirectionsStatus.OK
        @map_distance = false
        if waypts.length <= 8
          @map_distance = @calc_distance_from_route( result.routes[0] )
        @double_check_distance()
        @directionsDisplay.setDirections result
      else
        console.log 'Error loading map: ', result, status
      # FIXME: display any google errors
      # (https://developers.google.com/maps/documentation/javascript/reference#DirectionsStatus)

  double_check_distance: () =>
    @remove_distance_warning()
    return unless @map_distance
    voyageur_distance = @meters_to_miles @model.get( 'distance' )
    return unless voyageur_distance > 0
    map_distance = @meters_to_miles @map_distance
    if map_distance != voyageur_distance
      if window.location.search.match(/debugMode=true/)
        console.log 'Warning: distance calculations do not match:', voyageur_distance, 'miles (voyageur) !=', map_distance, 'miles (google map)'
      @add_distance_warning(voyageur_distance, map_distance)

  remove_distance_warning: () =>
    $('#trip-distance .distance .error').remove()

  add_distance_warning: (voyageur_distance, map_distance) =>
    $('#trip-distance .distance').append( ' <abbr class="error text-warning" title="The Voyageur calculation (' + voyageur_distance + ') does not match that of the map (' + map_distance + ').">(map reports ' + map_distance + ')</abbr>' )
