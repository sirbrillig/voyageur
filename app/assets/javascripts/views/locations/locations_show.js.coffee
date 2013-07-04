class Voyageur.Views.Location extends Backbone.View
  tagName: 'li'

  template: JST['locations/show']

  initialize: =>
    console.log "location: ", @model
    @model.bind 'remove', => @model.destroy()

  render: (trip_id) =>
    @setElement @template({location: @model, trip_id: trip_id})
    this
