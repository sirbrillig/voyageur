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
    # NOTE: is there a way to avoid keeping the trip view reference like this?
    Voyageur.trip_view.add_location(@model.triplocation_json())
