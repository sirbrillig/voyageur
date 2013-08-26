class Voyageur.Views.Triplocation extends Backbone.View
  tagName: 'li'

  template: JST['triplocations/show']

  events:
    'click a.remove-button': 'remove_location'

  initialize: =>
#    console.log "triplocation: ", @model

  render: =>
    @setElement @template({triplocation: @model})
    this

  remove_location: (e) =>
    e.preventDefault() if e
    @model.destroy()
    @remove()
