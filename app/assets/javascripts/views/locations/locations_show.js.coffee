class Voyageur.Views.Location extends Backbone.View
  tagName: 'li'

  template: JST['locations/show']

  events:
    'click a.add-button': 'add_location_to_trip'

  initialize: =>
#    console.log "location: ", @model

  render: =>
    @setElement @template({location: @model, trip_id: Voyageur.get_trip_id()})
    this

  add_location_to_trip: (e) =>
    e.preventDefault() if e
    triploc = @model.create_triplocation()
    url = 'trips/' + Voyageur.get_trip_id() + '/add/' + @model.id
    $.ajax url,
      type: 'GET',
      success: ->
        Voyageur.trip_view.model.fetch()
