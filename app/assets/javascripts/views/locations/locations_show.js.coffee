class Voyageur.Views.Location extends Backbone.View
  tagName: 'li'

  template: JST['locations/show']

  events:
    'click a.add-button': 'add_location_to_trip'

  initialize: =>
    console.log "location: ", @model
    @model.bind 'remove', => @model.destroy()

  render: (trip_id) =>
    @setElement @template({location: @model, trip_id: trip_id})
    this

  add_location_to_trip: (e) =>
    e.preventDefault()
    url = 'trips/' + Voyageur.get_trip_id() + '/add/' + @model.id
    console.log url
    $.ajax url,
      type: 'GET',
      success: ->
        Voyageur.trip_view.model.fetch()
