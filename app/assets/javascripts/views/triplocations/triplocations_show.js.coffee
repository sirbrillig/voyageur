class Voyageur.Views.Triplocation extends Backbone.View
  tagName: 'li'

  template: JST['triplocations/show']

  events:
    'click a.remove-button': 'remove_location'
    'drop': 'drop'

  render: =>
    @setElement @template({triplocation: @model})
    this

  remove_location: (e) =>
    e.preventDefault() if e
    @model.destroy()
    @remove()

  drop: (e, index) =>
    @$el.trigger 'update-sort', [ @model, index ]
