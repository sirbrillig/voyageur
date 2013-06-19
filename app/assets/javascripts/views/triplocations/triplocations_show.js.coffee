class Voyageur.Views.Triplocation extends Backbone.View
  tagName: 'li' # FIXME: this renders the view in an li, but the view *is* an li, so you get two.

  template: JST['triplocations/show']

  events:
    'click a.remove-button': 'remove_location'

  initialize: =>
    console.log "triplocation: ", @model

  render: =>
    @$el.html @template({triplocation: @model})
    this

  remove_location: (e) =>
    e.preventDefault()
    # FIXME: do this
