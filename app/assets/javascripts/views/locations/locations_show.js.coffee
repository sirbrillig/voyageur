class Voyageur.Views.Location extends Backbone.View
  tagName: 'li'

  template: JST['locations/show']

  events:
    'click a.add-button': 'add_location_to_trip'

  initialize: =>
    console.log "location: ", @model
    @model.bind 'remove', => @model.destroy()

  render: =>
    @setElement @template({location: @model, trip_id: Voyageur.get_trip_id()})
    this

  add_location_to_trip: (e) =>
    # NOTE: it would be nice to add the triplocation directly to the trip in the
    # UI, but that would require building a triplocation from scratch using the
    # location (and no ID!) and that's not a simple thing.
    e.preventDefault()
    url = 'trips/' + Voyageur.get_trip_id() + '/add/' + @model.id
    console.log url
    $.ajax url,
      type: 'GET',
      success: ->
        Voyageur.trip_view.model.fetch()
